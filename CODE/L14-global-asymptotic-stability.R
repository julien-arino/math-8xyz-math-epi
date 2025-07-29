## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "14"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----SIRS_one_sim_prevalence--------------------------------------------------
library(deSolve)
rhs_SIRS <- function(t, x, p) {
  with(as.list(c(x, p)), {
    dS = b + nu * R - d * S - beta * S * I
    dI = beta * S * I - (d + gamma) * I
    dR = gamma * I - (d + nu) * R
    return(list(c(dS, dI, dR)))
  })
}
# Initial conditions
N0 = 1000
I0 = 1
R0 = 0
IC = c(S = N0-(I0+R0), I = I0, R = R0)
# "Known" parametres
d = 1/(80*365.25)
b = N0 * d
gamma = 1/14
nu = 1/365.25
# Set beta s.t. R_0 = 1.5
R_0 = 1.5
beta = R_0 * (d + gamma) / (N0-I0-R0)
params = list(b = b, d = d, gamma = gamma, beta = beta, nu = nu)
times = seq(0, 500, 1)
# Call the numerical integrator
sol_SIRS <- ode(y = IC, times = times, func = rhs_SIRS, 
                parms = params, method = "ode45")
# Plot the result
plot(sol_SIRS[,"time"], sol_SIRS[,"I"], 
     type = "l", lwd = 2,
     xlab = "Time (days)", ylab = "Prevalence")


## ----SIRS_3_sims_prevalence,echo=FALSE----------------------------------------
# Compute the EPs
valeur_PE = function(params) {
  with(as.list(c(params)), {
    OUT = list()
    if (R_0<1) {
      OUT$S_EP = Pop
      OUT$I_EP = 0
      OUT$col = "dodgerblue4"
    } else {
      OUT$S_EP = 1/R_0*Pop
      OUT$I_EP = (1-1/R_0)*(d+nu)/(d+nu+gamma)*Pop
      OUT$col = "darkorange4"
    }
    return(OUT)
  })
}
# RHS function set in previous chunk

# Put the parameters in a list
# "Known" parametres
params = list()
params$Pop = N0
params$d = 1/(80 * 365.25)
params$b = params$Pop * params$d
params$gamma = 1/14
params$nu = 1/365.25
params$t_f = 1200
params$I_0 = I0
# Note that we did not set R_0 or beta. This is done in a loop

# IC. "Static" part (N0, I0, R0) of IC are set in previous chunk
IC = c(S = N0-(I0+R0), I = I0, R = R0)

# Times at which the solution will be returned.
tspan = seq(from = 0, to = params$t_f, by = 0.1)

# Now simulate the ODE. Loop on several values of R_0
R_0 = c(0.8, 1.5, 2.5)
# Save results in a list together with EP values
sol_ODE = list()
EP = list()
# Now loop on R_0
for (r_0 in R_0) {
  # Name for list entry
  entry_name = sprintf("$R_0$=%1.1f",r_0)
  # Keep the current value of R_0 to compute EPs
  params$R_0 = r_0
  # R0=(beta/(d+gamma)) => beta=R0*(d+gamma)
  params$beta = r_0 * (params$d+params$gamma) / (N0-I0-R0)
  # Call numerical integrator
  sol_ODE[[entry_name]] = ode(y = IC,
                              func = rhs_SIRS,
                              times = tspan,
                              parms = params)
  EP[[entry_name]] = valeur_PE(params)
  EP[[entry_name]]$lty = which(r_0 == R_0)
}

# Get maximum value of I across all simulations for plot. Note the use of lapply.
max_I = max(unlist(lapply(sol_ODE, function(x) max(x[,"I"]))))

# Plot
plot(sol_ODE[[1]][,"time"], sol_ODE[[1]][,"I"],
     ylim = c(0, max_I),
     type = "l", lwd = 5, col = EP[[1]]$col, lty = EP[[1]]$lty,
     xlab = "Time (days)", ylab = "Prevalence")
points(x = params$t_f, y = EP[[1]]$I_EP, 
       col = EP[[1]]$col, pch = 19, cex = 2)
for (i in 2:length(sol_ODE)) {
  lines(sol_ODE[[i]][,"time"], sol_ODE[[i]][,"I"],
        type = "l", lwd = 5, col = EP[[i]]$col, lty = EP[[i]]$lty)
  points(x = params$t_f, y = EP[[i]]$I_EP, 
         col = EP[[i]]$col, pch = 19, cex = 2)
}
legend("topright", legend = TeX(names(EP)), cex = 0.8,
       col = unlist(lapply(EP, function(x) x$col)),
       lty = unlist(lapply(EP, function(x) x$lty)),
       lwd = c(3,3,3))


## ----SIRS_bifurcation_R0,echo=FALSE-------------------------------------------
# Values of the EPs
value_EPs = function(R_0, N) {
  EP_I = ifelse(R_0 < 1, 0, (1-1/R_0)*N)
  return(EP_I)
}

R_0 = seq(0.5, 5, by = 0.01)
EP_I = value_EPs(R_0, N = 1000)
# We also show the DFE when R_0>1, so prepare this
R_0_geq_1 = R_0[which(R_0>=1)]
DFE = rep(0, length(R_0_geq_1))

plot(R_0, EP_I,
     type = "l", lwd = 3,
     xlab = TeX("$R_0$"),
     las = 1,
     ylab = "Prevalence at equilibrium")
lines(R_0_geq_1, DFE,
      type = "l", lwd = 3,
      lty = 2)
legend("topleft", legend = c("LAS EP", "Unstable EP"),
       lty = c(1, 2), lwd = c(2,2),
       bty = "n")


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

