# matplotlib for visualization
from matplotlib import pyplot
import numpy as np
import random


# Load the data
train_images = np.load("MNIST_Dataset/train_images.npy")
train_labels = np.load("MNIST_Dataset/train_labels.npy")
# test_images = np.load("MNIST_Dataset/test_images.npy")
# test_labels = np.load("MNIST_Dataset/test_labels.npy")


# Plot a random image from the training set
random_index = random.randint(0, 60000)

# Display the random image
#pyplot.imshow(train_images[random_index], cmap=pyplot.get_cmap('gray'))
#pyplot.title("Label: " + str(train_labels[random_index]))
#pyplot.show()


# Print details of the random image
print("Image shape: " + str(train_images[random_index].shape))
print("Label: " + str(train_labels[random_index]))

np.set_printoptions(linewidth=np.inf)
print("Image array: \n" + str(train_images[random_index]))

np.set_printoptions(linewidth=train_images[random_index].shape[1]*4 + 4)
print("Image array (flattened): \n" + str(train_images[random_index].flatten()))
#print("Image array (min-max normalized): \n" + str(train_images[random_index].flatten()/255.0))
#print("Image array (mean-std normalized): \n" + str((train_images[random_index].flatten()-np.mean(train_images[random_index]))/np.std(train_images[random_index])))

# Display the image after showing details
#pyplot.show()


# Plot the first 9 images from the training set
# for i in range(9):
#     pyplot.subplot(3, 3, i + 1)
#     pyplot.imshow(train_images[i], cmap=pyplot.get_cmap('gray'))
#     pyplot.title("Label: " + str(train_labels[i]))
#     pyplot.axis('off')
# pyplot.show()


# Plot 9 images from the training set with label 0
# zero_indices = np.where(train_labels == 0)[0]
# for i in range(9):
#     pyplot.subplot(3, 3, i + 1)
#     pyplot.imshow(train_images[zero_indices[i]], cmap=pyplot.get_cmap('gray'))
#     pyplot.title("Label: " + str(train_labels[zero_indices[i]]))
#     pyplot.axis('off')
# pyplot.show()


#train_images[random_index][15][1] = 255 - train_images[random_index][15][1]  # Invert a pixel value for testing


# Invert colors of random image and display
# pyplot.subplot(2, 2, 1)
# pyplot.imshow(train_images[random_index])
# pyplot.title("Label: " + str(train_labels[random_index]))
# pyplot.axis('off')

# pyplot.subplot(2, 2, 2)
# inverted_image = 255 - train_images[random_index]
# pyplot.imshow(inverted_image)
# pyplot.title("Inverted colors of label: " + str(train_labels[random_index]))
# pyplot.axis('off')

# pyplot.subplot(2, 2, 3)
pyplot.subplot(1, 2, 1)
pyplot.imshow(train_images[random_index], cmap=pyplot.get_cmap('gray'))
pyplot.title("Label: " + str(train_labels[random_index]))
pyplot.axis('off')

# pyplot.subplot(2, 2, 4)
pyplot.subplot(1, 2, 2)
inverted_image = 255 - train_images[random_index]
pyplot.imshow(inverted_image, cmap=pyplot.get_cmap('gray'))
pyplot.title("Inverted colors of label: " + str(train_labels[random_index]))
pyplot.axis('off')

pyplot.show()