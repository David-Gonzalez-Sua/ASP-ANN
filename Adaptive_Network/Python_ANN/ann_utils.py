# TODO: Experiment with different network architectures (number of layers, number of neurons per layer) and activation functions (ReLU, sigmoid, softmax) to improve the model's performance.

import numpy as np
from ann import ANN


def create_network(input_size=784, hidden_size=128, num_hidden_layers=2, output_size=10):
    # Image size is 28x28, sp flattened data will have 784 inputs.
    print("Building network...")
    network = ANN()
    network.build_network(input_size, hidden_size, num_hidden_layers, output_size)
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
        for index in range(len(train_images)):
            if index % 100 == 0:
                print(f"Epoch {epoch}, training sample {index}/{len(train_images)}...")

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
    for index in range(len(test_images)):
        if index % 100 == 0:
            print(f"Testing sample {index}/{len(test_images)}...")

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
    accuracy = correct / len(test_images)
    print(f"Test accuracy: {accuracy*100:.2f}%")

def test_single_image(network, test_images, test_labels, index=0):
    print("\nTesting single image from test set...")
    print("Image shape: " + str(test_images[index].shape))
    print("Label: " + str(test_labels[index]))

    np.set_printoptions(linewidth=np.inf)
    print("Image array: \n" + str(test_images[index]))

    network.forward_pass(test_images[index].flatten() / 255.0)
    predicted = np.array([neuron.value for neuron in network.output_layer])
    predicted_label = np.argmax(predicted)
    print(f"Predicted label: {predicted_label}")
    print(f"Output values: {predicted}")

def load_dataset():
    # Load data from .npy file
    train_images = np.load("MNIST_Dataset/train_images.npy")  # Load training images (shape: (60000, 28, 28))
    train_labels = np.load("MNIST_Dataset/train_labels.npy")  # Load training labels (shape: (60000,))
    test_images = np.load("MNIST_Dataset/test_images.npy")  # Load test images (shape: (10000, 28, 28))
    test_labels = np.load("MNIST_Dataset/test_labels.npy")  # Load test labels (shape: (10000,))
    return ((train_images, train_labels), (test_images, test_labels))

def visualize_network(network):
    dot_code = ANN.print_network_dot(network)
    return dot_code

def list_network(network):
    adjacency_list = ANN.print_network_list(network)
    return adjacency_list