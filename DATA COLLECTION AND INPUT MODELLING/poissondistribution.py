import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Set seed for reproducibility
np.random.seed(0)

# Average arrival rate
lam = 40

# Number of passengers
num_passengers = 100

# Generate Poisson random variates
arrival_times = np.random.exponential(lam, num_passengers)

# Create a DataFrame
df = pd.DataFrame({'Arrival Time': arrival_times})

# Calculate frequency
frequency = df['Arrival Time'].value_counts().sort_index()

# Create a DataFrame for frequency
frequency_df = pd.DataFrame({'Arrival Time': frequency.index, 'Frequency': frequency.values})

# Plot a histogram
plt.bar(frequency_df['Arrival Time'], frequency_df['Frequency'], color='skyblue')
plt.xlabel('Number of Arrivals')
plt.ylabel('Frequency')
plt.title('Histogram of Commuter Arrivals per Hour')
plt.show()

# Print the DataFrame
print(frequency_df)
