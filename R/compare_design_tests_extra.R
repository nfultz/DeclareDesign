library(DeclareDesign)

# external variable
N <- 100
d1 <- declare_population(N = N) +
  declare_assignment(m = 50) +
  declare_potential_outcomes(Y ~ rbinom(n = N, size = 1, prob = 0.5 + .1*Z)) +
  declare_estimand(ATE = 0.3) +
  declare_estimator(Y ~ Z)

d2 <- declare_population(N = N) +
  declare_assignment(m = 50) +
  declare_potential_outcomes(Y ~ rbinom(n = N, size = 1, prob = 0.5 + .1*Z)) +
  declare_estimand(ATE = 0.3) +
  declare_estimator(Y ~ Z)


example1 <- compare_designs(d1, d2) 
example1$similarity  # expect all 1s

n <- 300
d3 <- declare_population(N = n) +
  declare_assignment(m = 50) +
  declare_potential_outcomes(Y ~ rbinom(n = N, size = 1, prob = 0.5 + .1*Z)) +
  declare_estimand(ATE = 0.3) +
  declare_estimator(Y ~ Z)
compare_designs(d1, d2, d3)$similarity  # d3 differs but d1, d2 the same


# false positive
# compare_designs is 'fooled' here by two different ways of coding Bernoullis
# but directs the user to the appropriate code difference
d2A <- declare_population(N = N) +
  declare_assignment(m = 50) +
  declare_potential_outcomes(Y ~ as.numeric(runif(n = N) > (0.5 + .1*Z))) +
  declare_estimand(ATE = 0.3) +
  declare_estimator(Y ~ Z)
cd <- compare_designs(d2, d2A)
cd$data_shape # should be the same
cd$similarity # differences will be flagged, see note above
cd$code_differences # should bring to right place
