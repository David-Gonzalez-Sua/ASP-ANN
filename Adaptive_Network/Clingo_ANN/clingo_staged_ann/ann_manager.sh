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

# Parameters for creating a model
input_size=784  # Number of input neurons (e.g., for MNIST)
hidden_layer_sizes=(128 64)  # Sizes of hidden layers
output_size=10  # Number of output neurons (e.g., for MNIST)
randomize_weights=true  # Whether to initialize weights with random values (if false, weights will be initialized to 0.5)
scaled_integers=true  # Whether to scale weights and excitations to integers (for Clingo compatibility)
precision=4  # Number of decimal places to round to (if scaled_integers is true)

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
visualized_graph="${folder}graphs/network_visualizer.png"

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
        model_filename=$(python3 $create_network --input_size $input_size --hidden_sizes "${hidden_layer_sizes[@]}" --output_size $output_size --randomize_weights --scaled_integers --precision $precision --identifier "staged" --folder "${folder}models/")
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create ANN model. Please check the output above for details."
            exit 1
        fi
    else
        echo "Error: Only random weight initialization with scaled integers is currently supported. Please set randomize_weights=true and scaled_integers=true in the config section of the script."
        exit 1
        # model_filename=$(python3 $create_network --input_size $input_size --hidden_sizes "${hidden_layer_sizes[@]}" --output_size $output_size --identifier "staged" --folder "${folder}models/")
    fi
    echo "Model created and saved to: $model_filename"

# Train the ANN model on the dataset
elif [ "$do_train" = true ]; then
    # Load model into working memory
    echo "Select a model to train."
    select_model
    cp "$model_filename" "${folder}working_memory.lp"

    

    echo "Training ANN model..."
    echo "Training functionality not implemented yet."

elif [ "$do_test" = true ]; then
    echo "Testing ANN model..."
    echo "Testing functionality not implemented yet."

else
    echo "Usage: bash $0 [create train test]"
    exit 1
fi