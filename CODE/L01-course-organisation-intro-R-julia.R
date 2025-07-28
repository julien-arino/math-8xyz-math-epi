## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "01"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## -----------------------------------------------------------------------------
X <- 10
X = 10


## -----------------------------------------------------------------------------
L <- list()
L$a <- 10
L$b <- 3
L[["another_name"]] <- "Plouf plouf"


## -----------------------------------------------------------------------------
L <- list(a = 10, b = 3, another_name = "Plouf plouf")


## -----------------------------------------------------------------------------
L[1]
L[[2]]
L$a
L[["b"]]


## -----------------------------------------------------------------------------
x = 1:10
y <- c(x, 12) # Append 12 to x
y
z = c("red", "blue")
z = c(z, 1) # Append 1 to z
z


## -----------------------------------------------------------------------------
A <- mat.or.vec(nr = 2, nc = 3)
B <- matrix(c(1,2,3,4), nr = 2, nc = 2)
B
C <- matrix(c(1,2,3,4), nr = 2, nc = 2, 
            byrow = TRUE)
C


## -----------------------------------------------------------------------------
x


## -----------------------------------------------------------------------------
x+1


## -----------------------------------------------------------------------------
A = data.frame(column_1 = runif(9),
               colour = ifelse(runif(9) < 0.5, 
                               "red", "green"))
A


## -----------------------------------------------------------------------------
summary(A)


## -----------------------------------------------------------------------------
v = c(alpha = 2, beta = 3, gamma = 4, delta = 5)
v


## -----------------------------------------------------------------------------
v["beta"]


## -----------------------------------------------------------------------------
3 * v["beta"]
3 * as.numeric(v["beta"])


## -----------------------------------------------------------------------------
v = c(1,2,3)
names(v) = c("alpha", "beta", "gamma")
v


## -----------------------------------------------------------------------------
A = matrix(c(1,2,3,4), nrow = 2, byrow = TRUE)
rownames(A) = c("alpha","beta")
colnames(A) = c("thingama","doodle")
A
A[1,2]
A["alpha","doodle"]


## -----------------------------------------------------------------------------
L = list()
for (i in 1:3) {
        L[[i]] = runif(i) # i=1 has 1 entry, i=2 has 2 entries, etc.
}
L


## -----------------------------------------------------------------------------
lapply(X = L, FUN = mean)


## -----------------------------------------------------------------------------
unlist(lapply(X = L, FUN = mean))


## -----------------------------------------------------------------------------
sapply(X = L, FUN = mean)


## -----------------------------------------------------------------------------
L = list()
for (i in 1:10) {
        L[[i]] = list()
        L[[i]]$a = runif(i)
        L[[i]]$b = runif(2*i)
}
sapply(X = L, FUN = function(x) length(x$b))


## -----------------------------------------------------------------------------
variations = list(
    p1 = seq(1, 10, length.out = 10),
    p2 = seq(0, 1, length.out = 10),
    p3 = seq(-1, 1, length.out = 10)
)
# Create the list
tmp = expand.grid(variations)
PARAMS = list()
for (i in 1:dim(tmp)[1]) {
    PARAMS[[i]] = list()
    for (k in 1:length(variations)) {
        PARAMS[[i]][[names(variations)[k]]] = tmp[i, k]     
    }
}


## ----population-of-Canada-----------------------------------------------------
pop_data_CTRY <- wb_data(country = "CAN", indicator = "SP.POP.TOTL",
                         mrv = 100, return_wide = FALSE)

ggplot(pop_data_CTRY, aes(x = date, y = value)) +
  geom_line() +
  labs(title = "Population of Canada", x = "Year", y = "Population") +
  scale_y_continuous(
    labels = label_number(scale = 1e-6, suffix = "M")) +
  theme_minimal()


## -----------------------------------------------------------------------------
library(deSolve)
rhs_logistic <- function(t, x, p) {
    with(as.list(x), {
    dN <- p$r * N *(1-N/p$K)
    return(list(dN))
    })
}
params = list(r = 0.1, K = 100)
IC = c(N = 50)
times = seq(0, 100, 1)
sol <- ode(IC, times, rhs_logistic, params)    


## -----------------------------------------------------------------------------
library(deSolve)
rhs_logistic <- function(t, x, p) {
    with(as.list(c(x, p)), {
    dN <- r * N *(1-N/K)
    return(list(dN))
    })
}
params = list(r = 0.1, K = 100)
IC = c(N = 50)
times = seq(0, 100, 1)
sol <- ode(IC, times, rhs_logistic, params)


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()


## ----eval=FALSE---------------------------------------------------------------
# pp = ggplot(...)
# print(pp)

