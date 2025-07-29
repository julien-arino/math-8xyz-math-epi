## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "23"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----birth-death-setup--------------------------------------------------------
birth_death_CTMC = function(b = 0.01, d = 0.01) {
  t_0 = 0    # Initial time
  N_0 = 100  # Initial population
  
  # Vectors to store time and state. Initialise with initial condition.
  t = t_0
  N = N_0
  
  t_f = 1000  # Final time
  
  # Track the current time and state (could just check last entry in t
  # and N, but will take more operations)
  t_curr = t_0
  N_curr = N_0
  while (t_curr<=t_f) {
    xi_t = (b+d)*N_curr
    if (N_curr == 0) {
      break # Avoid error with rexp when xi_t = 0
    }
    tau_t = rexp(1, rate = xi_t)
    t_curr = t_curr+tau_t
    v = c(b*N_curr, xi_t)/xi_t
    zeta_t = runif(n = 1)
    pos = findInterval(zeta_t, v)+1
    switch(pos,
           { N_curr = N_curr+1},  # Birth
           { N_curr = N_curr-1}) # Death
    N = c(N, N_curr)
    t = c(t, t_curr)
  }
  plot(t, N, type = "l",
       xlab = "Time", ylab = "Population size",
       main = paste("Birth-death CTMC with b =", b, "and d =", d))
}


## ----CTMC_birth_death_b0_01_d0_01,include=FALSE-------------------------------
birth_death_CTMC()


## ----CTMC_birth_death_b0_01_d0_02,include=FALSE-------------------------------
birth_death_CTMC(b=0.01, d=0.02)


## ----birth-death-setup-2,include=FALSE----------------------------------------
birth_death_CTMC = function(b = 0.01, d = 0.01) {
  t_0 = 0    # Initial time
  N_0 = 100  # Initial population
  
  # Vectors to store time and state. Initialise with initial condition.
  t = t_0
  N = N_0
  
  t_f = 1000  # Final time
  
  # Track the current time and state (could just check last entry in t
  # and N, but will take more operations)
  t_curr = t_0
  N_curr = N_0
  while (t_curr<=t_f) {
    xi_t = (b+d)*N_curr
    if (N_curr == 0) {
      break # Avoid error with rexp when xi_t = 0
    }
    tau_t = rexp(1, rate = xi_t)
    t_curr = t_curr+tau_t
    v = c(b*N_curr, xi_t)/xi_t
    zeta_t = runif(n = 1)
    pos = findInterval(zeta_t, v)+1
    switch(pos,
           { N_curr = N_curr+1},  # Birth
           { N_curr = N_curr-1}) # Death
    N = c(N, N_curr)
    t = c(t, t_curr)
    if (t[length(t)]-t[(length(t)-1)] < 5e-6) {
      # If the time step is too small, stop the simulation
      message("Stopping simulation because time step is too small")
      break
    }
  }
  plot(t, N, type = "l",
       xlab = "Time", ylab = "Population size",
       main = paste("Birth-death CTMC with b =", b, "and d =", d))
  return(list(t = t, N = N))
}


## ----CTMC_birth_death_b0_03_d0_01,include=FALSE-------------------------------
results = birth_death_CTMC(b=0.03, d=0.01)
interevent_time = diff(results$t)


## ----plot_CTMC_birth_death_b0_03_d0_01_interevent,include=FALSE---------------
plot(interevent_time, type = "h",
     ylab = "Inter-event time",
     main = "Inter-event time for birth-death CTMC with b=0.03 and d=0.01")


## -----------------------------------------------------------------------------
tail(diff(results$t))


## ----sim-gillespie2-first-----------------------------------------------------
library(GillespieSSA2)
Pop <- 1000
I_0 <- 2
IC <- c(S = (Pop-I_0), I = I_0)
gamma = 1/3
# R0=beta/gamma*S0, so beta=R0*gamma/S0
beta = as.numeric(1.5*gamma/IC["S"])
params <- c(gamma = gamma, beta = beta)
t_f = 100
reactions <- list(
  reaction("beta*S*I", c(S=-1,I=+1), "new_infection"),
  reaction("gamma*I", c(S=+1,I=-1), "recovery")
)
set.seed(NULL)


sol <- ssa(
  initial_state = IC,
  reactions = reactions,
  params = params,
  method = ssa_exact(),
  final_time = t_f,
)
plot(sol$time, sol$state[,"I"], type = "l",
     xlab = "Time (days)", ylab = "Number infectious")


## ----parallel-CTMC-plot, message=FALSE, warning=FALSE-------------------------
library(adaptivetau)
library(future.apply)
# It is useful to have the transitions, rates and 
# names defined in a function
CTMC_SIS <- function() {
  # Define transitions for adaptivetau
  transitions <- list(
    c(S = -1, I = +1),  # new_infection
    c(S = +1, I = -1)   # recovery
  )
  # Define rate function
  rates <- function(x, params, t) {
    c(
      params[["beta"]] * x["S"] * x["I"],
      params[["gamma"]] * x["I"]
    )
  }
  event_names = c("new_infection", "recovery")
  return(list(transitions = transitions, 
              rates = rates,
              event_names = event_names))
}

run_one_sim = function(CTMC, params) {
    IC <- c(S = (params$Pop-params$I_0), 
            I = params$I_0)
    set.seed(NULL)
    sol <- ssa.exact(
        init.values = IC,
        transitions = CTMC$transitions,
        rateFunc = CTMC$rates,
        params = params,
        tf = params$t_f
    )
    # Interpolate result (just I will do)
    wanted_t = 
      seq(from = 0, to = params$t_f, by = 0.01)
    interp_I = approx(x = sol[,"time"], 
                      y = sol[,"I"], 
                      xout = wanted_t)
    names(interp_I) = c("time", "I")
    sol$interp_I = interp_I
    # Return result
    return(sol)
}

# By default, use all available cores
plan(multisession)
## To use fewer workers, leaving one empty for 
# instance
# plan(multisession, availableCores()-1)
## To run sequentially
# plan(sequential)

# Set up parameters not needing computation
params <- list(gamma = 1/3, 
               Pop = 1000, 
               I_0 = 2, 
               R0 = 1.5,
               t_f = 100, nb_sims = 50)
IC <- c(S = (params$Pop-params$I_0), 
        I = params$I_0)
# R0=beta/gamma*S0, so beta=R0*gamma/S0
params = 
  c(params, 
    beta = as.numeric(params$R0*params$gamma /
                        IC["S"]))
# Run the simulation
CTMC <- CTMC_SIS()
SIMS = future_lapply(
  X = 1:params$nb_sims,
  FUN =  function(x) run_one_sim(CTMC, params))
#  Liberate the workers!
stopCluster(cl) 

# Find max y value for plot
y_max = max(unlist(lapply(SIMS, function(x) max(x$interp_I$I))),
            na.rm = TRUE)
# Now plot
plot(SIMS[[1]]$interp_I$time,
     SIMS[[1]]$interp_I$I,
     type = "l", lwd = 0.5,
     xlab = "Time (days)",
     ylab = "Number infectious",
     ylim = c(0, y_max),
     main = paste("CTMC with R0 =", params$R0))
for (i in 2:length(SIMS)) {
  lines(SIMS[[i]]$interp_I$time,
        SIMS[[i]]$interp_I$I,
        type = "l", lwd = 0.5)
}


## ----parallel-CTMC-run-one-sim, message=FALSE, warning=FALSE------------------
run_one_sim = function(params) {
    IC <- c(S = (params$Pop-params$I_0), I = params$I_0)
    params_local <- c(gamma = params$gamma, beta = params$beta)
    reactions <- list(
        # propensity function effects name for reaction
        reaction("beta*S*I", c(S=-1,I=+1), "new_infection"),
        reaction("gamma*I", c(S=+1,I=-1), "recovery")
    )
    set.seed(NULL)
    sol <- ssa(
      initial_state = IC,
      reactions = reactions,
      params = params_local,
      method = ssa_exact(),
      final_time = params$t_f,
      log_firings = TRUE    # This way we keep track of events
    )
    # Interpolate result (just I will do)
    wanted_t = seq(from = 0, to = params$t_f, by = 0.01)
    sol$interp_I = approx(x = sol$time, y = sol$state[,"I"], 
                          xout = wanted_t)
    names(sol$interp_I) = c("time", "I")
    # Return result
    return(sol)
}


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

