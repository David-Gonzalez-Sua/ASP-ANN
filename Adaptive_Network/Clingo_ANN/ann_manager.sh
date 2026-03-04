#!/bin/bash
# Manages the ANN process
# Dependencies: Python 3 with necessary packages, Clingo, Graphviz, fuzzy finder (fzf)
# Usage: bash ./Adaptive_Network/Clingo_ANN/ann_manager.sh


# WORKFLOW:
# 1. Create or load an ANN model
# 2. Train the ANN model on the dataset
#   2.1. Push input data into ann_scaled_int.lp or ann_float_str.lp
#   2.2. Run excitation functions and hidden neuron activations (most of the feed forward pass) (basically, a form of batching if we dont make the full forward pass in one file)
#   2.3. Save the network state along with its values into snapshot files
#   2.4. Load the network and run the output neuron activations
#   2.5. Find error and calculate the error gradient (In backprop alg?)
#   2.4. Run backpropagation algorithm and update the wights (biases are implicit)
#   2.5. Loop over steps 2.1 to 2.4 until the model is trained
# 3. Save the trained ANN model for later use
# 4. Test the ANN model on new data
#   4.1. Load the trained ANN model
#   4.2. Push new input data into ann_scaled_int.lp or ann_float_str.lp
#   4.3. Run excitation functions and hidden neuron activations (most of the feed forward pass)
#   4.4. Run output neuron activations and get the output prediction (In Clingo or not?)
#   4.5. Evaluate the output and calculate performance metrics
# 5. Save the log, test results, and performance metrics for analysis

## AI MADE THIS. MAYBE I CAN USE THE PID THING?
# Run the ANN process in the background and save its PID
# python3 ann_process.py &
# ANN_PID=$!
# echo "ANN process started with PID: $ANN_PID"


# ======== Config ========
# # NOTE: Change this to your Python and Clingo paths which include necessary packages
PYTHON="/mnt/c/Users/dgjsu/anaconda3/envs/potcassco/python.exe"
CLINGO="/mnt/c/Users/dgjsu/anaconda3/envs/potcassco/Library/bin/clingo.exe"

load_model=true  # Set to true to load an existing model, false to create a new one

testing_model_hardcoded=false  # Set to true to test the model, false to skip testing
train_model=true  # Set to true to train the model, false to skip training
training_amount=1  # Number of images to train on

# ======== Filenames ========
model_file=""
model_snapshot=""

create_network="./Adaptive_Network/Clingo_ANN/create_network.lp"
save_network="./Adaptive_Network/Clingo_ANN/save_network.py"

ann_scaled_int_forward="./Adaptive_Network/Clingo_ANN/ann_scaled_int_forward.lp"
ann_scaled_int_backprop="./Adaptive_Network/Clingo_ANN/ann_scaled_int_backprop.lp"

training_data_folder="./MNIST_Dataset/Clingo_Facts/train_data/"
testing_data_folder="./MNIST_Dataset/Clingo_Facts/test_data/"

graph_visualizer="./Adaptive_Network/Clingo_ANN/graph_visualizer.py"
visualized_graph="./Adaptive_Network/Clingo_ANN/graphs/network_visualizer.pdf"

# ======== Main Workflow ========
# Step 1: creates or loads ANN model
if [ "$load_model" = true ]; then
  echo "Loading existing ANN model..."
  model_file=$(ls -t ./Adaptive_Network/Clingo_ANN/models/*.lp | fzf)

  if [ -z "$model_file" ]; then
    echo "No model selected."
    exit 1
  fi

else
  echo "Creating new ANN model..."
  "$CLINGO" "$create_network" "-c" "i=784" "h=128" "n=2" "o=10" | "$PYTHON" "$save_network" "-v" "False" "-s" "True" "-p" "4" "-f" "randomized"
  model_file=$(ls -t ./Adaptive_Network/Clingo_ANN/models/*.lp | head -n 1)
fi

echo "Model file: $model_file"

# Step 2: trains the ANN model on the dataset
if [ "$train_model" = true ]; then
  echo "Training ANN model on $training_amount images..."

  for i in $(seq 1 $training_amount); do
    echo "Training on image $i..."

    if [ -n "$model_snapshot" ]; then
      model_file="$model_snapshot"
    fi

    "$CLINGO" "$training_data_folder"train_image_$i.lp "$model_file" "$ann_scaled_int_forward" \
      | "$PYTHON" "$save_network" "-v" "True" "-s" "True" "-p" "4" "-f" "snapshot"
    
    model_snapshot=$(ls -t ./Adaptive_Network/Clingo_ANN/model_snapshots/*.lp | head -n 1)

    # "$CLINGO" "$model_snapshot" "$ann_scaled_int_backprop" \
    #   | tee >( "$PYTHON" "$save_network" "-v" "True" "-s" "True" "-p" "4" "-f" "snapshot") \
    #   | "$PYTHON" "$graph_visualizer" | dot -T pdf -o "$visualized_graph"
    "$CLINGO" "$model_snapshot" "$ann_scaled_int_backprop" \
      | tee >( "$PYTHON" "$save_network" "-v" "True" "-s" "True" "-p" "4" "-f" "snapshot")
    
    echo "Model snapshot: $model_snapshot"
  done
fi

# Testing the ANN model on hardcoded data
if [ "$testing_model_hardcoded" = true ]; then
  echo "Testing ANN model..."

  "$CLINGO" "$model_file" "$ann_scaled_int_forward" \
    | "$PYTHON" "$save_network" "-v" "True" "-s" "True" "-p" "4" "-f" "snapshot"

  # "$CLINGO" "$model_file" "$ann_scaled_int_forward" \
  #   | tee >( "$PYTHON" "$save_network" "-v" "True" "-s" "True" "-p" "4" "-f" "snapshot") \
  #   | "$PYTHON" "$graph_visualizer" | dot -T pdf -o "$visualized_graph"

  model_snapshot=$(ls -t ./Adaptive_Network/Clingo_ANN/model_snapshots/*.lp | head -n 1)

  "$CLINGO" "$model_snapshot" "$ann_scaled_int_backprop" \
    | tee >( "$PYTHON" "$save_network" "-v" "True" "-s" "True" "-p" "4" "-f" "snapshot") \
    | "$PYTHON" "$graph_visualizer" | dot -T pdf -o "$visualized_graph"
  
  echo "Model snapshot: $model_snapshot"
fi
