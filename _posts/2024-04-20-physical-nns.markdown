---
layout: post
title:  "Physical neural networks?"
date:   2024-04-20 17:00:00 -0400
tags: computer-science machine-learning mathematics statistics deep-learning physics
share: false
---

Modern AI models such as OpenAI's GPT, Anthropic's Claude, Meta's LLaMA, and Google's Gemini have set off [a boom in](https://www.perenews.com/pimco-targets-e750m-for-first-data-center-fund/) [data center construction](https://www.bloomberg.com/news/articles/2024-01-29/blackstone-is-building-a-25-billion-ai-data-center-empire) and a [staggering rally in Nvidia thanks to the demand for their (over USD40,000) chips](https://www.reuters.com/technology/nvidias-results-spark-nearly-300-billion-rally-ai-stocks-2023-05-24/); [machine learning models suck up a lot of electricity due to their compute-expensive training loops](https://www.sciencedirect.com/science/article/pii/S0743731518308773), and [total ML modeling power consumption is as much as a small country](https://www.vox.com/climate/2024/3/28/24111721/ai-uses-a-lot-of-energy-experts-expect-it-to-double-in-just-a-few-years). Small wonder that there is interest in energy-efficient machine learning methods; from the last article (emphasis mine):

> One of the areas with the fastest-growing demand for energy is the form of machine learning called generative AI, which requires a lot of energy for training and a lot of energy for producing answers to queries. _Training a large language model like OpenAI’s GPT-3, for example, uses nearly 1,300 megawatt-hours (MWh) of electricity_, the annual consumption of about 130 US homes. According to the IEA, a single Google search takes 0.3 watt-hours of electricity, while a ChatGPT request takes 2.9 watt-hours. (An incandescent light bulb draws an average of 60 watt-hours of juice.) If ChatGPT were integrated into the 9 billion searches done each day, the IEA says, the electricity demand would increase by 10 terawatt-hours a year — the amount consumed by about 1.5 million European Union residents.

One potentially very exciting avenue for this is in developing neural networks that use fundamentally different physical representations versus silicon chips. These are chips that use completely different physics versus the silicon integrated circuits that comprise, say, Nvidia H100s.

This post is a brief dive into two promising approaches for physical representations of neural networks: optical neural networks (which use photonic circuits, making use of the energy-efficient transport of photons versus electrons), and quantum neural networks (which use quantum-mechanical properties to unlock the ability to perform efficient matrix operations).

- - - - -

## Optical neural networks: training with photons

Optical neural networks, or ONNs, are neural networks implemented with photonic chips; photonic chips, in turn, are desirable due to the significantly lower energy needed to move photons around as opposed to electrons --- photonic mobility comes almost for free.

That said, the "right" way to implement these things is still being researched. Some options include:
* _free space optics_ --- a method that lends massive parallelism by allowing photons to move through optical masks in free space, this uses a series of lenses to physically implement operations like fourier transforms (which originally come from physics anyway). One approach to this, which uses phase masks that are 3D-printed (but cannot be trained efficiently) comes from 2018: see _All-optical machine learning using diffractive deep neural networks_(https://www.science.org/doi/full/10.1126/science.aat8084) by Lin, Rivenson, et al.
* _silicon photonics_ --- these use photonic circuits which constrain photons to follow particular pre-fabricated circuit paths, which has the downside of not having the parallelism in the free space approach (though they retain many of the efficiency and speed gains). These may be more easily interfaced with traditional silicon-electronic integrated circuits.
* There are some older approaches that are no longer favored, including an approach based on volume holograms. [See this link for a review from 1993](https://infoscience.epfl.ch/record/158511?v=pdf).

As of this writing, [one of the most promising real-life optical neural network chips is the taichi system](https://www.science.org/doi/10.1126/science.adl1203) developed by researchers at Tsinghua University in Beijing, which has the ability to store a 13-14 million neuron optical neural network, and which has been able to show extreme energy efficiency compared to Nvidia's (as of this writing) leading H100 chips:

> Neural networks that imitate the workings of the human brain now often generate art, power computer vision, and drive many more applications. Now a neural network microchip from China that uses photons instead of electrons, dubbed Taichi, can run AI tasks as well as its electronic counterparts with a thousandth as much energy, according to a new study.
> All in all, the researchers found Taichi displayed an energy efficiency of up to roughly 160 trillion operations per second per watt and an area efficiency of nearly 880 trillion multiply-accumulate operations (the most basic operation in neural networks) per square millimeter. This makes it more than 1,000 times more energy efficient than one of the latest electronic GPUs, the NVIDIA H100, as well as roughly 100 times more energy efficient and 10 times more area efficient than previous other optical neural networks.

That said, though, there are some caveats:
> Although the Taichi chip is compact and energy-efficient, Fang cautions that it relies on many other systems, such as a laser source and high-speed data coupling. These other systems are far more bulky than a single chip, “taking up almost a whole table,” she notes. In the future, Fang and her colleagues aim to add more modules onto the chips to make the whole system more compact and energy-efficient.

And how does it perform?
> For instance, previous optical neural networks usually only possessed thousands of parameters—the connections between neurons that mimic the synapses linking biological neurons in the human brain. In contrast, Taichi boasts 13.96 million parameters.
> Previous optical neural networks were often limited to classifying data along just a dozen or so categories—for instance, figuring out whether images represented one of 10 digits. In contrast, in tests with the Omniglot database of 1,623 different handwritten characters from 50 different alphabets, Taichi displayed an accuracy of 91.89 percent, comparable to its electronic counterparts.
> The scientists also tested Taichi on the advanced AI task of content generation. They found it could produce music clips in the style of Johann Sebastian Bach and generate images of numbers and landscapes in the style of Vincent Van Gogh and Edvard Munch.

Above quotes taken from [this _IEEE Spectrum_ article](https://spectrum.ieee.org/optical-neural-network), which references the original article in _Science_ linked above.

- - - - -

## Quantum neural networks: manipulating schroedinger's equation for deep learning

Quantum neural networks --- neural networks implemented on quantum computer architectures and taking advantage of quantum gates --- have been considered since Feynman proposed quantum computing as a concept in the 1980s, though serious study of quantum neural networks have gradually picked up pace since the early 2000s. In this section, we point out three relevant papers.

The first dates to 2011: [_Neural networks with quantum architecture and quantum learning_ by Panella and Martinelli](https://onlinelibrary.wiley.com/doi/10.1002/cta.619) proposes a way to implement QNNs with quantum circuits. Interestingly, they don't use backprop at all; rather, quantum computers can perform parameter search using exhaustive search, which is actually efficiently feasible when we have access to a sufficiently sophisticated quantum computer. This implies that QNNs are quite different from classical neural networks; there is the potential that the expensive backprop and gradient descent-based training routines can be completely obviated altogether when we are allowed to use methods based on quantum superposition.

[_Quantum perceptron over a field and neural network architecture selection in a quantum computer_ by Da Silva et al (2016)](https://arxiv.org/abs/1602.00709) proposes a QNN called "quantum perceptron over a field" (QPF) that directly generalizes a classical perceptron, and additionally proposes a quantum computing algorithm to search over weights and architectures in polynomial time.

Finally, [_Efficient learning for deep quantum neural networks_ by Beer et al (2019)](https://arxiv.org/abs/1902.10445) proposes _deep QNNs_ by defining a quantum perceptron as a unitary operators taking _m_ qubits to _n_ qubits. An _L_-layer QNN, by analogy with classical feedforward neural networks, is thus a sequence of (generally, non-commutative) unitary operators. Finally, they propose a method to train these deep QNNs by assuming that training data is represented in the form of qubits, with a cost function given by the _fidelity_ between the outputs and the original qubits (which should be replicable):

$$
C = \frac{1}{N} \sum_{x=1}^{N} \langle \phi_x^{out} \vert \rho_x^{out} \vert \phi_x^{out} \rangle.
$$

Finally, they present a quantum analogue of the backpropagation algorithm, which nonetheless is more efficient due to the mathematics of unitary operators.

- - - - -

## Final points

Alternative physical re-thinkings of neural networks are an exciting area of present research, but even the most promising approaches (such as the Tai Chi paper previously mentioned) don't have the representational capacity to match the needs of modern model architectures such as the GPTs, which can reach over one trillion parameters.

But given that [we need exponential amounts of data relative to model size](https://arxiv.org/abs/2404.04125), it remains to be seen whether the bottleneck is growing the representational capacity of these physical neural networks or something more fundamental to the "throw data at a big model and see what sticks" approach that we seem insistent on using at the present juncture, such as [the lack of useful data in our world](https://arxiv.org/abs/2211.04325) and the underlying sample-inefficient architectures of current foundational models.
