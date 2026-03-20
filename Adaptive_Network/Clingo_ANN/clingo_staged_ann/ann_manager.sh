#!/bin/env bash

# Usage: bash ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/ann_manager.sh [create|train|test] [model_name]
# This script should be ran from the project root directory.
# This script orchestrates the workflow for creating, training, and testing an ANN model using Clingo and Python.
# It performs the following steps:
# 1. Creates or loads an ANN model
#   1.1 Create network structure and initialize weights (if creating new model)
#   1.2 Load existing model state (if loading model)
# 2. Trains the ANN model on the dataset
#   2.1 Forward pass
#   2.2 Backpropagation and weight updates
# 3. Tests the ANN model on new data
#   3.1 Forward pass to get predictions
#   3.2 Evaluate performance metrics
# 4. Visualizes the ANN structure and saves the graph
# 5. Saves the trained ANN model for later use

# bash ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/ann_manager.sh create

source "venv/bin/activate" \
  || { echo "Error: could not activate venv. Make sure you have run 'python3 -m venv venv' from the project root."; 
  exit 1; }
echo "Successfully activated Python virtual environment."

# ======= Config ========

# Parameters for creating the model
input_size=784  # Number of input neurons (e.g., for MNIST)
hidden_layer_sizes=(128 64)  # Sizes of hidden layers
output_size=10  # Number of output neurons (e.g., for MNIST)
randomize_weights=true  # Whether to initialize weights with random values (if false, weights will be initialized to 0.5)
scaled_integers=true  # Whether to scale weights and excitations to integers (for Clingo compatibility)
precision=4  # Number of decimal places to round to (if scaled_integers is true)

# ===== Filenames ========
folder="./Adaptive_Network/Clingo_ANN/clingo_staged_ann/"

create_network="${folder}create_network.lp"
save_network="${folder}save_network.py"

forward_pass="${folder}forward_pass.lp"
backprop_pass="${folder}backprop_pass.lp"

training_data_folder="./MNIST_Dataset/Clingo_Facts/train_data/"
testing_data_folder="./MNIST_Dataset/Clingo_Facts/test_data/"

network_visualizer="${folder}network_visualizer.py"
visualized_graph="${folder}graphs/network_visualizer.png"

# ===== Main Workflow =====
# Step 1: Create or load ANN model
if [ "$1" = "create" ]; then
    echo "Creating new ANN model..."
    model_filename=$(python3 $create_network --input_size $input_size --hidden_sizes "${hidden_layer_sizes[@]}" --output_size $output_size --randomize_weights $randomize_weights --scaled_integers $scaled_integers --precision $precision --identifier "staged" --folder "$folder")
    echo "Model created and saved to: $model_filename"
elif [ "$1" = "train" ]; then
    echo "Training ANN model..."
    echo "Training functionality not implemented yet."
elif [ "$1" = "test" ]; then
    echo "Testing ANN model..."
    echo "Testing functionality not implemented yet."
else
    echo "Usage: bash $0 [create|train|test]"
    exit 1
fi