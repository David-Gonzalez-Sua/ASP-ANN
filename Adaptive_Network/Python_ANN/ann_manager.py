# ANN Manager
# This file manages the overall process of creating, training, and testing the ANN.
# Use the following to visualize the network
# dot -T pdf '.\Adaptive_Network\Python_ANN\graphs\simple_network_structure.dot' -o '.\Adaptive_Network\Python_ANN\graphs\network_visualizer.pdf'

import sys
import time

import ann_utils as utils


#### ----------------------------------- CONFIG ---------------------------------------- ####

# Options
load_existing_model = True  # Creates new network if False
existing_model_filename = "ptm_default.npy"  # Default
# existing_model_filename = "ptm_mnist_MSE_SIGMOID_2000t_15e_10a.npy"
# existing_model_filename = "ptm_mnist_CCE_ReLU_SOFTMAX_6000t_20e_10a.npy"
# existing_model_filename = "ptm_mnist_CCE_ReLU_SOFTMAX_6000t_25e_1a.npy"
# existing_model_filename = "ptm_mnist_CCE_ReLU_SOFTMAX_12000t_20e_1a.npy"


train_model = False
test_model = False

save_trained_model_default = False
save_trained_model_with_params = False  # Both can be true
save_epochs = True  # Saves the model after training each epoch, with filename ptm_epoch{epoch}.npy in training_model_snapshots folder

save_terminal_log_default = False
save_terminal_log_with_params = False  # Only one of these should be true

print_network_structure_list = False
create_network_structure_dot = False

manual_testing_routine = True

# Set training parameters
training_amount = 12000  # Number of training samples to use: 0-60000

epochs = 20  # Number of epochs to train for
alpha = 0.001  # learning rate

# Set testing parameters
testing_amount = 10000  # Number of testing samples to use: 0-10000

# Set network parameters
input_size = 784  # Number of neurons in the input layer (default = 784 from 28x28 flattened image)
num_hidden_layers = 2  # Number of hidden layers (default = 2)
hidden_size = 128  # Number of neurons in each hidden layer (default = 128)
output_size = 10  # Number of output neurons (default = 10 one for each digit class)

# Set loss ('MSE', 'CCE')
#    note: MSE = Mean Squared Error    CCE = Categorical Cross Entropy)
loss = 'CCE'

# Set activation ('SIGMOID', 'ReLU', 'SOFTMAX', 'ReLU_SOFTMAX')
activation = 'ReLU_SOFTMAX'


#### ----------------------------------- MAIN ---------------------------------------- ####
# Begin counting program runtime
print("Beginning ANN Manager program...\n")
start_time = time.perf_counter()
start_cpu = time.process_time()

# Save terminal log
if save_terminal_log_default:
    sys.stdout = utils.Logger("Adaptive_Network/Python_ANN/terminal_logs/default_terminal_log.txt")
if save_terminal_log_with_params:
    sys.stdout = utils.Logger(f"Adaptive_Network/Python_ANN/terminal_logs/log_mnist_{loss}_{activation}_{training_amount}t_{epochs}e_{int(1000*alpha)}a.txt")
sys.stderr = sys.stdout  # Optionally redirect stderr

# Load the dataset
data_train, data_test = utils.load_dataset()
train_images, train_labels = data_train
test_images, test_labels = data_test

# Create/load ANN
if load_existing_model:
    network = utils.load_model(f"Adaptive_Network/Python_ANN/trained_models/{existing_model_filename}")
else:
    network = utils.create_network(input_size, num_hidden_layers, hidden_size, output_size)

# Train ANN
if train_model:
    train_images = train_images[:training_amount]
    train_labels = train_labels[:training_amount]
    utils.train_network(network, loss, activation, train_images, train_labels, epochs, alpha, save_trained_model_default)

# Saving the trained model
if save_trained_model_default:
    network.save_network("Adaptive_Network/Python_ANN/trained_models/ptm_default.npy")
if save_trained_model_with_params:
    network.save_network(f"Adaptive_Network/Python_ANN/trained_models/ptm_mnist_{loss}_{activation}_{training_amount}t_{epochs}e_{int(1000*alpha)}a.npy")

# Test ANN
if test_model:
    test_images = test_images[:testing_amount]
    test_labels = test_labels[:testing_amount]
    utils.test_network(network, activation, test_images, test_labels)

# Print network structure
if print_network_structure_list:
    print(utils.list_network(network))
if create_network_structure_dot:
    # Save the dot code to a file
    dot_code = utils.visualize_network(network)
    with open(f"Adaptive_Network/Python_ANN/graphs/netstruc_{input_size}in_{num_hidden_layers}lay_{hidden_size}hid_{output_size}out.dot", "w") as f:
        f.write(dot_code)
    # print(utils.visualize_network(network))

# Show program runtime
end_time = time.perf_counter()
end_cpu = time.process_time()

print("\nANN Manager program end.")
print("Total elapsed time:")
print(f"Wall-clock time: {end_time - start_time} seconds")
print(f"CPU time: {end_cpu - start_cpu} seconds\n")

# Manual testing routine
if manual_testing_routine:
    print("Beginning manual testing routine...\n")
    while True:
        index = int(input("Enter an index from 0 to 9999 to test a single image (or -1 to exit): "))
        if index == -1:
            break
        utils.test_single_image(network, activation, data_test[0], data_test[1], index)
    print("Manual testing routine end.\n")