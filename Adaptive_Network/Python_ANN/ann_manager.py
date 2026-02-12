# ANN Manager
# This file manages the overall process of creating, training, and testing the ANN.

import numpy as np
import ann_utils as utils


#### ----------------------------------- CONFIG ---------------------------------------- ####

# Options
load_existing_model = True
existing_model_filename = f"Adaptive_Network/Python_ANN/python_trained_model.npy"

save_trained_model = False
save_trained_model_with_params = False
trained_model_filename = f"Adaptive_Network/Python_ANN/python_trained_model.npy"

print_network_structure = False
print_network_structure_dot = False

manual_testing_routine = True

# Set training parameters
train_model = False
training_amount = 2000  # Number of training samples to use: 0-60000
test_model = False
testing_amount = 2000  # Number of testing samples to use: 0-10000

epochs = 5  # Number of epochs to train for
alpha = 0.01  # learning rate

# Set network parameters
input_size = 784  # 28x28 images flattened
hidden_size = 128  # Number of neurons in each hidden layer (default = 128)
num_hidden_layers = 2
output_size = 10  # Number of output neurons (one for each digit class)


#### ----------------------------------- MAIN ---------------------------------------- ####

# load the dataset
data_train, data_test = utils.load_dataset()
train_images, train_labels = data_train[:training_amount]
test_images, test_labels = data_test[:testing_amount]

# Create/load ANN
if load_existing_model:
    network = utils.load_model(existing_model_filename)
else:
    network = utils.create_network(input_size, hidden_size, num_hidden_layers, output_size)

# Train ANN
if train_model:
    train_images = train_images[:training_amount]
    train_labels = train_labels[:training_amount]
    utils.train_network(network, train_images, train_labels, epochs, alpha)

# Test ANN
if test_model:
    test_images = test_images[:testing_amount]
    test_labels = test_labels[:testing_amount]
    utils.test_network(network, test_images, test_labels)

# Saving the trained model
if save_trained_model:
    utils.network.save_network(f"Adaptive_Network/Python_ANN/python_trained_model.npy")
if save_trained_model_with_params:
    utils.network.save_network(f"Adaptive_Network/Python_ANN/trained_models/ptm_{training_amount}i_{epochs}e_{int(1000*alpha)}a.npy")

# Print network structure
if print_network_structure:
    print(utils.list_network(network))
if print_network_structure_dot:
    # Save the dot code to a file
    dot_code = utils.visualize_network(network)
    with open("Adaptive_Network/Python_ANN/network_structure.dot", "w") as f:
        f.write(dot_code)
    # print(utils.visualize_network(network))

# Manual testing routine
if manual_testing_routine:
    while True:
        index = int(input(f"Enter an index from 0 to 10000 to test a single image (or -1 to exit): "))
        if index == -1:
            break
        utils.test_single_image(network, test_images, test_labels, index)