#!/bin/bash

# Usage: bash ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/ann_manager.sh [create|train|test] [model_name]
#
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

source "$(dirname "$0")/../../../venv/bin/activate"

# ======= Config ========
# NOTE: Change these paths to your Python and Clingo executables which include necessary packages
PYTHON="python3"
CLINGO="clingo"

# Parameters for creating the model
input_size=784  # Number of input neurons (e.g., for MNIST)
hidden_layer_sizes=(128 64)  # Sizes of hidden layers
output_size=10  # Number of output neurons (e.g., for MNIST)

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
  $CLINGO $create_network "-c i=$input_size h=${hidden_layer_sizes[*]} o=$output_size" --out-atomf="%s." > model.lp
  $PYTHON $save_network model.lp model_state.json
  model_file="model_state.json"
elif [ "$1" = "train" ]; then
  echo "Loading existing ANN model for training..."
  model_file="$2"
  if [ -z "$model_file" ]; then
    echo "Error: Please provide the model file to load for training."
    exit 1
  fi
  if [ ! -f "$model_file" ]; then
    echo "Error: Model file '$model_file' not found."
    exit 1
  fi
else
  echo "Error: Invalid argument. Use 'create' to create a new model or 'train' to train an existing model."
  exit 1
fi