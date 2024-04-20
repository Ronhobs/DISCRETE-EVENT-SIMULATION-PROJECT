import numpy as np
np.random.seed(11)
def clcg_modulus(a, m, seed):
    """Generate next random number using modulus and the given parameters."""
    return (a * seed) % m

# CLCG parameters for two generators
m1, a1, seed1 = 2147483563, 40014, 1
m2, a2, seed2 = 2147483399, 40692, 1

num_passengers = 100
p_stop = 0.8
max_bags = 3
bags_per_passenger = []

for _ in range(num_passengers):
    # Each passenger starts with one bag
    bags = 1
    while bags < max_bags:
        # Generate a random number using CLCG
        seed1 = clcg_modulus(a1, m1, seed1)
        seed2 = clcg_modulus(a2, m2, seed2)
        
        # Combine two generators
        z = (seed1 - seed2) % m1
        u = z / m1
        
        # Stop if the passenger decides not to bring another bag
        if u < p_stop:
            break
        bags += 1
    
    bags_per_passenger.append(bags)

# Show the number of bags for the first 100 passengers
print(bags_per_passenger[:100])
