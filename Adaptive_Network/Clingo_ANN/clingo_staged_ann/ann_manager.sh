#!/bin/env bash

# Usage: bash ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/ann_manager.sh [create train test]]
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

# ======= Config =======

## Parameters for creating a model
# Number of input neurons (e.g., for MNIST)
input_size=3  # default=784 # (28x28 pixels for MNIST)
# Sizes of hidden layers (e.g., two hidden layers with 128 and 64 neurons)
hidden_layer_sizes=(5 5)  # default=(128 64)
# Number of output neurons (e.g., for MNIST)
output_size=2  # default=10 # (number of classes for MNIST)
# Whether to initialize weights with random values (if false, weights will be initialized to 0.5)
randomize_weights=true  # default=true
# Whether to scale weights and excitations to integers (for Clingo compatibility)
scaled_integers=true  # default=true
# Number of decimal places to round to (if scaled_integers is true)
precision=4  # default=4
# Optional identifier to include in the model filename (e.g., "staged" for staged ANN)
identifier=""  # default="" # (leave empty for no identifier)

# ======= Filenames =======
folder="./Adaptive_Network/Clingo_ANN/clingo_staged_ann/"

# create_network="${folder}create_network.lp"
create_network="${folder}create_network.py"
save_network="${folder}save_network.py"

working_memory="${folder}working_memory.lp"
forward_pass="${folder}forward_pass.lp"
backprop_pass="${folder}backprop_pass.lp"

training_data_folder="./MNIST_Dataset/Clingo_Facts/train_data/"
testing_data_folder="./MNIST_Dataset/Clingo_Facts/test_data/"

network_visualizer="${folder}network_visualizer.py"
visualized_graph="${folder}graphs/network.png"

# ======= Functions =======
parse_arguments() {
    do_create=false
    do_train=false
    do_test=false

    for action in "$@"; do
        case $action in
            create) do_create=true ;;
            train) do_train=true ;;
            test) do_test=true ;;
            *)
                echo "Invalid argument: $action. Usage: bash $0 [create train test]"
                exit 1
                ;;
        esac
    done
}

select_model() {
    echo "Available models:"

    # Select from available models in the models folder
    #options=("${folder}models/"*.lp)

    # Sort models by creation date (newest first)
    mapfile -t options < <(ls -t "${folder}models/"*.lp)
    
    # Check if there are any models available
    if [ ${#options[@]} -eq 0 ]; then
        echo "No models found in ${folder}models/. Please create a model first."
        exit 1
    fi

    # Select model from choices
    select choice in "${options[@]}"; do
        if [ -n "$choice" ]; then
            model_filename="$choice"
            echo "Selected model: $model_filename"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
}

# ======= Main Workflow =======
# Parse arguments
parse_arguments "$@"

# Create ANN model
if [ "$do_create" = true ]; then
    echo "Creating new ANN model..."
    if [ $scaled_integers = true ] && [ $randomize_weights = true ]; then
        echo "Creating ANN model with random weights and scaled integers..."
        model_filename=$(python3 $create_network --input_size $input_size --hidden_sizes "${hidden_layer_sizes[@]}" --output_size $output_size --randomize_weights --scaled_integers --precision $precision --identifier "$identifier" --folder "${folder}models/")
    elif [ $scaled_integers = true ] && [ $randomize_weights = false ]; then
        echo "Creating ANN model with 0.5 weights and scaled integers..."
        model_filename=$(python3 $create_network --input_size $input_size --hidden_sizes "${hidden_layer_sizes[@]}" --output_size $output_size --scaled_integers --precision $precision --identifier "$identifier" --folder "${folder}models/")
    fi

    if [ $? -ne 0 ]; then
        echo "Error: Failed to create ANN model."
        exit 1
    fi
    echo "Model created and saved to: $model_filename"

# Train the ANN model on the dataset
elif [ "$do_train" = true ]; then
    # Load model into working memory
    echo "Select a model to train."
    select_model
    cp "$model_filename" "${working_memory}"
    echo "Model loaded into working memory: ${working_memory}"

    echo "Training ANN model..."

    # Determine the number of layers in the model by counting the numbers in the model filename
    num_layers=$(python3 -c "
import re
m = re.search(r'(\d+.+(_\d+.*)*out)', '$model_filename')
print(len(m.group(1).split('_')))
")
    echo "Number of layers in the model: $num_layers"

    echo "Forward pass over a single layer with dummy data..."
    for layer in $(seq 0 $((num_layers-2))); do
        echo "Processing layer $layer -> $((layer+1))..."
        clingo "--models=1" $working_memory $forward_pass "-c layer=$layer" "${folder}dummy_data.lp" \
          | python3 $save_network "--scaled_integers" --precision $precision --filepath "$working_memory"
        echo "Layer $layer -> $((layer+1)) processed. Updated model state saved to: ${working_memory}"
    done

    echo "Forward pass complete."

elif [ "$do_test" = true ]; then
    echo "Testing ANN model..."
    echo "Testing functionality not implemented yet."

else
    echo "Usage: bash $0 [create train test]"
    exit 1
fi