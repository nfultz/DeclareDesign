library(DeclareDesign)

d1 <- declare_population(N = 100) +
  declare_assignment(m = 50) +
  declare_potential_outcomes(Y ~ rbinom(n = N, size = 1, prob = 0.5 + .1*Z)) +
  declare_estimand(ATE = 0.3) +
  declare_estimator(Y ~ Z)

d2 <- declare_population(N = 100) +
  declare_assignment(m = 50) +
  declare_potential_outcomes(Y ~ rbinom(n = N, size = 1, prob = 0.5 + .1*Z)) +
  declare_estimand(ATE = 0.3) +
  declare_estimator(Y ~ Z)


example1 <- compare_designs(d1, d2) 
example1$similarity  # expect all 1s

d3 <- redesign(d1)
d4 <- d2
compare_designs(d1, d2, d3, d4)$similarity # confirm no false positives

# different number of STEPS per design
d5 <- declare_population(N = 100) +
  declare_assignment(m = 50) +
  declare_potential_outcomes(Y ~ rbinom(n = N, size = 1, prob = 0.5 + .1*Z)) +
  declare_estimand(ATE = 0.3)

compare_designs(d1, d5)$steps_per_design

# test multiple designs
d6 <- declare_population(N = 1000) + # different than d1
  declare_assignment(m = 500) +      # different than d1
  declare_potential_outcomes(Y ~ rbinom(n = N, size = 1, prob = 0.5 + .1*Z)) +
  declare_estimand(ATE = 0.3) +
  declare_estimator(Y ~ Z)

d7 <- declare_population(N = 100) + 
  declare_assignment(m = 50) +      
  declare_potential_outcomes(Y ~ rbinom(n = N, size = 1, prob = 0.5 + .1*Z)) +
  declare_estimand(ATE = 0.5) + # different than d1
  declare_estimator(Y ~ Z)

d8 <- declare_population(N = 100) + 
  declare_assignment(m = 50) +      
  declare_potential_outcomes(Y ~ rbinom(n = N, size = 1, prob = 0.5 + .1*Z)) +
  declare_estimand(ATE = 0.3) +   
  declare_estimator(Y ~ Z - 1 ) # different than d1


example4 <- compare_designs(d1, d6, d7, d8)
example4$code_differences

# printing
# print(exampe1) # not run
# print(compare_designs(d1, d5)) # not run
# print(compare_designs(d1, d5), highlights = FALSE) # not run

# summary
# summary(example4) # not run
# summary(compare_designs(d1, d5)) # not run

# saving 
# save_design_comparison(example4, file_prefix = "example4", render_quietly = TRUE)
# save_design_comparison(example4, file_prefix = "example4", output_type = "pdf", render_quietly = TRUE)
# save_design_comparison(example4, file_prefix = "example4", output_type = "word", render_quietly = TRUE)
# save_design_comparison(example4, file_prefix = "example4", output_type = "github", render_quietly = TRUE)
# save_design_comparison(example4, file_prefix = "example4", output_type = "Rmd", render_quietly = TRUE)

