## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "04"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----KMK_SI_plane,echo=FALSE--------------------------------------------------
# Plot the trajectories of the KMK SIR system in the SI-plane
# In this plot, the total population N is normalised to 1
gamma = 1/5
beta = 0.5
# Store the values of S and I in lists
S = list()
I = list()
i = 1
# Solutions starting on the S axis
for (S0 in seq(0.6, 1, 0.1)) {
  I0 = 0
  S[[i]] = seq(0.001, S0, 0.001)
  I[[i]] = S0+I0-S[[i]]+gamma/beta*log(S[[i]]/S0)
  i = i+1
}
# Solutions starting on the S+I=1 line
for (S0 in seq(1, 0.05, -0.1)) {
  I0 = 1-S0
  S[[i]] = seq(0.001, S0, 0.001)
  I[[i]] = S0+I0-S[[i]]+gamma/beta*log(S[[i]]/S0)
  i = i+1
}
# S+I=1 line
S[[i]] = seq(0, 1, 0.001)
I[[i]] = 1-S[[i]]
if (plot_blackBG) {
  par(bg = 'black', fg = 'white') # set background to black, foreground white
  colour = "white"
} else {
  colour = "black"
}
for (i in 1:length(S)) {
  if (i == 1) {
    plot(S[[i]], I[[i]],
         type = "l", lwd = 3,
         col = ifelse((I[[i]][length(I[[i]])] < max(I[[i]])), "red", colour),
         xlim = c(0,1), ylim = c(0,1),
         xaxs = "i", yaxs = "i",
         xlab = "S", ylab = "I",
         col.axis = colour, cex.axis = 1,
         col.lab = colour, cex.lab = 1,
         bty = "n")
    points(S[[i]][length(S[[i]])], I[[i]][length(I[[i]])],
          pch = 19, cex = 2, 
          col = ifelse((I[[i]][length(I[[i]])] < max(I[[i]])), "red", colour))
  } else if (i<length(S)) {
    lines(S[[i]], I[[i]], 
          col = ifelse((I[[i]][length(I[[i]])] < max(I[[i]])), "red", colour),
          lwd = 3)
    points(S[[i]][length(S[[i]])], I[[i]][length(I[[i]])],
           pch = 19, cex = 2, 
           col = ifelse((I[[i]][length(I[[i]])] < max(I[[i]])), "red", colour))
  } else {
    lines(S[[i]], I[[i]])
  }
}


## ----eval=TRUE----------------------------------------------------------------
rhs_SIR_KMK <- function(t, x, p) {
  with(as.list(c(x, p)), {
    dS = - beta * S * I
    dI = beta * S * I - gamma * I
    dR = gamma * I
    return(list(c(dS, dI, dR)))
  })
}
# Initial condition for S (to compute R_0)
S0 = 1000
gamma = 1/14
# Set beta so that R_0 = 1.5
beta = 1.5 * gamma / S0 
params = list(gamma = gamma, beta = beta)
IC = c(S = S0, I = 1, R = 0)
times = seq(0, 365, 1)
sol_KMK <- ode(IC, times, rhs_SIR_KMK, params)  


## ----KMK_R0eq1dot5------------------------------------------------------------
plot(sol_KMK[, "time"], sol_KMK[, "I"], 
     type = "l", lwd = 2,
     main = TeX("Kermack-McKendrick SIR, $R_0=1.5$"),
     xlab = "Time (days)", ylab = "Prevalence")


## ----eval=TRUE----------------------------------------------------------------
final_size_eq = function(S_inf, S0 = 999, I0 = 1, R_0 = 2.5) {
  OUT = S0*(log(S0)-log(S_inf)) - (S0+I0-S_inf)*R_0
  return(OUT)
}


## -----------------------------------------------------------------------------
uniroot(f = final_size_eq, interval = c(0.05, 999))


## -----------------------------------------------------------------------------
final_size = function(L) {
  with(as.list(L), {
  S_inf = uniroot(f = function(x) 
    final_size_eq(S_inf = x, 
                  S0 = S0, I0 = I0, 
                  R_0 = R_0),
    interval = c(0.05, S0))
  return(S_inf$root)
  })
}


## ----KMK_final_size_0p8-------------------------------------------------------
N0 = 1000
I0 = 1
S0 = N0-I0
R_0 = 0.8
S = seq(0.1, S0, by = 0.1)
fs = final_size_eq(S, S0 = S0, I0 = I0, R_0 = R_0)
S_inf = uniroot(f = function(x) final_size_eq(S_inf = x, 
                                              S0 = S0, I0 = I0, 
                                              R_0 = R_0),
                interval = c(0.05, S0))
plot(S, fs, type = "l", ylab = "Value of equation (10)")
abline(h = 0)
points(x = S_inf$root, y = 0, pch = 19)
text(x = S_inf$root, y = 0, labels = "S_inf", adj = c(-0.25,-1))


## ----KMK_final_size_2p5,echo=FALSE--------------------------------------------
N0 = 1000
I0 = 1
S0 = N0-I0
R_0 = 2.5
S = seq(0.1, S0, by = 0.1)
fs = final_size_eq(S, S0 = S0, I0 = I0, R_0 = R_0)
S_inf = uniroot(f = function(x) final_size_eq(S_inf = x, 
                                              S0 = S0, I0 = I0, 
                                              R_0 = R_0),
                interval = c(0.05, S0))
plot(S, fs, type = "l", ylab = "Value of equation (10)")
abline(h = 0)
points(x = S_inf$root, y = 0, pch = 19)
text(x = S_inf$root, y = 0, labels = "S_inf", adj = c(-0.25,-1))    


## ----KMK_attack_rate----------------------------------------------------------
values = expand.grid(
  R_0 = seq(0.01, 3, by = 0.01),
  I0 = seq(1, 100, 1)
)
values$S0 = N0-values$I0
L = split(values, 1:nrow(values))
values$S_inf = sapply(X = L, FUN = final_size)
values$final_size = values$S0-values$S_inf+values$I0
values$attack_rate = (values$final_size / N0)*100

p = levelplot(attack_rate ~ R_0*I0, data = values, 
              xlab = TeX("$R_0$"), ylab = "I(0)",
              col.regions = viridis(100))
print(p)


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

