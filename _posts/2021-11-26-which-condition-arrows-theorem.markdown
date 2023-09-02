---
layout: post
title:  "Which outcome of Arrow's theorem fails?"
date:   2021-11-26 17:00:00 -0400
tags: mathematics economics politics game-theory
share: false
---

In 1972, the economist Kenneth Arrow received the Nobel Memorial Prize in Economics for a profound discovery published as part of his 1951 doctoral dissertation. In it, he demonstrated an _impossibility theorem_: a mathematical result showing that certain conditions were impossible. In this case, it was a discovery about voting systems which proved decisive in establishing the field of social choice theory.

Arrow's contribution was to demonstrate that no voting system could be perfect. In particular, his result demonstrated that it was impossible for four desirable properties, each of which could be considered a _sine qua non_ of a fair voting system,  to hold true at the same time. Arrow's impossibility theorem, along with later results such as the Gibbard-Satterthwaite theorem, prompted a wave of soul-searching within the field of political philosophy and still has a profound effect on the way that we think about the design of electoral systems today --- in particular, it has provided intellectual guardrails around the debate on electoral reform in many countries.

In this blog post, we'll provide an introductory look at the statement of Kenneth Arrow's foundational result and tie it to existing voting systems by determining which desirable property fails to hold in a particular case study of the ranked choice voting method used in the 2021 New York City party primaries for the mayoral election.

- - - - -

## Arrow's theorem

To explain Arrow's theorem, we first have to provide some formal context by translating some familiar aspects of voting systems into an appropriate mathematical context.

First, fix a set of _voters_ $$S = \{1, 2, 3, \ldots, N\}$$, representing all of the voters within a constituency. These voters may represent members of a society, a riding, a district; they may represent elected officials such as members of parliament or representatives within a legislative assembly, who are assembled to vote on a set of policies; or they may represent shareholders that have assembled to elect a board of directors at an annual general meating for a publicly-traded firm.

Choose also a set of _candidates_ $$C = \{ \alpha, \beta, \gamma, \ldots \}$$, on which the voters are expected to have _preferences_. These candidates may represent policies, candidates for public office, or decisions (e.g. a dozen people vote between themselves to decide on where to go to dinner).

We make a few additional assumptions. We assume that each voter $$s \in S$$ has a preference $$<_s$$ over the set of candidates: $$x <_s y$$ means that voter $s$ prefers candidate $$y$$ over candidate $$x$$. For the sake of this exposition, we assume that there are no ties in individual preferences, i.e. no voter is ambivalent between two candidates. We also assume that voters are rational: if voter Alice prefers candidate Bob over candidate Carol, and prefers candidate Carol over candidate David, then it stands to reason that Alice prefers Bob over David by extension. Mathematically, this is known as _transitivity_, and can be encoded in formal language thusly:

$$
\forall s \in S, \, \forall x,y \in C, \, (x <_s y) \land (y <_s z) \implies (x <_s z).
$$

An additional assumption is that the preference profiles of individual voters are independent of one another, i.e. while voters may have similar preferences, their preferences are not reliant on each other; we are not playing a dynamic game in which one preference will impact the evolution of another preference. This is an assumption that is blatantly incorrect if we compare it to the reality of voting: relatives and friends debate each other around the dinner table all the time and try to convince each other of the veracity of their subjective beliefs. But this is not such a major simplification, since for all intents and purposes, we can ignore the evolution of voter preferences over time and consider them to be effectively static on the final polling date.

Finally, a _voting system_ is defined as a mapping which takes $N$ individual voter preference profiles and generates a social ranking of the candidates. In other words, if voter preferences are represented by rankings of the candidates $C$, then a voting system is a function of the following form:

$$
V: (t_1, \ldots, t_N) \mapsto T,
$$

where each $$t_s$$ (for $$s \in S$$) is a ranking of the candidates $$C$$ from worst to best, based on the preferences of voter $$s$$:

$$
t_s = \langle c_1 <_s c_2 <_s \ldots \rangle
$$

and $$T$$ is a _social ranking_ that is derived by the choice of the voting system $$V$$, purportedly representing the preferences of all the voters as a whole.

- - - - -

The definition of a voting system is fairly loose. We can think of many terrible voting systems: for instance, an example of a mathematically valid voting system is one that just ignores every voter's preferences aside from voter 1, and just reports the first voter's individual preferences as those of the entire constituency. But this is clearly not what we intend to build when we're designing a fair voting system.

Arrow describes four desired outcomes that we would potentially want from any given voting system, in order to consider the resultant social ranking to be "reasonable" in some moral, democratic sense:

1. __Unanimity__ (**U**) states that a consensus in society must be respected by the social ranking $$T$$. Formally: if every voter $$s \in S$$ prefers candidate $$x$$ over candidate $$y$$, then $$T$$ must be a ranking that ranks $$x$$ over $$y$$ --- that is, $$x >_T y$$ if $$x >_s y$$ for every voter $$s$$.

2. __Rationality__ (**R**) means that the social ordering respects transitivity, i.e. if $$a \leq_T b$$ and $$b \leq_T c$$, then $$a \leq_T c$$.

3. The __no-dictatorship__ (**ND**) condition requires that no single voter can override the preferences of the rest of the voters. Mathematically, a _dictator_ is a special voter $$\hat{s}$$ that can uniquely influence the social ranking $$T$$ generated by the voting system: for any candidates $$x,y \in C$$, the dictator is able to force their preference between $$x$$ and $$y$$ to be the preference of the social ranking. Formally, $$\hat{s}$$ is a _dictator_ with respect to the voting system $$V$$ if:

	$$
	\forall \, x,y \in C \mbox{ such that } (x >_{\hat{s}} y) \, \land \, (\forall \, s \neq \hat{s}, \, y >_s x) \implies \, (x >_T y).
	$$

4. __Independence of irrelevant alternatives__ (**IIR**) means that third candidates should not change the relative preference of two given candidates in the social ordering. In other words, whether $$x >_T y$$ should only depend on whether $$x >_s y$$ among each voter $$s \in S$$, regardless of the individual preferences relating to any third candidate $$z \in C$$. This last condition is controversial due to the fact that it does not seem to be consistent with actual human behavior; we often do actually observe a "spoiler effect" when third candidates appear on ballots.

Given the above four conditions, which we'll call the four "moral conditions"[^1] in the rest of this post, Arrow's theorem is easy to state:

> __[Arrow's Theorem, 1951.]__ When we have more than two candidates, it is not possible to fulfill all four moral conditions **U, R, ND, IIR**.[^2]

- - - - -

## Which condition fails? A case study in New York City.

The world's electoral systems includes a diversity of methods to generate social preferences from the collection of individual voter preferences in a constituency[^3]. What lessons can be gleaned from all of these systems?

We now know that the four conditions cannot all hold. How do the world's various electoral systems stack up? Let's now turn and take a look at the case of NYC's 2021 mayoral election within the analytic framework of Arrow's theorem.

- - - 
The recent 2021 mayoral party primary in the city of New York used a _ranked choice_ voting method to determine the candidate for each party. In a heavily Democratic-leaning city like NYC, we can consider this to be nearly tantamount to selecting the mayor via a ranked choice vote (and indeed, as of this writing, Democratic Party candidate Eric Adams has recently won the election and will take up the mayorship in January of 2022).

Ranked choice voting is the most direct application of Arrow's framework, as it directly asks voters to submit a ranking over the set of candidates. The [NYC Board of Elections gives a description](https://vote.nyc/page/ranked-choice-voting) of how the winning candidate is chosen:
  > (1) All first-choice votes are counted. If a candidate receives more than 50% of first-choice votes, that candidate wins.\\
  > (2) If no candidate earns more than 50% of first-choice votes, then counting will continue in rounds.\\
  > (3) At the end of each round, the last-place candidate is eliminated and voters who chose that candidate now have their vote counted for their next choice.\\
  > (4) Your vote is counted for your second choice only if your first choice is eliminated. If both your first and second choices are eliminated, your vote is counted for your next choice, and so on.\\
  > (5) This process continues until there are two candidates left. The candidate with the most votes wins.

If we assume that the social ranking of the above voting method is generated by placing the candidates eliminated first at the bottom of the social ranking, the next candidate eliminated is placed at the second-to-last position of the social ranking, and so on, then we see that the following counterexample `TODO: breaks which condition?`

If you're wondering how we found this counterexample, I've written up a [short Monte Carlo algorithm to produce these](TODO).

- - - - -

## Closing Remarks

Far from obviating ordinal electoral systems altogether, many critiques of Arrow's theorem have pointed out that it ought to be fine --- in some moral sense --- to do away or weaken the four desiderata; in other words, even if we cannot have all four of unanimity, non-dictatorship, rationality, and independence of irrelevant alternatives, we might be able to get away with three out of the four (and typically, the IIA condition is weakened).

Interestingly, Arrow's result is extended by the _Gibbard-Satterthwaite theorem_, which is another mutual impossibility proof along the lines of Arrow's theorem. It states that, when there are at least three candidates, the following three conditions are not all possible at the same time:

* the voting method always selects the unanimous candidate, if one exists;
* strategic voting is impossible, i.e. all candidates will vote for their actual preferences (because voting for their actual preferences is game-theoretically their best strategy); and
* the voting mechanism is not a dictatorship (in the same sense as the condition in Arrow's theorem).

A final remark: Arrow's impossibility theorem applies only to _ordinal_ voting systems, in which voters merely have a ranking of preferences. It does not apply more generally to _cardinal_ voting systems, in which voters allocate numeric utilities to the set of candidates. While cardinal voting systems have been discussed[^4] and do exist in rare instances (such as in special interest groups or small clubs), cardinal voting is not popular worldwide. That being said, it may provide an alternative means by which we can escape Arrow's impossibility trap.

In the end, the voting system itself is one piece of a bigger puzzle, and the social and ideological challenges towards the construction of stable and democratic public systems involve much greater challenges than the mechanism design of electoral systems. These include the public's ideological self-confidence, mutual trust, and social cohesion; even the most well-optimized electoral systems cannot survive failures in the social domain.

- - - - -

## Further Reading & References

[^1]: Usually, these are actually referred to as _axioms_ of decision theory, but I prefer the term "moral conditions" --- the latter term better captures the fact that these "axioms" are actually conditions that are merely nice-to-have, in a moral sense. Further, one must wonder what good it is to have an axiom that is empirically found to be false most of the time, as is the case with IIA.

[^2]: Some presentations of Arrow's theorem instead use the equivalent notions of _unrestricted domain_ and _Pareto efficiency_ instead of unanimity and rationality in the list of the four moral conditions required of the voting system.

[^3]: Despite this diversity, we do find that the vast majority of electoral methods, if not all, use ordinal voting methods. While cardinal voting may offer an alternative to Arrow's theorem --- votes in a cardinal voting system are more akin to portfolios than to rankings --- there is little real-world experience with the use of cardinal voting systems.

[^4]: ...For instance, former US presidential candidate Andrew Yang has proposed something similar via his "democracy dollars" idea. It doesn't seem to have taken off beyond some minor initial buzz.

* [Kenneth Arrow's Nobel Prize citation](https://www.nobelprize.org/prizes/economic-sciences/1972/arrow/facts/).
* [Stanford Encyclopedia of Philosophy entry on Arrow's theorem.](https://plato.stanford.edu/entries/arrows-theorem/)
* [The closely-related Gibbard-Satterthwaite theorem on voting rules.](https://en.wikipedia.org/wiki/Gibbard%E2%80%93Satterthwaite_theorem)
* [A presentation of Arrow's theorem with a proof by Terence Tao (PDF).](https://scholar.princeton.edu/sites/default/files/ashvin/files/arrow-theorem.pdf)
* [A presentation and three proofs of the Gibbard-Satterthwaite theorem.](https://www.cs.cmu.edu/~arielpro/15780/readings/svensson.pdf)
