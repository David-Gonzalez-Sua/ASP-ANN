# MNIST from keras dataset
import tensorflow as tf
#import tf.keras
from tf.keras.datasets import mnist

# loading train and test sets
(train_images, train_labels), (test_images, test_labels) = mnist.load_data()

# finding data count
print('train_images: ' + str(train_images.shape))
print('train_labels: ' + str(train_labels.shape))
print('test_images: ' + str(test_images.shape))
print('test_labels: ' + str(test_labels.shape))

