# Numbers
x = 10         # Integer (Int64)
y = 3.14       # Floating point (Float64)
z = 1 + 2im    # Complex number

# Strings and Characters
greeting = "Hello, Julia!" # String
initial = 'J'             # Char

# Booleans
is_fast = true            # Bool

radius::Float64 = 5.0


# A 1D array (Vector)
A = [1, 2, 3, 4, 5]
println(A[1])  # Prints 1
println(A[end]) # Prints 5

# A 2D array (Matrix)
M = [1 2 3; 4 5 6]

println(M[2, 3]) # Prints 6 (row 2, column 3)

for i in 1:5
  println(i)
end

n = 3
while n > 0
  println(n)
  n -= 1
end

x = 10
if x > 0
  println("Positive")
elseif x < 0
  println("Negative")
else
  println("Zero")
end

function cylinder_volume(r, h)
    return pi * r^2 * h
end

cylinder_volume(r, h) = pi * r^2 * h

volume = cylinder_volume(2, 10) # 125.66

# Method for two numbers
combine(x::Number, y::Number) = x + y

# Method for two strings
combine(x::String, y::String) = x * " " * y

# Method for a number and a string
combine(x::Number, y::String) = y^x # Repeat string x times\end{lstlisting}

combine(2, 3)         # Returns 5
combine("Hello", "World") # Returns "Hello World"
combine(3, "Ha")      # Returns "HaHaHa"

# First, add the package and load it
# Pkg.add("Plots")
using Plots

# Generate data
x = 0:0.1:2*pi
y1 = sin.(x)
y2 = cos.(x)

# Create a plot
plot(x, y1, label="sin(x)", lw=2)
plot!(x, y2, label="cos(x)", linestyle=:dash)
title!("Trigonometric Functions")
xlabel!("x-axis")

@time begin
    sleep(1)
    A = rand(1000, 1000)
    B = A * A'
end

# 1. Load packages
using DifferentialEquations, Plots

# 2. Define the ODE function
#    Note the argument order: u (state), p (params), t (time)
function logistic_growth(u, p, t)
    r, K = p.r, p.K
    return r * u * (1 - u/K)
end

# 3. Set up the problem
u0 = 50.0                       # Initial condition
tspan = (0.0, 100.0)            # Time span
p = (r=0.1, K=100.0)            # Parameters (as a NamedTuple)
prob = ODEProblem(logistic_growth, u0, tspan, p)

# 4. Solve and plot
sol = solve(prob)
plot(sol, label="N(t)", lw=2)

# Built-in positive domain callback
positive_domain = PositiveDomain()
callback = CallbackSet(positive_domain)

# Run the simulation with the nonnegativity constraint
sol = solve(prob, Tsit5(), callback=callback, 
            reltol=1e-10, abstol=1e-10, saveat=0.5)
plot(sol, label="N(t) with positivity", lw=2)

# Import the required Julia libraries
using RCall
using Plots
using DataFrames

# Use the R"""...""" string macro to execute R code directly.
# Here, we create a simple data frame in the R session.
R"""
# Create two vectors for our data
x_vals <- 1:10
y_vals <- x_vals^2 + rnorm(10) # y = x^2 + some random noise

# Combine them into a data frame
my_r_df <- data.frame(X_Values = x_vals, Y_Values = y_vals)

# You can even print the head of the R data frame from here
print(head(my_r_df))
"""

# Use the @rget macro to copy the R object into a Julia variable.
# RCall.jl automatically converts the R data.frame to a Julia DataFrame.
@rget my_r_df

# Check the type of the imported object in Julia
println("The R object 'my_r_df' was imported into Julia as type: ", typeof(my_r_df))

# Create a scatter plot using the Plots.jl library.
scatter(my_r_df.X_Values, my_r_df.Y_Values,
        title="Data from R plotted in Julia",
        xlabel="X Values",
        ylabel="Y Values",
        legend=false,
        markersize=5,
        markercolor=:blue)

# To see the plot, Julia will typically open a plot window.
# If running in a script, you might need to use gui() to display it
# or save it to a file.
savefig("julia_R_plot.png")
