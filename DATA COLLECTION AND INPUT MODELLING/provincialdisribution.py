import numpy as np
np.random.seed(24)

# Define the parameters for the CLCG
# These are chosen as example values, and they should ideally be prime numbers for better randomness
m1, a1, c1, seed1 = 2**31-1, 1103515245, 12345, np.random.randint(0, 2**31-1)
m2, a2, c2, seed2 = 2**31-1, 1664525, 1013904223, np.random.randint(0, 2**31-1)

# The mean and standard deviation for the normal distribution
mean = 75
std_dev = np.sqrt(50)

# Number of random numbers to generate (number of passengers)
num_passengers = 100

# Function to generate a random number using the CLCG
def clcg(seed, m, a, c):
    return (a * seed + c) % m

# Function to combine two CLCGs
def combined_clcg(seed1, seed2, m1, a1, c1, m2, a2, c2):
    # Generate the next random number with each LCG
    z1 = clcg(seed1, m1, a1, c1)
    z2 = clcg(seed2, m2, a2, c2)
    
    # Combine them to get the final random number
    z = (z1 - z2) % m1
    if z < 0:
        z += m1
    return z / m1, z1, z2

# Generate random numbers
passenger_times = []
for _ in range(num_passengers):
    # Get a combined random number from the CLCGs
    u, seed1, seed2 = combined_clcg(seed1, seed2, m1, a1, c1, m2, a2, c2)
    
    # Convert the uniform random number to a normal random number using Box-Muller transform
    z = np.sqrt(-2 * np.log(u)) * np.cos(2 * np.pi * u)
    time = mean + std_dev * z
    
    passenger_times.append(time)
passenger_times= np.round(passenger_times, 2)
print(passenger_times[:100])
