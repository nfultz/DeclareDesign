% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/declare_estimator.R
\name{declare_estimator}
\alias{declare_estimator}
\alias{declare_estimators}
\alias{label_estimator}
\alias{model_handler}
\title{Declare estimator}
\usage{
declare_estimator(
  ...,
  handler = label_estimator(model_handler),
  label = "estimator"
)

declare_estimators(
  ...,
  handler = label_estimator(model_handler),
  label = "estimator"
)

label_estimator(fn)

model_handler(
  data,
  ...,
  model = estimatr::difference_in_means,
  model_summary = tidy_try,
  term = FALSE
)
}
\arguments{
\item{...}{arguments to be captured, and later passed to the handler}

\item{handler}{a tidy-in, tidy-out function}

\item{label}{a string describing the step}

\item{fn}{A function that takes a data.frame as an argument and returns a data.frame with the estimates, summary statistics (i.e., standard error, p-value, and confidence interval), and a term column for labeling coefficient estimates.}

\item{data}{a data.frame}

\item{model}{A model function, e.g. lm or glm. By default, the model is the \code{\link{difference_in_means}} function from the \link{estimatr} package.}

\item{model_summary}{A model-in data-out function to extract coefficient estimates or model summary statistics, such as \code{\link{tidy}} or \code{\link{glance}}. By default, the \code{DeclareDesign} model summary function \code{\link{tidy_try}} is used, which first attempts to use the available tidy method for the model object sent to \code{model}, then if not attempts to summarize coefficients using the \code{coef(summary())} and \code{confint} methods. If these do not exist for the model object, it fails.}

\item{term}{Symbols or literal character vector of term that represent quantities of interest, i.e. Z. If FALSE, return the first non-intercept term; if TRUE return all term. To escape non-standard-evaluation use \code{!!}.}
}
\value{
A function that accepts a data.frame as an argument and returns a data.frame containing the value of the estimator and associated statistics.
}
\description{
Declares an estimator which generates estimates and associated statistics.

Use of \code{declare_test} is identical to use of \code{\link{declare_estimator}}. Use \code{declare_test} for hypothesis testing with no specific estimand in mind; use \code{declare_estimator} for hypothesis testing when you can link each estimate to an estimand. For example, \code{declare_test} could be used for a K-S test of distributional equality and \code{declare_estimator} for a difference-in-means estimate of an average treatment effect.
}
\details{
\code{declare_estimator} is designed to handle two main ways of generating parameter estimates from data.

In \code{declare_estimator}, you can optionally provide the name of an estimand or an objected created by \code{\link{declare_estimand}} to connect your estimate(s) to estimand(s).

The first is through \code{label_estimator(model_handler)}, which is the default value of the \code{handler} argument. Users can use standard modeling functions like lm, glm, or iv_robust. The models are summarized using the function passed to the \code{model_summary} argument. This will usually be a "tidier" like \code{broom::tidy}. The default \code{model_summary} function is \code{tidy_try}, which applies a tidy method if available, and if not, tries to make one on the fly.

An example of this approach is:

\code{declare_estimator(Y ~ Z + X, model = lm_robust, model_summary = tidy, term = "Z", estimand = "ATE")}

The second approach is using a custom data-in, data-out function, usually first passed to \code{label_estimator}. The reason to pass the custom function to \code{label_estimator} first is to enable clean labeling and linking to estimands.

An example of this approach is:

\code{
my_fun <- function(data){ with(data, median(Y[Z == 1]) - median(Y[Z == 0])) }
}

\code{
declare_estimator(handler = label_estimator(my_fun), estimand = "ATE")
}

\code{label_estimator} takes a data-in-data out function to \code{fn}, and returns a data-in-data-out function that first runs the provided estimation function \code{fn} and then appends a label for the estimator and, if an estimand is provided, a label for the estimand.
}
\examples{

# Declare estimand
my_estimand <- declare_estimand(ATE = mean(Y_Z_1 - Y_Z_0))

# Declare estimator using the default handler using `difference_in_means`
# estimator from `estimatr` package. Returns the first non-intercept term
# as estimate

my_estimator_dim <- declare_estimator(Y ~ Z, estimand = "ATE", label = "DIM")

# Use lm function from base R
my_estimator_lm <- declare_estimator(Y ~ Z, estimand = "ATE",
  model = lm, label = "LM")
# Use lm_robust (linear regression with robust standard errors) from
# `estimatr` package

my_estimator_lm_rob <- declare_estimator(
  Y ~ Z,
  estimand = "ATE",
  model = lm_robust,
  label = "LM_Robust"
)

# Set `term` if estimate of interest is not the first non-intercept variable
my_estimator_lm_rob_x <- declare_estimator(
  Y ~ X + Z,
  estimand = my_estimand,
  term = "Z",
  model = lm_robust
)

# Use glm from base R
my_estimator_glm <- declare_estimator(
  Y ~ X + Z,
  family = "gaussian",
  estimand = my_estimand,
  term = "Z",
  model = glm
)

# A probit
estimator_probit <- declare_estimator(
  Y ~ Z,
  model = glm,
  family = binomial(link = "probit"),
  term = "Z"
)

# Declare estimator using a custom handler

# Define your own estimator and use the `label_estimator` function for labeling
# Must have `data` argument that is a data.frame
my_estimator_function <- function(data){
  data.frame(estimate = with(data, mean(Y)))
}

my_estimator_custom <- declare_estimator(
  handler = label_estimator(my_estimator_function),
  estimand = my_estimand
)

# Customize labeling

my_estimator_function <- function(data){
  data.frame(
    estimator_label = "foo",
    estimand_label = "bar",
    estimate = with(data, mean(Y)),
    n = nrow(data),
    stringsAsFactors = FALSE
  )
}

my_estimator_custom2 <- declare_estimator(handler = my_estimator_function)


# Examples

# First, set up the rest of a design
set.seed(42)

design_def <-
  declare_population(N = 100, X = rnorm(N), W = rexp(N, 1), noise = rnorm(N)) +
  declare_potential_outcomes(Y ~ .25 * Z + noise) +
  declare_estimand(ATE = mean(Y_Z_1 - Y_Z_0)) +
  declare_assignment(m = 50) +
  declare_reveal() +
  my_estimator_dim

draw_estimates(design_def)

# Can also use declared estimator on a data.frame
dat <- draw_data(design_def)
my_estimator_dim(dat)

# ----------
# 2. Using existing estimators
# ----------

design <- replace_step(design_def, my_estimator_dim, my_estimator_lm_rob)
draw_estimates(design)

design <- replace_step(design_def, my_estimator_dim, my_estimator_lm)
draw_estimates(design)

design <- replace_step(design_def, my_estimator_dim, my_estimator_glm)
draw_estimates(design)

# ----------
# 3. Using custom estimators
# ----------

design <- replace_step(design_def, my_estimator_dim, my_estimator_custom)

draw_estimates(design)

# The names in your custom estimator return should match with
# your diagnosands when diagnosing a design
my_median <- function(data) data.frame(med = median(data$Y))

my_estimator_median <- declare_estimator(
  handler = label_estimator(my_median),
  estimand = my_estimand
)

design <- replace_step(design_def, my_estimator_dim, my_estimator_median)

draw_estimates(design)

my_diagnosand <- declare_diagnosands(med_to_estimand = mean(med - estimand),
  keep_defaults = FALSE)

\dontrun{
diagnose_design(design, diagnosands = my_diagnosand, sims = 5,
  bootstrap_sims = FALSE)
}

# ----------
# 4. Multiple estimators per estimand
# ----------

design_two <- insert_step(design_def,  my_estimator_lm,
  after = my_estimator_dim)

draw_estimates(design_two)

\dontrun{
diagnose_design(design_two, sims = 5, bootstrap_sims = FALSE)
}
}
