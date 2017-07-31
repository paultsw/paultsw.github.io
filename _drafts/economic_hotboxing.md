Economic Hotboxing
==================

Ideas:
* Economic data is often composed of very sparse time-series data:
  low temporal resolution, highly auto-regressive
* What if we developed economic agents with randomly-initialized
  beliefs about the economic system -- say from some prior --
  and asked them to compete against each other in some simulated
  market setting?
* Then, after they compete for a long enough time and are stabilized,
  we "align" the market system (an ensemble of neural agents) against
  the sparse signals we have.
* Fundamental to this is the existence of an efficient way of "aligning"
  the underlying beliefs of each agent to reproduce the real market
  signal. Very hard! Want a backprop-style system that can update
  the posteriors of *all* the market-participating agents.