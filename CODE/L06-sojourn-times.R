## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "06"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----distrib_a_b,eval=TRUE,echo=FALSE,fig.width=8,fig.height=6,include=FALSE----
# Parameters for normal distribution
mu <- 5      # mean (mode for normal distribution)
sigma <- 1.5 # standard deviation
a <- 4       # left boundary
b <- 7       # right boundary

# Create x values for plotting
x <- seq(mu - 4*sigma, mu + 4*sigma, length.out = 1000)
y <- dnorm(x, mean = mu, sd = sigma)

# Create x values for shaded area
x_fill <- seq(a, b, length.out = 200)
y_fill <- dnorm(x_fill, mean = mu, sd = sigma)

# Plot the distribution (no bounding box, axes shown)
plot(x, y, type = "l", lwd = 3, col = fg_colour,
     xlab = "t", ylab = "f(t)",
     axes = FALSE, frame.plot = FALSE)

# Add shaded area (from curve to y=0)
polygon(c(a, x_fill, b), c(0, y_fill, 0), 
         col = fill_colour, border = NA, density = 20)

# Add horizontal line at y=0
abline(h=0, col = fg_colour, lty = 1, lwd = 1)
# Add vertical lines at a and b
abline(v = a, col = "red", lwd = 2, lty = 2)
abline(v = b, col = "red", lwd = 2, lty = 2)

# Add labels
text(a, -0.02, "a", pos = 1, cex = 1.2, col = "red", font = 2)
text(b, -0.02, "b", pos = 1, cex = 1.2, col = "red", font = 2)


## ----distrib_minf_b,eval=TRUE,echo=FALSE,include=FALSE------------------------
# Parameters for normal distribution
mu <- 5      # mean (mode for normal distribution)
sigma <- 1.5 # standard deviation
a <- mu - 4*sigma       # left boundary
b <- 7       # right boundary

# Create x values for plotting
x <- seq(mu - 4*sigma, mu + 4*sigma, length.out = 1000)
y <- dnorm(x, mean = mu, sd = sigma)

# Create x values for shaded area
x_fill <- seq(a, b, length.out = 200)
y_fill <- dnorm(x_fill, mean = mu, sd = sigma)

# Plot the distribution (no bounding box, axes shown)
plot(x, y, type = "l", lwd = 3, col = fg_colour,
     xlab = "t", ylab = "f(t)",
     axes = FALSE, frame.plot = FALSE)

# Add shaded area (from curve to y=0)
polygon(c(a, x_fill, b), c(0, y_fill, 0), 
         col = fill_colour, border = NA, density = 20)

# Add horizontal line at y=0
abline(h=0, col = fg_colour, lty = 1, lwd = 1)
# Add vertical lines at b
abline(v = b, col = "red", lwd = 2, lty = 2)
# Add labels
text(b, -0.02, "b", pos = 1, cex = 1.2, col = "red", font = 2)


## ----pdf-cdf-surv-normal,eval=TRUE,echo=FALSE,include=FALSE-------------------
# Parameters for normal distribution
mu <- 5
sigma <- 1.5
x <- seq(mu - 4*sigma, mu + 4*sigma, length.out = 1000)

# Compute functions
pdf <- dnorm(x, mean = mu, sd = sigma)
cdf <- pnorm(x, mean = mu, sd = sigma)
surv <- 1 - cdf

# Plot all three functions
plot(x, pdf, type = "l", col = "blue", lwd = 2,
     ylim = c(0, 1), xlab = "t", ylab = "Value",
     main = "PD, CD and Survival functions",
     xaxt = "n")
lines(x, cdf, col = "darkgreen", lwd = 2, lty = 2)
lines(x, surv, col = "red", lwd = 2, lty = 3)

# Add legend
legend("right",
       legend = c("PDF", "CDF", "Survival"),
       col = c("blue", "darkgreen", "red"),
       lty = c(1, 2, 3),
       lwd = 2,
       cex = 0.9)


## ----pdf-cdf-surv-hazard-normal,eval=TRUE,echo=FALSE,include=FALSE------------
# Parameters for normal distribution
mu <- 5
sigma <- 1.5
x <- seq(mu - 4*sigma, mu + 4*sigma, length.out = 1000)

# Compute functions
pdf <- dnorm(x, mean = mu, sd = sigma)
cdf <- pnorm(x, mean = mu, sd = sigma)
surv <- 1 - cdf

# Plot all three functions
plot(x, pdf, type = "l", col = "blue", lwd = 2,
     ylim = c(0, 1), xlab = "t", ylab = "Value",
     main = "PD, CD and Survival functions & Hazard rate",
     xaxt = "n")
lines(x, cdf, col = "darkgreen", lwd = 2, lty = 2)
lines(x, surv, col = "red", lwd = 2, lty = 3)
lines(x, pdf/surv, col = fg_colour, lty = 3, lwd = 1)

# Add legend
legend("right",
       legend = c("PDF", "CDF", "Survival", "Hazard"),
       col = c("blue", "darkgreen", "red", "black"),
       lty = c(1, 2, 3, 3),
       lwd = 2,
       cex = 0.9)


## ----pdf-cdf-surv-hazard-expon,eval=TRUE,echo=FALSE,include=FALSE-------------
# Parameters for exponential distribution
lambda <- 0.8
x <- seq(0, 10, length.out = 1000)

# Compute functions
pdf <- dexp(x, rate = lambda)
cdf <- pexp(x, rate = lambda)
surv <- 1 - cdf

# Plot all three functions
plot(x, pdf, type = "l", col = "blue", lwd = 2,
     ylim = c(0, 1), xlab = "t", ylab = "Value",
     main = "PD, CD and Surv. functions & Hazard rate of exponential")
lines(x, cdf, col = "darkgreen", lwd = 2, lty = 2)
lines(x, surv, col = "red", lwd = 2, lty = 3)
lines(x, pdf/surv, col = fg_colour, lty = 3, lwd = 1)

# Add legend
legend("right",
       legend = c("PDF", "CDF", "Survival", "Hazard"),
       col = c("blue", "darkgreen", "red", "black"),
       lty = c(1, 2, 3, 3),
       lwd = 2,
       cex = 0.9)


## ----pdf-cdf-surv-hazard-gamma,eval=TRUE,echo=FALSE,include=FALSE-------------
# Parameters for gamma distribution
shape <- 3       # shape parameter (k)
scale <- 2       # scale parameter (θ)
x <- seq(0, shape*scale + 4*scale, length.out = 1000)

# Compute functions
pdf    <- dgamma(x, shape = shape, scale = scale)
cdf    <- pgamma(x, shape = shape, scale = scale)
surv   <- 1 - cdf
hazard <- pdf / surv

# Plot all four curves
plot(x, pdf, type = "l", col = "blue",      lwd = 2,
     ylim = c(0, 1), xlab = "t", ylab = "Value",
     main = "PDF, CDF, Survival & Hazard of Gamma Distribution")
lines(x, cdf,    col = "darkgreen", lwd = 2, lty = 2)
lines(x, surv,   col = "red",       lwd = 2, lty = 3)
lines(x, hazard, col = fg_colour,   lwd = 1, lty = 3)

# Legend
legend("right",
       legend = c("PDF", "CDF", "Survival", "Hazard"),
       col    = c("blue","darkgreen","red","black"),
       lty    = c(1,2,3,3),
       lwd    = c(2,2,2,1),
       cex    = 0.9)


## ----prop_surviving_exp_80years,eval=TRUE,echo=FALSE,fig.width=8,fig.height=6,include=FALSE----
plot_blackBG = FALSE
if (plot_blackBG) {
  par(bg = 'black', fg = 'white') # set background to black, foreground white
  colour = "white"
} else {
  colour = "black"
}
t = 0:150
plot(t,exp(-1/80*t), lwd = 2, ylim = c(0,1), col = colour,
     xlab = "Age (years)", ylab = "Proportion of cohort surviving",
     type = "l")
abline(v = 80,
       col = "red", lwd = 2)
grid(lwd=2)


## ----prop_surviving_dirac_80years,eval=TRUE,echo=FALSE,fig.width=8,fig.height=6,include=FALSE----
plot_blackBG = FALSE
if (plot_blackBG) {
  par(bg = 'black', fg = 'white') # set background to black, foreground white
  colour = "white"
} else {
  colour = "black"
}
plot(0:80, rep(1, length(0:80)), lwd = 2, 
     xlim = c(0, 150), ylim = c(0,1), 
     col = colour,
     xlab = "Age (years)", 
     ylab = "Proportion of cohort surviving",
     type = "l")
lines(80:150, rep(0, length(80:150)), 
      lwd = 2, col = colour, type = "l")
abline(v = 80,
       col = "red", lwd = 2)
grid(lwd=2)


## ----prop_surviving_exp_80years_details,eval=TRUE,echo=FALSE,fig.width=8,fig.height=6,include=FALSE----
if (plot_blackBG) {
  par(bg = 'black', fg = 'white') # set background to black, foreground white
  colour = "white"
} else {
  colour = "black"
}
# Set paramaters
d_1 = 1/80 
y_1 = seq(0, 200, 0.1)
S_1 = 1-pexp(y_1, d_1)
d_2 = 1/4
y_2 = seq(0, 20, 0.05)
S_2 = 1-pexp(y_2, d_2)
# Find some locations
idx_50_years = max(which(y_1<=50))
idx_80_years = max(which(y_1<=80))
idx_100_years = min(which(y_1>=100))
idx_150_years = min(which(y_1>=150))
idx_1_days = max(which(y_2<=1))
idx_10_days = max(which(y_2<=10))
# Plot
par(mfrow = c(1,2))
plot(y_2, S_2,
     type = "l", lwd = 3,
     xaxs = "i", yaxs = "i",
     ylim = c(0, 1.02),
     xlab = "t (days)", ylab = "S(t)")
abline(v = 4, lwd = 2, lty = 3, col = "red")
lines(x = c(1, 1), y = c(0, S_2[idx_1_days]),
      lty = 3, lwd = 1)
lines(x = c(0, 1), y = c(S_2[idx_1_days], S_2[idx_1_days]),
      lty = 3, lwd = 1)
lines(x = c(10, 10), y = c(0, S_2[idx_10_days]),
      lty = 3, lwd = 1)
lines(x = c(0, 10), y = c(S_2[idx_10_days], S_2[idx_10_days]),
      lty = 3, lwd = 1)
points(x = 1, y = S_2[idx_1_days], pch = 19)
points(x = 10, y = S_2[idx_10_days], pch = 19)
text(x = 1, y = S_2[idx_1_days], 
     labels = paste0(round(S_2[idx_1_days], 2)),
     pos = 4)
text(x = 10, y = S_2[idx_10_days], 
     labels = paste0(round(S_2[idx_10_days], 2)),
     pos = 3)
text(x = 4, y = 0.8, 
     labels = "Avg. 4 days", col = "red",
     pos = 4)

plot(y_1, S_1,
     type = "l", lwd = 3,
     xaxs = "i", yaxs = "i",
     ylim = c(0, 1.02),
     xlab = "t (years)", ylab = "S(t)")
abline(v = 80, lwd = 2, lty = 3, col = "red")
lines(x = c(50, 50), y = c(0, S_1[idx_50_years]),
      lty = 3, lwd = 1)
lines(x = c(0, 50), y = c(S_1[idx_50_years], S_1[idx_50_years]),
      lty = 3, lwd = 1)
lines(x = c(100, 100), y = c(0, S_1[idx_100_years]),
      lty = 3, lwd = 1)
lines(x = c(0, 100), y = c(S_1[idx_100_years], S_1[idx_100_years]),
      lty = 3, lwd = 1)
lines(x = c(150, 150), y = c(0, S_1[idx_150_years]),
      lty = 3, lwd = 1)
lines(x = c(0, 150), y = c(S_1[idx_150_years], S_1[idx_150_years]),
      lty = 3, lwd = 1)
points(x = 50, y = S_1[idx_50_years], pch = 19)
points(x = 100, y = S_1[idx_100_years], pch = 19)
points(x = 150, y = S_1[idx_150_years], pch = 19)
text(x = 50, y = S_1[idx_50_years], 
     labels = paste0(round(S_1[idx_50_years], 2)),
     pos = 4)
text(x = 100, y = S_1[idx_100_years], 
     labels = paste0(round(S_1[idx_100_years], 2)),
     pos = 3)
text(x = 150, y = S_1[idx_150_years], 
     labels = paste0(round(S_1[idx_150_years], 2)),
     pos = 3)
text(x = 80, y = 0.8, 
     labels = "Avg. 80 years", col = "red",
     pos = 4)


## ----error_Gamma,eval=TRUE,echo=TRUE------------------------------------------
error_Gamma <- function(theta,shape,t,data) {
  test_points <- dgamma(t, shape = shape, scale = theta)
  ls_error <- sum((data-test_points)^2)
  return(ls_error)
}


## ----optimise_gamma-----------------------------------------------------------
optimize_gamma <- function(t,d) {
  max_shape <- 10
  error_vector <- mat.or.vec(max_shape,1)
  scale_vector <- mat.or.vec(max_shape,1)
  for (i in 1:max_shape) {
    result_optim <- try(optim(par = 3,
                              fn = error_Gamma,
                              lower = 0,
                              method = "L-BFGS-B",
                              shape = i,
                              t = t,
                              data = d),
                        TRUE)
    if (!inherits(result_optim,"try-error")) {
      error_vector[i] <- result_optim$value
      scale_vector[i] <- result_optim$par
    } else {
      error_vector[i] <- NaN
      scale_vector[i] <- NaN
    }
  }
  result_optim <- data.frame(seq(1,max_shape),
                             scale_vector,
                             error_vector)
  colnames(result_optim) <- c("shape","scale","error")
  result_optim <- result_optim[complete.cases(result_optim),]
  return(result_optim)
}


## ----run_optim_Erlang---------------------------------------------------------
time_points <- seq(0,60)
data_points <- dgamma(time_points, shape = 1.57, 
                      scale = 6.53)
# Run the minimization
optim_fits <- optimize_gamma(time_points,data_points)
# Which is the best Erlang to fit the data
idx_best <- which.min(optim_fits$error)


## ----plot_results_optim_Erlang,eval=TRUE,echo=FALSE,fig.width=8,fig.height=6,include=FALSE----
time_points_plot <- seq(0,60,0.05)
found_points_plot <- 
  dgamma(time_points_plot,
         shape = optim_fits[idx_best,]$shape,
         scale = optim_fits[idx_best,]$scale)
max_y <- max(max(data_points),max(found_points_plot))
plot(time_points,data_points, ylim = c(0,max_y),
     xlab = "Days", ylab = "Frequency", col = "red",pch = 16)
lines(time_points_plot,found_points_plot,
      type="l",lwd=2,col="blue")
legend("topright", legend = c("Data","Best Erlang fit"),
       col=c("red","blue"),
       lwd = c(1,2), lty = c(NA,1), pch = c(16,NA))


## ----convert-Rnw-to-R,echo=FALSE,warning=FALSE,message=FALSE,results='hide'----
# From https://stackoverflow.com/questions/36868287/purl-within-knit-duplicate-label-error
rmd_chunks_to_r_temp <- function(file){
  callr::r(function(file){
    out_dir <- "../CODE"
    if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
    out_file = sprintf("%s/%s", out_dir, gsub(".Rnw", ".R", basename(file)))
    knitr::purl(file, output = out_file, documentation = 1)
  }, args = list(file))
}
rmd_chunks_to_r_temp("L06-sojourn-times.Rnw")

