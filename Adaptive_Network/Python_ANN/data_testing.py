import numpy as np

# Load data from .npy file
train_images = np.load("MNIST_Dataset/train_images.npy")
train_labels = np.load("MNIST_Dataset/train_labels.npy")
test_images = np.load("MNIST_Dataset/test_images.npy")
test_labels = np.load("MNIST_Dataset/test_labels.npy")

# Check the shapes of the loaded data
print("Train images shape:", train_images.shape)  # Should be (60000, 28, 28)
print("Train labels shape:", train_labels.shape)  # Should be (60000,)
print("Test images shape:", test_images.shape)    # Should be (10000, 28, 28)
print("Test labels shape:", test_labels.shape)    # Should be (10000,)

# Check format of a sample image and label
print("\nSample train image (first image):\n", train_images[0])
print("Sample train label (first label):", train_labels[0])