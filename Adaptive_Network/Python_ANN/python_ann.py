# TODO: Creating a simple feedforward network in python to learn from the NumPy MNIST dataset and perform digit classification.
# 1. Implement a simple feedforward neural network from scratch using Python and NumPy.
# 2. Load the MNIST dataset using NumPy and preprocess the data (normalize pixel values, one-hot encode labels).
# 3. Train the neural network on the MNIST training data and evaluate its performance on the test data.
# 4. Implement a simple backpropagation algorithm to update the weights of the network during training.
# 5. Experiment with different network architectures (number of layers, number of neurons per layer) and activation functions (ReLU, sigmoid, softmax) to improve the model's performance.

import numpy as np
import argparse
#from image_manipulation.image_printer import plot_image
#from McCulloch_Pitts_Network.Python_MCPN.decimal_binary_converter import decimal_to_binary, binary_to_decimal


from neuron import Neuron
from ann import ANN


# Testing the network structure using DOT
# network = ANN()
# network.build_network(input_size=5, hidden_size=10, num_hidden_layers=2, output_size=3)
# network.forward_pass([1, 2, 3, 4, 5])
# print(ANN.print_network_dot(network))



def create_network():
    # Image size is 28x28, sp flattened data will have 784 inputs.
    print("Building network...")
    network = ANN()
    network.build_network(input_size=784, hidden_size=128, num_hidden_layers=2, output_size=10)
    print("Network built successfully.")
    return network

def load_model(filename):
    # Load a previously saved model from a file
    print(f"Loading network from {filename}...")
    network = ANN()
    network.load_network(filename)
    print("Network loaded successfully.")
    return network

def train_network(network, train_images, train_labels, epochs=10, alpha=0.01):
    # Train the ANN on the training data
    print("Starting training with epochs = {}, alpha = {}...".format(epochs, alpha))
    for epoch in range(epochs):
        total_error = 0
        for index in range(training_amount):
            if index % 100 == 0:
                print(f"Epoch {epoch}, training sample {index}/{training_amount}...")

            x_image = train_images[index]
            x_image = x_image.flatten() / 255.0  # Normalize pixel values to [0, 1] and flatten the 28x28 image into a 784-length vector
            
            y_label = train_labels[index]
            y_label_vector = np.zeros(10)
            y_label_vector[y_label] = 1  # One-hot encode the label

            # Forward pass
            network.forward_pass(x_image)
            
            # Backward pass / weight update
            network.backward_pass(y_label_vector, alpha)
            
            # Compute squared error for monitoring
            output_values = [neuron.value for neuron in network.output_layer]
            sample_error = 0.5 * np.sum((np.array(output_values) - y_label_vector) ** 2)
            total_error += sample_error
        print(f"Epoch {epoch}, total training error: {total_error:.4f}")
    print("Training completed.")

def test_network(network, test_images, test_labels):
    # Test the ANN on the test data
    print("Testing the network on test data...")
    correct = 0
    for index in range(testing_amount):
        if index % 100 == 0:
            print(f"Testing sample {index}/{testing_amount}...")

        x_image = test_images[index]
        x_image = x_image.flatten() / 255.0  # Normalize pixel values to [0, 1] and flatten the 28x28 image into a 784-length vector

        y_label = test_labels[index]
        y_label_vector = np.zeros(10)  # Target vector
        y_label_vector[y_label] = 1  # One-hot encode the label

        network.forward_pass(x_image)
        predicted = np.array([neuron.value for neuron in network.output_layer])
        
        # Binary classification: round to 0 or 1
        predicted_label = np.argmax(predicted)  # Get the index of the highest output value as the predicted label
        
        if predicted_label == y_label:
            correct += 1
    accuracy = correct / testing_amount
    print(f"Test accuracy: {accuracy*100:.2f}%")

def test_single_image(network, test_images, test_labels, index=0):
    print("\nTesting single image from test set...")
    index = 0  # Change this index to test different images

    print("Image shape: " + str(test_images[index].shape))
    print("Label: " + str(test_labels[index]))

    np.set_printoptions(linewidth=np.inf)
    print("Image array: \n" + str(test_images[index]))

    network.forward_pass(test_images[index].flatten() / 255.0)
    predicted = np.array([neuron.value for neuron in network.output_layer])
    predicted_label = np.argmax(predicted)
    print(f"Predicted label: {predicted_label}")
    print(f"Output values: {predicted}")


# Load data from .npy file
train_images_full = np.load("MNIST_Dataset/train_images.npy")  # Load training images (shape: (60000, 28, 28))
train_labels_full = np.load("MNIST_Dataset/train_labels.npy")  # Load training labels (shape: (60000,))
test_images_full = np.load("MNIST_Dataset/test_images.npy")  # Load test images (shape: (10000, 28, 28))
test_labels_full = np.load("MNIST_Dataset/test_labels.npy")  # Load test labels (shape: (10000,))

# Create/load ANN
network = create_network()
# network = load_model("Adaptive_Network/Python_ANN/python_trained_model.npy")

# Set training parameters
training_amount = 2000  # Number of training samples to use: 0-60000
testing_amount = 2000  # Number of testing samples to use: 0-10000
epochs = 15  # Number of epochs to train for
alpha = 0.01  # learning rate

# Train ANN
train_images = train_images_full[:training_amount]
train_labels = train_labels_full[:training_amount]
train_network(network, train_images, train_labels, epochs, alpha)

# Test ANN
test_images = test_images_full[:testing_amount]
test_labels = test_labels_full[:testing_amount]
test_network(network, test_images, test_labels)

# Test single image
index = 0  # Change this index to test different images
test_single_image(network, test_images_full, test_labels_full, index)

# Saving the trained model
network.save_network(f"Adaptive_Network/Python_ANN/python_trained_model.npy")
# network.save_network(f"Adaptive_Network/Python_ANN/trained_models/ptm_{training_amount}i_{epochs}e_{int(1000*alpha)}a.npy")
