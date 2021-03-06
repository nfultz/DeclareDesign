DeclareDesign: Declare and Diagnose Research Designs
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN
Status](https://www.r-pkg.org/badges/version/DeclareDesign)](https://cran.r-project.org/package=DeclareDesign)
[![Travis-CI Build
Status](https://travis-ci.org/DeclareDesign/DeclareDesign.svg?branch=master)](https://travis-ci.org/DeclareDesign/DeclareDesign)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/DeclareDesign/DeclareDesign?branch=master&svg=true)](https://ci.appveyor.com/project/DeclareDesign/DeclareDesign)
[![Coverage
Status](https://coveralls.io/repos/github/DeclareDesign/DeclareDesign/badge.svg?branch=master)](https://coveralls.io/github/DeclareDesign/DeclareDesign?branch=master)

DeclareDesign is a system for describing research designs in code and
simulating them in order to understand their properties. Because
DeclareDesign employs a consistent grammar of designs, you can focus on
the intellectually challenging part – designing good research studies –
without having to code up simulations from scratch.

## Installation

To install the latest stable release of **DeclareDesign**, please ensure
that you are running version 3.5 or later of R and run the following
code:

``` r
install.packages("DeclareDesign")
```

To install the latest development release of all of the packages, please
ensure that you are running version 3.5 or later of R and run the
following code:

``` r
install.packages("DeclareDesign", dependencies = TRUE,
                 repos = c("http://R.declaredesign.org", "https://cloud.r-project.org"))
```

## Usage

Designs are declared by adding together design elements. Here’s a
minimal example that describes a 100 unit randomized controlled trial
with a binary outcome. Half the units are assigned to treatment and the
remainder to control. The true value of the average treatment effect is
0.05 and it will be estimated with the difference-in-means estimator.
The diagnosis shows that the study is unbiased but underpowered.

``` r
library(DeclareDesign)

design <-
  declare_population(N = 100) +
  declare_potential_outcomes(Y ~ rbinom(n = N, size = 1, prob = 0.5 + 0.05 * Z)) +
  declare_estimand(ATE = 0.05) +
  declare_assignment(m = 50) +
  declare_estimator(Y ~ Z)

diagnosis <- diagnose_design(design, diagnosands = declare_diagnosands(select = c("power", "bias")))
diagnosis
```

    ## 
    ## Research design diagnosis based on 500 simulations. Diagnosand estimates with bootstrapped standard errors in parentheses (100 replicates).
    ## 
    ##  Design Label Estimand Label Estimator Label Term N Sims  Power   Bias
    ##        design            ATE       estimator    Z    500   0.08  -0.00
    ##                                                          (0.01) (0.00)

## Companion software

The core DeclareDesign package relies on four companion packages, each
of which is useful in its own right.

1.  [randomizr](https://declaredesign.org/r/randomizr/): Easy to use
    tools for common forms of random assignment and sampling.
2.  [fabricatr](https://declaredesign.org/r/fabricatr/): Imagine your
    data before you collect it.
3.  [estimatr](https://declaredesign.org/r/estimatr/): Fast estimators
    for social scientists.
4.  [DesignLibrary](https://declaredesign.org/library): Templates to
    quickly adopt and adapt common research designs.

## Learning DeclareDesign

1.  To get started, have a look at this vignette on [the idea behind
    DeclareDesign](https://declaredesign.org/idea/), which covers the
    main functionality of the software.

2.  You can also browse a [library](https://declaredesign.org/library/)
    of already declared designs, which relies on the `DesignLibrary`
    package. The library includes canonical designs that you can
    download, modify, and deploy.

3.  A fuller description of the philosophy underlying the software is
    described in this [working
    paper](https://declaredesign.org/declare.pdf).

## Package structure

Each of these `declare_*()` functions returns a *function*.

1.  `declare_population()` (describes dimensions and distributions over
    the variables in the population)
2.  `declare_potential_outcomes()` (takes population or sample and adds
    potential outcomes produced by interventions)
3.  `declare_sampling()` (takes a population and selects a sample)
4.  `declare_assignment()` (takes a population or sample and adds
    treatment assignments)
5.  `declare_estimand()` (takes potential outcomes and calculates a
    quantity of interest)
6.  `declare_estimator()` (takes data produced by sampling and
    assignment and returns estimates)

To *declare a design*, connect the components of your design with the +
operator.

Once you have declared your design, there are four core
post-design-declaration commands used to modify or diagnose your design:

1.  `diagnose_design()` (takes a design, returns simulations and
    diagnosis)
2.  `draw_data()` (takes a design and returns a single draw of the data)
3.  `draw_estimates()` (takes a design a returns a single simulation of
    estimates)
4.  `draw_estimands()` (takes a design a returns a single simulation of
    estimands)

A few other features:

1.  A designer is a function that takes parameters (e.g., `N`) and
    returns a design. `expand_design()` is a function of a designer and
    parameters that returns a design.
2.  You can change the features of the design to be diagnosed with
    `declare_diagnosands()`.
3.  `declare_reveal()` implements a general switching equation, which
    allows you to reveal outcomes from potential outcomes and a
    treatment assignment.
4.  You can provide custom functions to any `declare_*` step, as
    described in the [custom functions
    vignette](/r/declaredesign/articles/custom_functions.html).

-----

This project is generously supported by a grant from the [Laura and John
Arnold Foundation](http://www.arnoldfoundation.org) and seed funding
from [EGAP](http://egap.org).
