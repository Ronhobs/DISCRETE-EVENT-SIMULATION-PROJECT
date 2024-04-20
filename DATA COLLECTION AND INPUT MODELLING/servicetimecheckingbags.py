import numpy as np

# Set seed for reproducibility
np.random.seed(4)


# Define the rate parameter (lambda, λ) for the exponential distribution
lambda_param = 1


# Generate 100 uniform random numbers between 0 and 1
uniform_random_numbers = np.random.uniform(0, 1, 100)

# Apply the inverse-transform technique to generate exponential variates
exponential_variates = -np.log(1 - uniform_random_numbers) / lambda_param

# Round the 100 generated exponential variates to 2 decimal places
rounded_exponential_variates = np.round(exponential_variates, 2)

# Round the 100 uniform random numbers to 2 decimal places
rounded_uniform_random_numbers = np.round(uniform_random_numbers, 2)

# Print the rounded exponential variates and uniform random numbers
print("Rounded Exponential Variates:", rounded_exponential_variates)
print("Rounded Uniform Random Numbers:", rounded_uniform_random_numbers)