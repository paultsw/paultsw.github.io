---
layout: post
title:  "A brief note on how the Elo ranking system works"
date:   2021-12-26 17:00:00 -0400
tags: mathematics game-theory
share: false
---

This post is a bit of a deviation away from my usual posts insofar as it avoids the pleasantries of my previous introductions and conclusions. Rather, this is a quick note about the [Elo rating system](https://en.wikipedia.org/wiki/Elo_rating_system), invented by the physicist Arpad Elo (frequently referred to as the ELO rating system, under the assumption that 'Elo' was an acronym rather than the surname of the inventor).

The Elo rating system was first used for chess, where it is still the dominant way of ranking chess players; but it has been used in a number of different sports and competitive player-versus-player video games.

But anyway, why a post about the Elo rating system? Why now? A number of reasons:

* competitive rankings are used in practically any serious game, from tennis to _Counterstrike: Global Offensive_;

* as a perhaps surprising occurrence of the Elo rating, there is a [scene in _The Social Network_](https://www.youtube.com/watch?v=KdtPNRzuKrk) in which zucc and co. use the Elo system to rank the attractiveness of their victims;

* the formulae involved in computing the Elo ratings seem to be intrinsically interesting, with "magic numbers" appearing in them;

* the final reason is that I just needed a good excuse to figure out how this rating system worked. What better time than the present, and what better medium than a blog post?

- - - - -

To characterize the Elo system, we need to describe the problem context.

The Elo rating system (henceforth, "Elo") was designed for chess, as Arpad Elo was a noted fan of the game. As such, it was meant for games that have the same competitive manner of chess:

* one player competes against another player in a game of skill;

* while some degree of randomness may exist, it shouldn't be able to fundamentally change the outcome of a game;

* players are assumed to have a latent "skill" level;

* in tournaments, players are matched together in pairs for each game;

* over the course of their lifetimes, players may compete in pairs against weaker and stronger players;

* and each game results in either victory or defeat for a given player (and consequently, either defeat or victory for the other player, i.e. a win for a player is a loss for their opponent, and _vice versa_).

As a rating system, we have a few desiderata:

* we want to be able to assign a quantitative rating to each player;

* we want to use these ratings to assign interesting matches --- i.e., we want to use ratings to make sure players don't get assigned to lopsided matches of very strong versus very weak players (and ideally, we have evenly-matched players so that each player feels they have some hope of winning);

* and the ratings themselves ought to be publicly available so that we stimulate a degree of competition between players, and so that we are able to construct e.g. "bands" of higher-rank, middle-rank, lower-rank players and segment each band off into their own competitions. It would be nice to use the ratings to promote a sense of "advancement" for dedicated players so that they can "level-up" between bands.

The Elo rating system was one of the earliest rating systems to do the above, and the Elo system and its extensions are still being used, not only in its original context of FIDE chess but also in massive multiplayer online games (e.g. _Halo_, _CS:GO_, and so on).

- - - - -

Okay, so how does it work?

We'll split this up into two descriptions: first, we describe the model, i.e. Arpad Elo's proposal for the description of how individual player ratings influence the probability of a match outcome between them. Then, we describe the update rule, which is sort of like a way of looking at the probabilistic model "in reverse": given a set of match outcomes and an initial "kind-of-wrong" pair of player ratings, how can we incorporate the empirical competition data between the players to adjust the player ratings so that they are more reflective of empirical reality?

## The Model

Let's say a match $$M \in \{1,2\}$$ is played between players 1 and 2, with $$M = 1$$ if player 1 wins, and the opposite if player 2 wins. The central assumption of the Elo rating system is that there are (possibly latent or hidden) _player ratings_ $$s_1, s_2 \in \mathbb{R}$$ for players 1 and 2, respectively, and these ratings influence the probability of a match $$M$$ swinging one way or the other.

The Elo rating system supposes that the ratings influence the match outcome in the following way: each player $$i \in \{1,2\}$$ exhibits a random performance

$$
p_i \sim \mathcal{N}(p_i, s_i, \beta^2)
$$

influenced by player $$i$$'s individual rating $$s_i$$ and a global fixed variance parameter $$\beta^2$$ influenced by factors common to all players $$i$$ --- e.g. conditions of the game. (For instance, suppose you're playing a 1-vs-1 first person shooter with a randomized item drop. This randomized factor could be "folded" into the variance term.)

The model calls the match for player 1, i.e. $$M = 1$$, if $$p_1 > p_2$$; similarly, the model predicts $$M = 2$$ if $$p_2 > p_1$$. The case of $$p_1 \equiv p_2$$ is a set of measure zero and hence is a probability zero event, but we could consider it a tie.

Then we can compute the probabilities for each match outcome as:

$$
\mathbb{P}(M=1 | s_1, s_2) = \mathbb{P}(p_1 > p_2 | s_1, s_2) = \Phi\bigl( \frac{s_1 - s_2}{\beta\sqrt{2}} \bigr)
$$

... and similarly for $$M = 2$$, where $$\Phi$$ is the cumulative distribution function of the standard normal distribution $$\mathcal{N}(0, 1)$$.

We make one final note that the use of the normal distribution here is somewhat arbitrary; some treatments use the logistic distribution because the higher kurtosis is sometimes considered more realistic in competitive gaming settings. In this case, we substitute the logistic function for $$\Phi$$ (as the CDF of the logistic distribution is the logistic function).

## The Update Rule

All the above is very well, but how do we improve rating scores in the context of new data? In this case, "new data" refers to new competitive results. After all, if player A is lowly-ranked (and player B is highly-ranked) we should intuitively want to re-rank A to be much higher (and player B much lower) if we suddenly observe a string of consecutive games in which A trounces B.

First, let's set some ground rules:

* Observations are given by a sequence of _match outcomes_ $$M_k \in \{1,2\}$$ for $$k = 1, 2, 3, \ldots$$ a sequence of datapoints.

* We have initial scores $$s_1, s_2$$ for players 1 and 2, respectively; we want to update the scores to new scores $$s_1', s_2'$$ which are more representative of the latent skills of players 1 and 2, given the additional performance information given by the match outcomes.

* What do we mean by "more representative"? In our case, we mean that the new scores maximize the probability

$$
\mathbb{P}(M_k | s_1', s_2')
$$

given the current update step $$k$$.

* For ease of presentation, we perform an online update of the latent Elo ratings sequentially after each $k$, though it is relatively easy to change the probability rule to range over all $k$ simultaneously.

* To make our lives easier, we will assert that the sum of the latent scores should be a constant: i.e., $$s_1 + s_2 = s_1' + s_2'$$.

We are now ready to present the update rule: first define the variables $$K$$ and $$y$$ as:

$$
K := \alpha\beta\sqrt{\pi},
$$

and

$$
y(M) := -1 \mbox{ if } M = 2,\; +1 \mbox{ if } M = 1,\; 0 \mbox{ if } M = 0.
$$

In the description of the $$K$$-factor, the $$\alpha$$ term is a chosen value in $$(0,1)$$ representing a _learning rate_: when $$\alpha$$ is closer to 1 (closer to 0), we will have more erratic (less erratic) updates between steps. (This should be familiar to anyone who has implemented a gradient descent optimizer for neural networks from scratch.)

The Elo update rule given a newly observed match outcome $$M \in \{0, 1, 2 \}$$ is, then:

$$
s_1' := s_1 + y\cdot \Delta(M), \; s_2' := s_2 - y\cdot\Delta(M),
$$

where $$\Delta$$ is

$$
\Delta(M) := K\cdot\bigl( \frac{y(M)+1}{2} - \Phi\bigl(\frac{s_1-s_2}{\beta\sqrt{2}}\bigr) \bigr).
$$

The update rules for two players are implemented in a short script I've drafted, which takes a dataframe of competitive match outcomes and updates Elo ratings for two players. [You can find it here.](https://github.com/paultsw/blogprogs/tree/master/elo)

- - - - -

Naturally, interesting observations about the Elo rating system abound.

First, there is the notion that one can get stuck in a sort of ['Elo hell'](https://en.wikipedia.org/wiki/Elo_hell). This is, purportedly, a situation in which players of popular online games with team-versus-team matches are continually matched with players or teams with the same Elo rating, and are unable to escape out of this small circle of low-rated players due to the circumstances: being paired with low-rated teammates may lead to poor match performances, which leads to a low Elo rating, which leads to being paired with low-rated teammates, and so on.

Evidence for the actual existence of such "Elo hell" phenomena is dubious. Of course, one day I hope to follow in Arpad Elo's footsteps and have some variant of hell named after me too.

Now, what about some extensions? Every frequentist system deserves a bayesian turn --- if for no other reason than to have one more publication --- and Elo is no different.

[Glicko](https://en.wikipedia.org/wiki/Glicko_rating_system) was developed as a bayesian extension of Elo, and was, in turn, extended by [Glicko2 (PDF)](http://www.glicko.net/glicko/glicko2.pdf). Noticing the dearth of rating systems for multiplayer games --- readers who are of a certain age may remember free-for-all deathmatch mode in Quake 3 Arena --- Microsoft Research developed the TrueSkill (and later, TrueSkill2) systems for games with more than two players.

Additionally, we want to answer one of the questions posed in the first paragraph; where do the strange "magic numbers" in the equation

$$
\mathbb{E}[M=1] = \bigl(1 + 10^{\frac{s_1 - s_2}{400}}\bigr)^{-1}
$$

come from?

At this point it should be obvious given what we've mentioned above. This is just the expectation of a victory for player 1, albeit with an Elo rating system based on the logistic function with base 10 instead of $$e$$, and with a judiciously chosen $$\beta$$ term.

Finally, how do we interpret Elo scores? The key is to note that the support of the relevant distributions is on the entire real line, and that no restrictions are placed on the domain of the latent scores themselves. As such, they merely reflect relative ratings --- score are only meaningful relative to the scores of other players, and have no direct interpretation as a real number. We could, for instance, initialize everyone's score to 1000 before we update them with match data. We could also just as easily begin the score of every new player at 12345. The initial values are effectively meaningless in and of themselves, and only matter in the context of being higher or lower than the scores of other players.

- - - - -

The above having been said, let's end with a few references for your perusal.

## References

* [The wikipedia entry.](https://en.wikipedia.org/wiki/Elo_rating_system)
* [Miscrosoft's TrueSkill rating system for multiplayer games.](https://en.wikipedia.org/wiki/TrueSkill)
* [Elo-MMR is a bayesian extension of Elo for massive multiplayer online competition-based games. (PDF)](https://cs.stanford.edu/people/paulliu//files/www-2021-elor.pdf)
