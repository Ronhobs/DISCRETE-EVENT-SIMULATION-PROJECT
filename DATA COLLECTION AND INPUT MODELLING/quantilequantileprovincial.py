# The provided code snippet seems to be attempting to fit the data to an exponential distribution.
# For a normal distribution, we need to use the normal probability plot (Q-Q plot) from scipy.stats.

# Let's adjust the code to generate a Q-Q plot for the given normal distribution data:

import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

# Your provided data
data = np.array([
    74.08,  80.15,  69.38,  77.39,  66.46,  71.16,  75.08,  71.87,  66.66,  69.22,
    74.64,  72.51,  74.69,  76.25,  72.94,  73.08,  70.43,  70.72,  70.33,  67.02,
    72.31,  75.85,  77.54,  94.01,  66.46,  77.63,  95.51,  88.88,  72.22,  81.28,
    79.33,  66.55,  72.73,  67.39,  73.92,  79.80,  68.07,  76.85,  69.28,  70.48,
    70.88,  75.36,  66.59,  70.03,  66.90,  71.63,  85.74,  75.72,  70.57,  74.14,
    68.92,  66.91,  74.70,  67.50,  75.20,  70.29,  71.16, 102.99,  97.45,  76.41,
    87.45,  77.08,  77.36,  66.92,  74.26,  67.67,  67.93,  73.02,  79.03,  76.68,
    77.12,  75.75,  77.62,  68.10,  82.84,  75.93,  91.04,  74.04,  79.26,  75.63,
    88.74,  71.56,  81.08,  71.66,  84.81,  66.86,  72.76,  75.30,  67.41,  75.64,
    74.91,  66.58,  76.52,  75.27,  66.67,  77.96,  78.50,  66.66,  75.23,  77.07
])

# Plot adjustments
fig, ax = plt.subplots()
res = stats.probplot(data, dist="norm", plot=ax)

# Customize the plot
ax.set_title('Quantile Quantile Plot for Normal Distribution')
ax.set_xlabel('Quantities of Standard Normal')
ax.set_ylabel('Arrival Times')
ax.get_lines()[1].set_visible(False)  # Hides the regression line
ax.get_lines()[0].set_markerfacecolor('black')  # Changes points to black
ax.get_lines()[0].set_markeredgecolor('black')
ax.grid(False)  # Removes the grid

plt.show()

