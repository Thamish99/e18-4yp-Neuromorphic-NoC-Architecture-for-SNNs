import matplotlib.pyplot as plt

# Example data
x = [10, 11, 12, 13, 14, 15,16,17,18,19,
     20, 21, 22, 23, 24, 25,26,27,28,29,30]
y1 = [10.47, 10.19,10.57, 10.17, 10.31, 9.69, 10.99, 10.48, 10.46, 10.3, 
      9.89, 10.34, 10.29, 10.13, 9.85, 10.22, 10.37, 10.07, 10.07, 10.01, 10.29
]
y2 = [11.46 ,11.2 ,11.58 ,11.18 ,11.37 ,10.67 ,12.15 ,11.53 ,11.53 ,11.23 
      ,10.83 ,11.34 ,11.25 ,11.15 ,10.78 ,11.25 ,11.33 ,11.04 ,11.07 ,11.02 ,11.39 ]

# Create a plot
plt.plot(x, y1, marker='o', linestyle='--', color='r', label='Slow 1200mV 85C model')
plt.plot(x, y2, marker='o', linestyle='--', color='b', label='Slow 1200mV 0C model')

# Add title and labels
plt.title("Frequency of Synchronized Message vs Number of Neurons")
plt.xlabel("Number of Neurons")
plt.ylabel("Frequency of Synchronized Message (MHz)")

# Add a legend
plt.legend()

# Add grid
plt.grid(True)

# Save the plot as a file
plt.savefig("plot.png")

# Show the plot
plt.show()
