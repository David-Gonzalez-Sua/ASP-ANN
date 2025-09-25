# MNIST from keras dataset
import tensorflow as tf
from keras.datasets import mnist
import numpy as np


# loading train and test sets
(train_images, train_labels), (test_images, test_labels) = mnist.load_data()

# finding data count
print('train_images: ' + str(train_images.shape))
print('train_labels: ' + str(train_labels.shape))
print('test_images: ' + str(test_images.shape))
print('test_labels: ' + str(test_labels.shape))
''' output:
train_images: (60000, 28, 28)
train_labels: (60000,)
test_images: (10000, 28, 28)
test_labels: (10000,)
'''

# Saving data
np.save("MNIST_Dataset/train_images.npy", train_images)
np.save("MNIST_Dataset/train_labels.npy", train_labels)
np.save("MNIST_Dataset/test_images.npy", test_images)
np.save("MNIST_Dataset/test_labels.npy", test_labels)
print("Data saved")

'''
To load the data again, use the following code:
train_images = np.load("MNIST_Dataset/train_images.npy")
train_labels = np.load("MNIST_Dataset/train_labels.npy")
test_images = np.load("MNIST_Dataset/test_images.npy")
test_labels = np.load("MNIST_Dataset/test_labels.npy")
'''
