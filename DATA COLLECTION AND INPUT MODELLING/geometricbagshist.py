# Given the number of bags per passenger, we will plot a histogram
# with the number of bags on the horizontal axis and the frequency of passengers on the vertical axis.
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt
import pandas as pd
bags_per_passenger = [3, 2, 1, 1, 2, 1, 1, 2, 2, 1, 1, 3, 1, 3, 2, 1, 2, 2, 1, 2, 1, 3, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 1, 2, 2, 1, 3, 1, 1, 3, 1, 1, 2, 2, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 2, 1, 3, 1, 1, 1, 1, 1, 3, 1, 3, 3, 1, 1, 2, 2]
# Convert to DataFrame
df = pd.DataFrame(bags_per_passenger, columns=['Number of Bags'])

# Create a frequency table
frequency_table = df['Number of Bags'].value_counts().reset_index()
frequency_table.columns = ['Number of Bags', 'Frequency']
frequency_table = frequency_table.sort_values(by='Number of Bags').reset_index(drop=True)

# Print the frequency table
print(frequency_table)
# Plotting the histogram
plt.figure(figsize=(8, 6))
plt.hist(bags_per_passenger, bins=range(1, max(bags_per_passenger) + 2), align='left', color='skyblue', edgecolor='black')
plt.xlabel('Number of Bags')
plt.ylabel('Frequency of Passengers')
plt.title('Histogram of Number of Bags per Passenger')
plt.xticks(range(1, max(bags_per_passenger) + 1))
plt.show()
