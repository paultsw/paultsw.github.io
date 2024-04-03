---
layout: post
title:  "CUDA and Triton for beginners"
date:   2024-04-02 17:00:00 -0400
tags: computer-science machine-learning gpu hpc
share: false
---

This is a quick, no-frills introduction to writing GPU code on Kaggle, which offers free notebooks for analysis thanks to a tie-up with Google. Kaggle notebooks are similar to Colab instances, but they also offer cheaper and higher memory GPU-enabled instances (as of this writing).

In this (hopefully) quick blog post, I'm going to dive through a quick example of how to allocate GPUs on Kaggle, and then show how to develop and benchmark kernels in the same notebook by comparing Numba/CUDA-developed kernel performances to Triton performances.

- - - - -
## Background

Machine learning is a major drain on computational resources, but it can be sped up by adopting heterogeneous co-processors, such as a GPU or a TPU. The reason for this is the sheer number of parallel operations involved --- linear algebra operations such as dot products, matrix multiplications, and other parallelizable (frequently, [embarassingly parallel](https://en.wikipedia.org/wiki/Embarrassingly_parallel)) operations.

- - - - -
## Softmax and matrix multiplications

The full Kaggle notebook for this post can be found [here](https://www.kaggle.com/code/paultsw/writing-cuda-and-triton-kernels).

In the below, we'll implement two kernels: a softmax function and a matrix multiplication method [^deepl]. These are pretty standard functions that exist in any machine learning library, but we'll choose these two for didactic purposes.

I assume the reader is familiar with secondary school linear algebra, so I'll skip the definition of matrix multiplication. The softmax function is:

$$
\sigma(\vec{x},\tau) = \frac{\exp(\tau \vec{x})}{\sum_{i=1}^{n} \exp(\tau x_i)}
$$

Or in Python:

{% highlight python %}
def softmax(arr: np.array, temp: float) -> np.array:
  expons = np.exp(temp*arr)
  return expons / np.sum(expons)
{% endhighlight %}

One interesting (but irrelevant) note is that the softmax function is $\nabla \mbox{logsumexp}(x)$, the gradient of the log-sum-exp function. Another interesting (and very relevant) note concerns the `temp` parameter, which is a scalar parameter that controls how close to uniform the outputs look. (Technically, the implementations above refer to _inverse_ temperature.)

- - - - -
### Using GPU instances on Kaggle

Kaggle offers GPU instances for free through their notebooks (as of this writing --- March 2024 --- it is limited to 30 hours of GPU usage per week). So far, they offer NVidia P100s (the Pascal architecture from a decade ago), and double NVidia T4 GPUs as well. A third option is access to Google TPUs, which play well with Jax/XLA and Tensorflow.

To use GPU instances on Kaggle, all you need to do is start a Kaggle notebook and select the appropriate co-processor from the right-hand drop-down menu under "accelerator".

- - - - -
### A quick primer on the CUDA GPU development model

GPUs sold by Nvidia with CUDA support are based on a heterogeneous computing model; it distinguishes the primary CPU, or _host_ (which typically you can think of as the one that runs the main code, has a program counter, has access to the kernel via libraries, and so on) with the GPU or _device_, which runs _kernels_. Kernels are programs that only exist on the GPU and perform work on data stored within the GPU memory hierarchy.

![The CUDA computing model, per Nvidia.](https://developer.nvidia.com/blog/wp-content/uploads/2020/06/memory-hierarchy-in-gpus-2.png)

_Threads_ are the primary work units of a GPU. Each thread represents a series of operations on a given 

Threads are organized into _blocks_ of threads; the entire _grid_ of all threads available on a single device is split up onto blocks. Why this hierarchy? Because blocks can have common-shared memory, which frequently speeds up computation on the whole input array stored in global memory (see below). You can also reshape the geometry of the GPU using thread/block specifications, so that e.g. you can more naturally represent two dimensional matrices or three dimensional tensors using natural units instead of working with clunky strides.

_Streaming multiprocessors_ are compute nodes within a GPU; they handle one warp (32 threads, as of this writing) at a time, and can operate independently of each other; this can create latency speed-ups while also opening up synchronization issues that need to be resolved with, e.g., atomic compare-and-swap operations. You can synchronize all threads in a block using a call to `syncthreads()` to run a (time-expensive) barrier operation before continuing with other work down the line.

GPUs have three levels of data. In order of decreasing size (but increasing latency of access), they are:
* _global device memory_ is the slowest to access, but the largest, in the tens of gigabytes as of this writing; global memory is accessible by all streaming multiprocessors (SMs). Hosts can only really write to and read from global memory in a costly operation.
* _shared memory_ is shared by all threads in a given block. This can be directly allocated using `cuda.shared.array()`.
* _local memory_ is a collection of ultra-fast _registers_ which we use to store local variables.

Finally, how do we actually _write_ CUDA kernels?

CUDA kernels are written from the point of view of a single thread executing the kernel. In other words, we typically follow the following format when writing CUDA kernels:

1. fetch the _index_ of the thread: this is its position either with respect to a single block or with respect to the entire grid.
2. perform an operation on the thread, referencing a location in global or shared memory as necessary.
3. perform all intercommunications by reading/writing to global/shared memory as necessary.
4. block until all threads finish if necessary.
5. continue with additional operations.

For instance, a CUDA kernel to add two big arrays might look like the following:

{% highlight python %}
def add_kernel(A, B, C):
	# get index of thread:
	idx = cuda.grid(1)
	# add A and B and store in output array:
	C[idx] = A[idx] + B[idx]
{% endhighlight %}

We always feed all three arrays into the kernel, including the (typically empty) array that contains the output. All inputs should be device arrays, i.e. residing in global memory already.

- - - - -
### Writing CUDA kernels with Numba

Let's write some CUDA kernels with Numba.

Matrix multiplication is quite basic (though there is an optimized way of doing this): we use a two dimensional grid to store the input and output matrices.

{% highlight python %}
@cuda.jit
def cuda_matmul(A, B, C, m, n, p):
    """Matrix Multiplication kernel: C = A*B.
    Where C ~ (m,n), A ~ (m,p), B ~ (p,n).
    """
    r, c = cuda.grid(2)
    # check bounds and accumulate matrix multiplication values:
    if (r < m) and (c < n):
        tmp = 0.
        for k in range(p):
            tmp += A[r,k]*B[k,c]
        C[r,c] = tmp
{% endhighlight %}

Softmax requires a bit more finesse, since we have to communicate between threads in order to calculate the maxima and sums:

{% highlight python %}
@cuda.jit
def softmax_example(result, values):
	"""Find softmax of values and store in result."""
	max_example(result, values)
	max_val = result[0]
	cuda.atomic.compare_and_swap(result, max_val, 0)
	cuda.synchronize()
	sum_example(result, values)
	sum_val = result[0]
	cuda.atomic.compare_and_swap(result, max_val, 0)
	cuda.synchronize()
	idx = (cuda.blockIdx.x * cuda.blockDim.x) + cuda.threadIdx.x
	z = values[idx] - max_val
	numer = np.exp(z)
	result[idx] = numer / sum_val@cuda.jit
{% endhighlight %}

...Where the `max_example` and `sum_example` CUDA kernels are not implemented here (left as an exercise), but simply compute the array-wise max and sum, storing the value in the first index of the `result` output array.

- - - - -
### Fast compiled code with Triton

Unfortunately, Kaggle's GPUs (T4s and P100s) are a bit old and don't support `cudatoolkit` versions that are compatible with Triton. That said, it's still possible to run Triton in CPU-only mode, so we'll show how to use it in the case of CPU-only compilation with Triton --- and compare it against the CPU version of Numba.

In a future update to this blog post, we'll add the GPU benchmarks (watch this space!); but for now, we'll have to be content with the CPU benchmarks.

`WATCH THIS SPACE!`

- - - - -
## Conclusions

I hope this has been a useful primer on writing CUDA code. Kaggle notebooks are free and the GPU access, even if using less-than-cutting-edge devices, is extremely useful for machine learning engineers who may not have easy access to GPUs for development or learning otherwise.

Looking forward, this post will eventually be updated with Triton kernels... Assuming I can get them to work. Additionally, a speedtest should be implemented soon after that!

- - - - -
## References

[walia](https://www.kaggle.com/code/harshwalia/1-introduction-to-cuda-python-with-numba)
Harsh Walia posted this excellent three-part notebook on CUDA development on Kaggle, and I'm grateful to have been able to read their work. Thanks `@harshwalia`!

[triton](https://triton-lang.org/main/index.html)
The documentation for Triton.

[numba](https://numba.readthedocs.io/en/stable/cuda/index.html)
The CUDA documentation for Numba.

[cuda](https://nvidia.github.io/cuda-python/overview.html)
The documentation for CUDA proper (Python version).

[deepl](https://www.deeplearningbook.org)
Overviews of the softmax function and matrix multiplication can be found in this classic deep learning textbook by Goodfellow, Bengio, and Courville.
