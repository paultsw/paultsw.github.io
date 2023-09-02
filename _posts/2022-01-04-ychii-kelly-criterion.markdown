---
layout: post
title:  "_You Could Have Invented It_ --- The Kelly Criterion"
date:   2022-01-04 17:00:00 -0400
tags: mathematics statistics ychii
share: false
---

This post is the first in a new blog post series under the cheeky label of _You could have invented it!_. The aim of this series is to present a cohesive, first-principles to final derivation presentation of a theoretical gem, spanning the range from mathematics, computer science, or physics. The target audience is a reasonably keen graduate possessing a first degree in one of these three fields with a passing familiarity with either of the other two fields.

Each post in the YCHII series will optimistically include each of the following components:

* an introduction to the problem context: we will assume that the broad problem is given;

* a step-by-step derivation of the result from first principles, based on a series of resolutions to "natural" questions that arise;

* when applicable, a programmatic demonstration implemented (typically) in python.

For this inaugural post, we will present a quick discussion of a curio in the annals of gambling, known as the __Kelly Criterion__. Despite its mathematical simplicity, it is fairly counter-intuitive and thus was only discovered in the mid-twentieth century.

What is the Kelly Criterion? Discovered by Bell Labs researcher J.L. Kelly Jr. in 1956, it proposes a statistically optimal formula for determining how much one ought to wager on a bet, based on a novel interpretation of Claude Shannon's notion of information and information rate. Nowadays, it is used not only in the betting world but also used as a rudimentary principle for portfolio sizing and determining how much one ought to wager on a given company's stock.

- - - - -

## Introduction to the problem

```
TODO:
* intro on purpose and problem

READING LIST FOR BLOG POST
https://www.frontiersin.org/articles/10.3389/fams.2020.577050/full
https://corporatefinanceinstitute.com/resources/knowledge/trading-investing/kelly-criterion/
https://www.tutorialspoint.com/what-is-the-kelly-criterion-and-how-does-it-work
https://www.investopedia.com/articles/trading/04/091504.asp
https://towardsdatascience.com/doubling-your-money-with-the-kelly-criterion-and-bayesian-statistics-83ee407c0777
https://sites.math.washington.edu/~morrow/336_16/2016papers/nikhil.pdf
https://en.wikipedia.org/wiki/Kelly_criterion
https://www.princeton.edu/~wbialek/rome/refs/kelly_56.pdf (this is the main paper)
```

- - - - -

## Derivation of the Kelly Criterion

```
TODO:
* step-by-step derivation and exposition here
* conclusion here
```

- - - - -

## Demonstration

```
TODO:
* python implementation here: given a random time series S(t) and a fixed amount of capital at T=0,
  invest K% (for K ~ kelly percentage) into S(t) at each point based on prior statistics.
* print out final profit.
* permit multiple retries and permit other rules for investing percentages (e.g. 100% each time,
  50% each time, etc.).
* call these investment rules "policies" and print the distribution of final totals for each policy
  at the end of the monte carlo simulation.
```

- - - - -

## References

* J.L. Kelly's original paper is titled [_A New Interpretation of Information Rate_](https://www.princeton.edu/~wbialek/rome/refs/kelly_56.pdf). At ten pages, it's a relatively short read.
* As usual, [the Wikipedia entry](https://en.wikipedia.org/wiki/Kelly_criterion) may be helpful.
* As a quick example of the use of the Kelly Criterion in mathematical finance, [these researchers have developed a system](https://www.frontiersin.org/articles/10.3389/fams.2020.577050/full) for the application of the KC in portfolio rebalancing.
