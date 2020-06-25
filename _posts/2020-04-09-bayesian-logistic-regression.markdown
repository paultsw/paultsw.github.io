---
layout: post
title:  "Models for binary outcomes, inference via data augmentation, and the Pólya-Gamma distribution"
date:   2020-04-09 15:15:58 -0400
tags: math bayes stats
share: false
---

Let's say you want to model binary outcomes. This is simple if you want a maximum likelihood estimate of a linear set of weights --- just perform a logistic regression. But what do we do if we want to perform Bayesian inference?

In this blog post, we'll look at how we can fit a Bayesian interpretation onto logistic regression via a novel distribution called the _Polya-Gamma_ distribution. The first section will review two popular ways to model dependent binary outcomes: the logistic regression model and the probit regression model. The latter readily admits a Bayesian interpretation thanks to a convenient link function that allows us to sample from the posterior via a (so-called) _data augmentation trick_. The former, until recently, did not admit a similar trick due to complications with the form of the logistic function. To permit this approach, we introduce the Polya-Gamma distribution of Polson et al in section 3. Finally, we present a data aumentation trick that permits bayesian inference for the logistic regression model using the novel Polya-Gamma distribution, followed by some concluding thoughts and some references.

_(N.B.: the proper spelling for the distribution is "Pólya-Gamma" --- named after mathematician George Pólya --- but I'll sometimes spell it as "Polya-Gamma" due to the lack of diacritic markers on my keyboard.)_

The logistic model and the probit model
---------------------------------------
Broadly, there are two popular models for binary outcomes: the _logistic regression_ model, traditionally favored by frequentists, and the _probit regression_ model, traditionally favored by bayesians due to the relative ease of sampling from the posterior.

Formally, we have the following context: say we have $$N \gg 1$$ datapoints $$D := \{ (x_1,y_1), \ldots (x_N, y_N) \}$$ where each $$x_i \in \mathbb{R}^K$$ is a vector of regressors and $$y_i \in \{0,1\}$$ is a binary response. Set $$X = \{ x_i \}_{i=1}^N$$ and $$Y = \{ y_i \}_{i=1}^N$$. Assume that each datapoint $$(x,y)$$ is generated independently from the same identical process and that random $$y$$ is dependent upon deterministic $$x$$. Let $$w := (w_1, w_2, \ldots, w_K)$$ be a vector of parameters, which relate to $$X$$ and $$Y$$ in a way dependent upon the model (to be discussed further below).

Bayesian models involve the following three ingredients: a _prior_ $$p(w)$$ distribution on the vector of parameters; a _likelihood_ function

$$
\mathcal{L}(w;D) := p(D|w) = \prod_i p(y_i|x_i, w),
$$

also called a _sampling_ or _data_ distribution; and a _posterior_
$$
p(w|D),
$$
which is determined by the form of the above two distributions.

The three distributions are linked via Bayes' theorem:

$$
p(w|D) \propto p(D|w) \cdot p(w).
$$

Note that frequentist statistics focus primarily on obtaining point estimates of properties of the likelihood function, e.g.

$$
\hat{\beta} = \mbox{argmax}_\beta \mathcal{L}(\beta|D).
$$

The probit model and the logistic regression model are examples of _generalized linear models_ (GLMs), a type of model in which the response variables $$y$$ are drawn from a known distribution $$F(y; \theta)$$ in which the parameters $$\theta = (\theta_1, \theta_2, \ldots, \theta_m)$$ defining the distribution is known, deterministic function $$\theta = g^{-1}(\psi)$$ of the linear combination $$\psi := x^\top w$$. In other words, we add a "nonlinear layer" on top of the linear combination $$\psi$$ to pick a particular distribution

$$
f = F(y; g^{-1}(\psi)) = F(y; g^{-1}(x^\top w))
$$

from which we draw $$y$$. $$F$$ is called _distribution_ of the GLM and $$g$$ is called the _link function_.

For the probit regression model, we use $$g(q) = \Phi^{-1}(\psi)$$ the inverse CDF of the standard normal, and $$F = Bern(q)$$; this gives us

$$
y \sim Bern(\Phi(x^\top w))
$$

and a likelihood function

$$
\mathcal{L}(w; D) = \prod_{i=1}^N p(y_i | w) = \prod_{i=1}^N \Phi(x_i^\top w)^{y_i} (1 - \Phi(x_i^\top w))^{1-y_i}.
$$

For the logistic regression model, we use $$F = \mbox{Bern}(\sigma(\psi))$$ for inverse link function $$\sigma$$ the logistic function (hence the name):

$$
\sigma(u) = (1 + \exp(-u))^{-1} \; \forall u \in \mathbb{R}.
$$

Note also that this means we can interpret $$\psi$$ as the _log-odds_ of the parameter $$q$$ for $$F = \mbox{Bern}(q)$$, as we have

$$
\sigma(\ln \frac{q}{1-q}) = (1 + \frac{1-q}{q})^{-1} = q.
$$

For the logistic regression model, we obtain the following likelihood:

$$
\mathcal{L}(w; D) = \prod_{i=1}^N p(y_i | w) = \prod_{i=1}^N \sigma(x_i^\top w)^{y_i} (1 - \sigma(x_i^\top w))^{1-y_i}.
$$

Bayesian inference for the probit model via data augmentation
-------------------------------------------------------------
Why do bayesians prefer the probit regression model over the logistics regression model? A major reason is due to the data augmentation strategy developed by Albert & Chib (see references) that allows for efficient sampling from the posterior distribution $$p(w|D)$$, which in turn relies on the smoothness of the density of the normal distribution.

Fundamentally, note that the probit regression model in the previous section can be equivalently expressed as a hierarchical latent variable model:

$$
u_i \sim \mathcal{N}(\psi, 1) = \mathcal{N}(x_i^\top w, 1)
y_i := [u_i > 0] = 1 \mbox{ if } (u_i > 0), \; \; 0 \mbox{ if } (u_i \leq 0)
$$

...where we've used the Iverson bracket $$[u_i > 0]$$ to indicate a binary function equal to one if and only if the statement inside the bracket is true.

Why is this equivalent to the probit regression model? The key is to notice that

$$
\Phi(\psi) = \mathbb{P}(\mathcal{N}(0,1) \leq \psi) = \mathbb{P}(\mathcal{N}(\psi,1) > 0) = \mathbb{P}(u > 0),
$$

which gives the equivalence between the latent variable model and the original statement of the probit regression model using the Bernoulli distribution.

Finally, this gives an efficient Gibbs sampler for the posterior $$p(w | X, Y)$$ when the prior $$p(w)$$ is normally distributed, thanks to the fact that the normal distribution is conjugate to itself: if we place a normal prior
$$
w \sim \mathcal{N}(\mu_w, \Sigma_w),
$$

then the following alternating sampling steps constitute a Gibbs sampler for the posterior:

$$
\begin{align}
& u|w, x, y=0 \sim \mathcal{N}(\psi, 1) [u < 0]; \\
& u|w, x, y=1 \sim \sim \mathcal{N}(\psi, 1) [y \geq 0]; \\
& w|u,x,y \sim \mathcal{N}(V(\Sigma_w^{-1} \mu_w + X^\top Y), \Sigma) \\
\end{align}
$$

where

$$
V := (\Sigma_w^{-1} + X^\top X)^{-1}.
$$

For the full derivation of the above Gibbs sampler, consult [Albert & Chib (1993)](https://www.tandfonline.com/doi/abs/10.1080/01621459.1993.10476321), which was the first to derive the strategy.


The Polya-Gamma distribution
----------------------------
It's difficult to use the same data augmentation trick to perform posterior inference for the logistic model, which in the latent variable formulation assumes that errors in the latent variable are distributed as a logistic rather than a normal:

$$
u_i \sim \mbox{Lo}(\psi, 1) = \mbox{Lo}(x_i^\top w, 1)
y_i := [u_i > 0] = 1 \mbox{ if } (u_i > 0), \; \; 0 \mbox{ if } (u_i \leq 0)
$$

where the density of the standard logistic distribution is given as

$$
f_{\mbox{Lo}}(x; 0, 1) = \frac{\exp(-x)}{(1+\exp(-x))^2};
$$

the logistic distribution is so named because the CDF of the standard logistic distribution is the logistic function $$(1+\exp(-x))^{-1}$$.

Ease of interpretation may seem like a good reason to use probit regression --- and indeed this is frequently a good justification --- but it can sometimes be advantageous to use a _platykurtotic_ distribution, or a distribution with heavier tails than the normal. Hence we'd like to have an efficient Gibbs sampler for logistic regression in the same way that we have an efficient Gibbs sampler for probit regression.

For a long time, there was no way to efficiently generate exact samples from the posterior in the logistic regression model; instead, one had to use approximate methods like [variational bayes](http://keyonvafa.com/logistic-regression-bbvi/) or approximate sampling methods. This led to the preference for the probit regression model over the logistic regression model among bayesian statisticians. Recently, however, a paper by Polson, Scott, & Windle introduced a class of _Polya-Gamma_ distributions --- denoted $$PG(b,z)$$ for positive integral $$b \in \mathbb{N}$$ and continuous $$z \in \mathbb{R}$$ --- which enable a Gibbs sampler by representing the logistic regression model using a $$PG(b,z)$$-distributed latent variable instead of a logistic-distributed latent variable; this is the subject of the next section of this post.

Formally, the class of Polya-Gamma distributions is equivalent in law to an infinite mixture of Gamma distributions:

$$
PG(b,z) = \frac{1}{2^\pi^2} \sum_{k=1}^{\infty} \frac{\gamma_k}{(k - 1/2)^2 + z^2/(4\pi^2)},
$$

where the equality refers to equality of distributions (i.e., in law), and the numerators are random i.i.d. draws from the same Gamma distribution:

$$
\forall k \in \mathbb{N}, \, \gamma_k \sim \Gamma(b,1).
$$

Indeed, this offers a naive way to sample from $$PG(b,z)$$ --- sample several times from a gamma and keep a running weighted sum until the running variance falls below a threshold. However a much more efficient sampler based on rejection sampling is given in the paper, following work by Devroye [(2009)](https://econpapers.repec.org/article/eeestapro/v_3a79_3ay_3a2009_3ai_3a21_3ap_3a2251-2259.htm) based on his [groundbreaking book on sampling methods](http://www.nrbook.com/devroye/). I won't delve into the details, but a naive Python-based implementation is contained within the accompanying [github repo](https://github.com/paultsw/polya-gamma-post/) for this blog post.

For a glimpse of the $$PG(b,z)$$ distribution, I've reproduced some of the density plots for varying parameters using my sampler.

First, holding the first parameter constant and varying the second parameter:
![PG(1,c) for varying 'c'](https://raw.githubusercontent.com/paultsw/polya-gamma-post/master/images/PG_1_c.png "PG(1,c) for varying 'c'")
Then, varying the first parameter while holding the second parameter fixed:
![PG(b,0) for varying 'b'](https://raw.githubusercontent.com/paultsw/polya-gamma-post/master/images/PG_b_0.png "PG(b,0) for varying 'b'")

Note that the aberrations on the tail are due to the [kernel density estimation](https://en.wikipedia.org/wiki/Kernel_density_estimation) plotting algorithm, which draws a density by fitting a number of Gaussian kernels to empirical data. The tail may be smoothed out by judicious choice of the bandwidth parameter in the KDE plotting algorithm, but I've elected to avoid doing this for the purposes of this post.

Bayesian inference for logistic regression using Pólya-Gammas
-------------------------------------------------------------
What's notable about the Polya-Gamma distribution is that it allows us to develop a Gibbs sampler for the posterior of the above model, via a latent variable trick much like what we did with the probit model: the paper notes that the Polya-Gamma distribution has the following unique property that facilitate the existence of a Gibbs sampler: for any integer $$b > 0$$, let $$p(u)$$ be the density of a random variable $$u \sim PG(b,0)$$. Then for all $$a \in \mathbb{R}$$ and $$\psi \in \mathbb{R}$$, the following holds:

$$
\frac{(\exp(\psi))^a}{(1+\exp(\psi))^b} = \frac{\exp(\kappa \psi)}{2^b} \int_0^\infty \exp(-u\psi^2 / 2) p(u) du,
$$

where
$$
\kappa := a - (b/2).
$$
Further, we have that the conditional distribution
$$
p(u | \psi) = PG(b,\psi)
$$
when

$$
(u,\psi) \propto \exp(-u\psi^2 / 2) p(u).
$$
This is a useful property because the likelihood of observing a single datapoint in the logistic regression model is given by:

$$
\mathcal{L}_i(w) = \frac{(\exp(x_i^\top w))^{y_i}}{1 + \exp(x_i^\top w)};
$$

combining this likelihood with the above theorem gives the following Gibbs sampling strategy:

$$
w \sim \mathcal{N}(\mu, \Sigma)
u | w \sim PG(1,\psi)
w | u, x, y \sim \mathcal{N}(m_u, V_u)
$$

where

$$
V_u := (X^\top U X + \Sigma^{-1})^{-1},
m_u := V_u(X^\top \kappa + \Sigma^{-1} \mu),
\kappa := (y_1 - \frac{1}{2}, y_2 - \frac{1}{2}, \ldots, y_N - \frac{1}{2}),
U := \mbox{diag}(u_1, u_2, \ldots, u_N).
$$

In python, the above can be implemented in thirteen lines of code:

{% highlight python %}
def sample_posterior_logistic_regression(beta_mean, beta_cov, X, Y, burnin=20, nsamples=100):
    """
    Given a beta RV with a multivariate normal prior N(beta_mean, beta_cov), sample from the
    posterior distribution (beta | y, omega) using a data-augmentation strategy that assumes
    a polya-gamma-distributed latent variable omega.
    
    Args:
    * beta_mean: ndarray of shape (D,)
    * beta_cov: ndarray of shape (D,D)
    * X: ndarray of shape (N,D)
    * Y: ndarray of shape (N), all values either 0. or 1.
    * burnin: int
    * nsamples: int
    """
    beta = stats.multivariate_normal.rvs(mean=beta_mean, cov=beta_cov)
    posterior_samples = []
    for _ in tqdm(range(burnin + nsamples)):
        # first step:
        psis = np.dot(X,beta)
        omegas = np.array([ polya_gamma_rv(1, psis[k]) for k in range(psis.shape[0]) ])
        # second step:
        kappa = Y - (np.ones_like(Y) * 0.5)
        inv_covar = np.linalg.inv(beta_cov)
        V_omega = np.linalg.inv(X.T @ np.diag(omegas) @ X + inv_covar)
        m_omega = V_omega @ (np.dot(X.T, kappa) + np.dot(inv_covar,beta_mean))
        beta = stats.multivariate_normal.rvs(mean=m_omega, cov=V_omega)
        # append sample to list of samples
        posterior_samples.append(beta)
    return np.array(posterior_samples)
{% endhighlight %}

In the github repo corresponding to this blog post, I've added a [Jupyter notebook](https://github.com/paultsw/polya-gamma-post/blob/master/Bayesian%20Inference%20for%20Logistic%20Regression.ipynb) demonstrating the application of the Gibbs sampler for Bayesian inference on a logistic regression task based on the [Pima Indian diabetes dataset](https://www.kaggle.com/uciml/pima-indians-diabetes-database).

The full details are better explored through the notebook, but my ad-hoc implementation seems to work. First, a quick test to visually confirm that the posterior on an artificially-generated dataset has a lower degree of dispersion compared to the prior:

![Posterior vs prior on artificial data.](https://raw.githubusercontent.com/paultsw/polya-gamma-post/master/images/posterior_vs_prior.png "Posterior vs prior on artificial data.")

Then, on the Pima Indian diabetes data, I used a normal prior for the weights and ran the above Gibbs sampler to construct a posterior density for the parameters. I plotted the maximum-likelihood estimates (from `sklearn`'s [logistic regression module](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html)) for each weight on top of the sampler-constructed posterior for that weight:

![Posterior vs MLE on Pima Indian diabetes data.](https://raw.githubusercontent.com/paultsw/polya-gamma-post/master/images/posterior_vs_mle.png "Posterior vs MLE on Pima Indian diabetes data.")


Conclusion
----------
Through the above, we can see that the Polya-Gamma distribution permits a flexible bayesian interpretation of the logistic regression model; the original paper by Polson et al actually permits a wider range of discrete binary and count-based regression models to be analyzed through the bayesian framework using the same latent variable data augmentation strategy above. Further investigations are necessary to discover more relevant mathematical properties, but the Polya-Gamma distribution seems to hold a lot of promise for enabling efficient Bayesian inference for a large class of models.


References
----------
* The code corresponding to this post is at [`https://github.com/paultsw/polya-gamma-post`](https://github.com/paultsw/polya-gamma-post).

* _Bayesian inference for logistic models using Polya-Gamma latent variables_, Nicholas G. Polson, James G. Scott, Jesse Windle. [(ArXiv)](https://arxiv.org/abs/1205.0310)

* _Bayesian analysis of binary and polychotomous response data_, James H. Albert & Siddhartha Chib. [(PDF)](http://www.stat.cmu.edu/~brian/905-2009/all-papers/albert-chib-1993.pdf)
