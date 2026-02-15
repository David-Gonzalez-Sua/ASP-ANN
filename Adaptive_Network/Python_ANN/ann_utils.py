# TODO: Experiment with different network architectures (number of layers, number of neurons per layer) and activation functions (ReLU, sigmoid, softmax) to improve the model's performance.

import sys
import time

import numpy as np

from ann import ANN


def create_network(input_size=784, num_hidden_layers=2, hidden_size=128, output_size=10):
    # Image size is 28x28, sp flattened data will have 784 inputs.
    try:
        print("Network properties:")
        print(f"    Input layer size = {input_size}")
        print(f"    Hidden layers = {num_hidden_layers}")
        print(f"    Hidden layer size = {hidden_size}")
        print(f"    Output layer size = {output_size}")

        print("Building network...")
        start_time = time.perf_counter()
        start_cpu = time.process_time()

        network = ANN()
        network.build_network(input_size, hidden_size, num_hidden_layers, output_size)

        end_time = time.perf_counter()
        end_cpu = time.process_time()

        print("Network built successfully.")
        print(f"Wall-clock time: {end_time - start_time} seconds")
        print(f"CPU time: {end_cpu - start_cpu} seconds\n")

        return network
    
    except Exception as e:
        print(f"Error building network: {e}")
        return 0

def load_model(filename):
    try:
        # Load a previously saved model from a file
        print(f"Loading network from {filename}...")

        network = ANN()
        network.load_network(filename)

        print("Network loaded successfully.")
        print(f"Network properties:")
        print(f"    Input layer size = {len(network.input_layer)}")
        print(f"    Hidden layers = {len(network.hidden_layers)}")
        print(f"    Hidden layer size = {len(network.hidden_layers[0])}")
        print(f"    Output layer size = {len(network.output_layer)}")
        print()

        return network
    
    except Exception as e:
        print(f"Error loading model: {e}")
        return 0

def train_network(network, loss, activation, train_images, train_labels, epochs=10, alpha=0.01):
    # Train the ANN on the training data
    try:
        print("Training parameters:")
        print(f"    Loss fucnction = {loss}")
        print(f"    Activation function = {activation}")
        # print(f"    Training sample size = {len(train_images)}")
        print(f"    Epochs = {epochs}")
        print(f"    Alpha = {alpha}")

        print("\nStarting training...")
        start_time = time.perf_counter()
        start_cpu = time.process_time()

        for epoch in range(epochs):
            epoch_time = time.perf_counter()
            epoch_cpu = time.process_time()

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
                network.forward_pass(activation, x_image)
                
                # Backward pass / weight update
                network.backward_pass(loss, activation, y_label_vector, alpha)
                
                # Compute squared error for monitoring
                output_values = [neuron.value for neuron in network.output_layer]
                sample_error = 0.5 * np.sum((np.array(output_values) - y_label_vector) ** 2)
                total_error += sample_error

            epoch_end_time = time.perf_counter()
            epoch_end_cpu = time.perf_counter()
            remaining_time = (epoch_time - epoch_end_time) * (epochs - epoch - 1)
            print(f"Epoch {epoch}, total training error: {total_error:.4f}")
            print(f"Epoch wall-clock time: {epoch_time - epoch_end_time} seconds")
            print(f"Epoch CPU time: {epoch_cpu - epoch_end_cpu} seconds")
            print(f"Estimated time remaining: {remaining_time} seconds -> {remaining_time / 60} minutes -> {remaining_time / 3600} hours\n")

        end_time = time.perf_counter()
        end_cpu = time.process_time()

        print("Training completed.")
        print(f"Wall-clock time: {end_time - start_time} seconds")
        print(f"CPU time: {end_cpu - start_cpu} seconds\n")

        return 1

    except Exception as e:
        print(f"Error training model: {e}")
        return 0

def test_network(network, activation, test_images, test_labels):
    # Test the ANN on the test data
    try:
        print("Testing parameters:")
        print(f"    Activation function = {activation}")
        # print(f"    Testing sample size = {len(test_images)}")
        print()

        print("Testing the network on test data...")
        start_time = time.perf_counter()
        start_cpu = time.process_time()

        correct = 0
        for index in range(len(test_images)):
            if index % 100 == 0:
                print(f"Testing sample {index}/{len(test_images)}...")

            x_image = test_images[index]
            x_image = x_image.flatten() / 255.0  # Normalize pixel values to [0, 1] and flatten the 28x28 image into a 784-length vector

            y_label = test_labels[index]
            y_label_vector = np.zeros(10)  # Target vector
            y_label_vector[y_label] = 1  # One-hot encode the label

            # Forward pass
            network.forward_pass(activation, x_image)
            
            # Extract output
            predicted = np.array([neuron.value for neuron in network.output_layer])
            
            # Binary classification: round to 0 or 1
            predicted_label = np.argmax(predicted)  # Get the index of the highest output value as the predicted label
            
            if predicted_label == y_label:
                correct += 1
        accuracy = correct / len(test_images)
        
        end_time = time.perf_counter()
        end_cpu = time.process_time()

        print("Testing completed.")
        print(f"Test accuracy: {accuracy*100:.2f}%")
        print(f"Wall-clock time: {end_time - start_time} seconds")
        print(f"CPU time: {end_cpu - start_cpu} seconds\n")

        return 1

    except Exception as e:
        print(f"Error testing network: {e}")
        return 0

def test_single_image(network, activation, test_images, test_labels, index=0):
    try:
        print("\nTesting single image from test set...")
        print(f"    Image Index: {index}")
        print(f"    Image shape: {str(test_images[index].shape)}")
        print(f"    Label: {str(test_labels[index])}")
        print()

        np.set_printoptions(linewidth=np.inf)
        print("    Image array: \n" + str(test_images[index]) + "\n")

        start_time = time.perf_counter()
        start_cpu = time.process_time()

        network.forward_pass(activation, test_images[index].flatten() / 255.0)
        predicted = np.array([neuron.value for neuron in network.output_layer])
        predicted_label = np.argmax(predicted)

        end_time = time.perf_counter()
        end_cpu = time.process_time()

        print("Test completed.")
        print(f"Predicted label: {predicted_label}")
        print(f"Output values: {predicted}\n")
        print(f"Wall-clock time: {end_time - start_time} seconds")
        print(f"CPU time: {end_cpu - start_cpu} seconds\n")

        return 1

    except Exception as e:
        print(f"Error testing single image: {e}")
        return 0

def load_dataset():
    # Load MNIST dataset from .npy files
    try:
        train_images = np.load("MNIST_Dataset/train_images.npy")  # Load training images (shape: (60000, 28, 28))
        train_labels = np.load("MNIST_Dataset/train_labels.npy")  # Load training labels (shape: (60000,))
        test_images = np.load("MNIST_Dataset/test_images.npy")  # Load test images (shape: (10000, 28, 28))
        test_labels = np.load("MNIST_Dataset/test_labels.npy")  # Load test labels (shape: (10000,))
        
        return ((train_images, train_labels), (test_images, test_labels))
    
    except Exception as e:
        print(f"Error loading MNIST dataset: {e}")
        return 0

def visualize_network(network):
    try:
        dot_code = ANN.print_network_dot(network)
        return dot_code
    
    except Exception as e:
        print(f"Error visualizing network: {e}")
        return 0

def list_network(network):
    try:
        adjacency_list = ANN.print_network_list(network)
        return adjacency_list
    
    except Exception as e:
        print(f"Error listing network: {e}")
        return 0

class Logger(object):
    # Example usage:
    # sys.stdout = Logger("yourlogfilename.txt")
    # sys.stderr = sys.stdout # Optionally redirect stderr as well
    def __init__(self, filename="Default.log"):
        self.terminal = sys.stdout
        self.log = open(filename, "a")

    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)
        self.flush()

    def flush(self):
        self.terminal.flush()
        self.log.flush()