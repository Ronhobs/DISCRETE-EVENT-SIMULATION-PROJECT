import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

# Your provided data
data = np.array([ 74.08,  80.15,  69.38,  77.39,  66.46,  71.16,  75.08,  71.87,  66.66,  69.22,
  74.64,  72.51,  74.69,  76.25,  72.94,  73.08,  70.43,  70.72,  70.33,  67.02,
  72.31,  75.85,  77.54,  94.01,  66.46,  77.63,  95.51,  88.88,  72.22,  81.28,
  79.33,  66.55,  72.73,  67.39,  73.92,  79.80,   68.07,  76.85,  69.28,  70.48,
  70.88,  75.36,  66.59,  70.03,  66.90,   71.63,  85.74,  75.72,  70.57,  74.14,
  68.92,  66.91,  74.70,   67.50,  75.20,   70.29,  71.16, 102.99,  97.45,  76.41,
  87.45,  77.08,  77.36,  66.92,  74.26,  67.67,  67.93,  73.02,  79.03,  76.68,
  77.12,  75.75,  77.62,  68.10,   82.84,  75.93,  91.04,  74.04,  79.26,  75.63,
  88.74,  71.56,  81.08,  71.66,  84.81,  66.86,  72.76,  75.30,   67.41,  75.64,
  74.91,  66.58,  76.52,  75.27,  66.67,  77.96,  78.50,   66.66,  75.23,  77.07])
# Generate theoretical quantiles for the exponential distribution
quantiles = np.linspace(0.01, 0.99, len(data))
theoretical_quantiles = stats.expon.ppf(quantiles, scale=1/np.mean(data))

# Sort the data to match the theoretical quantiles
sorted_data = np.sort(data)

# Perform linear regression on the quantiles
slope, intercept, r_value, p_value, std_err = stats.linregress(theoretical_quantiles, sorted_data)

# Generate a Q-Q plot
plt.figure()
plt.scatter(theoretical_quantiles, sorted_data, color='black')
plt.plot(theoretical_quantiles, intercept + slope*theoretical_quantiles, 'r', label=f'y = {slope:.4f}x + {intercept:.4f}')

# Customize the plot
plt.title('Quantile-Quantile Plot of Service Time For Screening Machine')
plt.legend()

# Remove grid and background
plt.grid(False)
plt.xlim(left=0)
plt.ylim(bottom=0)
plt.gca().set_facecolor('none')

# Show the plot
plt.show()
