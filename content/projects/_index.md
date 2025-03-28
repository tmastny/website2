---
title: "Projects"
---

# Projects

* [Dead Rise](https://tmastny.itch.io/dead-rise)
  * a handmade, 8-bit, fantasy console shooter.
  * original soundtrack available on [Spotify](https://open.spotify.com/album/2NDjbaV75fAzbkrdobMuiH?si=thOdVn6eS0CUoq_t2wmeqw).
  * credits
    * [Michaela Mastny](https://www.instagram.com/michaelalifts_/profilecard/?igsh=MW5ocDV4ODhsY2k1bw%3D%3D) handcrafted each pixel and did the graphic design
    * [Ian Wright](https://open.spotify.com/artist/2L6WmcioMhfNMZ9TssRU2v) wrote the original soundtrack and sound effects
    * I designed the levels and programmed the game in C++ using the [PPU466](http://graphics.cs.cmu.edu/courses/15-466-f20/game1.html) API. I also compiled the final release to wasm.  

<!-- spacing -->
* [sass](https://github.com/rstudio/sass/)
  * low-level wrapper around libsass. Part of the [Shiny](https://github.com/rstudio/shiny) backend,
    a web framework for R with millions of downloads per year.
  * over [900k downloads per month](https://cranlogs.r-pkg.org/badges/sass).

<!-- spacing -->
* [Hudl's Greatest Comebacks](https://www.hudl.com/video/5ef26c24ab93fb1a10868c39)
  * an internal data analytics tool created by [Corley Bagley](https://www.linkedin.com/in/corley-bagley-55928681/) and I used to find exciting football games and moments
  * calculated win probabilities and expected points for every play in every game to find unexpected outcomes
  * Hudl's media team used the tool to create the [Greatest Comebacks](https://www.hudl.com/video/5ef26c24ab93fb1a10868c39) and other successful series.

<!-- spacing -->
* [tsrecipes](https://github.com/tmastny/tsrecipes/)
  * a collection of time series algorithms, focused on the underexplored goals of clustering and classification
    with techniques from data compression and signal processing.
  * articles:
    * [Dynamic Time Warping](/blog/dynamic-time-warping-time-series-clustering/)
    * [Time Series Clustering](https://tmastny.github.io/tsrecipes/articles/time-series-clustering.html)
    * [Discrete Cosine Transform and Time Series Classification](/blog/discrete-cosine-transform-time-series-classification/)

<!-- spacing -->
* [reactor](https://github.com/tmastny/reactor)
  * a proof-of-concept for an https://observablehq.com/ like experience powered by Shiny's built-in reactive expressions.

<!-- spacing -->
* [R Syntax Highlighting Gallery](/projects/r-syntax-highlighting-gallery)
  * a gallery I created while investigating syntax highlighting
    for my blog. 
  * also see my [blog post](/blog/syntax-highlighting/) on the topic.

### Tools and Libraries

* [browse](https://github.com/tmastny/browse): tool to open a local file in Github
* [feat](https://github.com/tmastny/feat): python library to manage column features in scikit learn
  * this library had little adoption, but I'm proud of this one. In R, the output of statistical and 
    machine learning models are in the context of the input feature *names*: for example, R 
    will say "location" is significant. 
    Scikit learn does not carry this data forward, so you have to manually remap
    outcomes and feature importances back to the input feature names. This library fixes that.
* [leadr](https://github.com/tmastny/leadr): R package to manage machine learning model metadata
* [sagemaker](https://github.com/tmastny/sagemaker): R package to manage AWS Sagemaker

## Book notes

* [Napkin Math](/projects/napkin-math)
  * following the [Napkin Math newsletter](https://sirupsen.com/napkin).

<!-- spacing -->
* [Forecasting: Principles and Practice](https://otexts.com/fpp3/), 3rd edition.
  * complete notes on [Github](https://github.com/tmastny/timeseries/tree/master/vignettes).

<!-- spacing -->
* [Statistical Rethinking](https://xcelab.net/rm/statistical-rethinking/), first edition.
  * almost complete notes on [Github](https://github.com/tmastny/Statistical-Rethinking-Notes).

<!-- spacing -->
* [Simulation and Similiarity](https://www.amazon.com/Simulation-Similarity-Understand-Studies-Philosophy/dp/0190265124)
  * chapter 1 and 2 note on Chapters 1 and 2 [Notion](https://www.notion.so/).

<!-- spacing -->
* [Crafting Interpreters](https://craftinginterpreters.com/)
  * complete notes on [Github](https://github.com/tmastny/crafting-interpreters).
  * exercises nicely organized as [Pull Requests](https://github.com/tmastny/crafting-interpreters/pulls).

<!-- spacing -->
* [Beej's Guide to Network Concepts](https://beej.us/guide/bgnet0/html/split/index.html)
  * project notes on [Github](https://github.com/tmastny/beejs-guide-to-network-concepts).

<!-- spacing -->
* [Learn Docker in a Month of Lunches](https://www.manning.com/books/learn-docker-in-a-month-of-lunches)
  * exercises through chapter 7 on [Github](https://github.com/tmastny/diamol).