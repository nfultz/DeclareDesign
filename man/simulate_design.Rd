% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate_design.R
\name{simulate_design}
\alias{simulate_design}
\title{Simulate a design}
\usage{
simulate_design(..., sims = 500)
}
\arguments{
\item{...}{A design created by \code{\link{declare_design}}, or a set of designs. You can also provide a single list of designs, for example one created by \code{\link{expand_design}}.}

\item{sims}{The number of simulations, defaulting to 500. If sims is a vector of the form c(10, 1, 2, 1) then different steps of a design will be simulated different numbers of times.  See details.}
}
\description{
Runs many simulations of a design and saves to a dataframe.
}
\details{
Different steps of a design may each be simulated different a number of times, as specified by sims. In this case simulations are grouped into "fans", eg "fan_1" indicates all the simulations that have the same draw from the first level of the design. For efficiency there are generally fewer fans than design steps where all contiguous steps with 1 sim specified are combined into a single fan.
}
\examples{
my_population <- declare_population(N = 500, noise = rnorm(N))

my_potential_outcomes <- declare_potential_outcomes(
  Y_Z_0 = noise, Y_Z_1 = noise +
  rnorm(N, mean = 2, sd = 2))

my_assignment <- declare_assignment()

my_estimand <- declare_estimand(ATE = mean(Y_Z_1 - Y_Z_0))

my_estimator <- declare_estimator(Y ~ Z, estimand = my_estimand)

my_reveal <- declare_reveal()

design <- declare_design(my_population,
                         my_potential_outcomes,
                         my_estimand,
                         my_assignment,
                         my_reveal,
                         my_estimator)

\dontrun{
simulations <- simulate_design(designs, sims = 2)
diagnosis   <- diagnose_design(simulations_df = simulations)
}

\dontrun{
# A fixed population with simulations over assignment only
head(simulate_design(design, sims = c(1,1,1,100,1)))
}

}