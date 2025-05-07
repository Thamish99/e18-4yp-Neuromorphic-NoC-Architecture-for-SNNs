import matplotlib.pyplot as plt

# Example data
x = [1, 2, 3, 4, 5,6,7,8,9,
     10, 11, 12, 13, 14, 15,16,17,18,19,
     20, 21, 22, 23, 24, 25,26,27,28,29,30]
y1 = [16.87,16.87,16.87,16.87,16.01,16.01,16.87,10.92,11.32,16.87,
      16.87, 16.87,10.7,11.24,11.12,11.23,16.87,10.73,10.73,16.87,
      16.87,16.87,16.87,10.56,10.3,12.78,13.58,16.87,10.74,10.58]
y2 = [18.5, 18.5, 18.5, 18.5, 17.66, 17.66,18.5, 12.02 ,12.43, 18.5,
      18.5,18.5,11.66,12.32,12.19,12.31,18.5,11.76,11.76,18.5,
      18.5,18.5,18.5,11.58,11.31,14.02,14.88,18.5,11.76,11.63]

y3 = [18.5, 18.5, 17.0, 18.5, 17.5, 16.8, 15.5, 14.8, 15.5, 11.5,
      10.5, 10.5, 10.5, 10.5, 8.5, 5.8, 6.9, 2.8, 4.5, 4.5,
      1.6, 0.6, 0.8, 0.03, 0.04, 0.08, 0.04, 0.04, 0.02, 0.01]

# Create a plot
plt.plot(x, y1, marker='o', linestyle='--', color='r', label='Dedicated FIFO Buffers')
plt.plot(x, y3, marker='o', linestyle='--', color='b', label='One FIFO Buffer at the Network Interface')

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
