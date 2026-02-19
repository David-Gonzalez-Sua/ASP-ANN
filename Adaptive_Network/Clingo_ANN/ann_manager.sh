#!/bin/bash
# Manages the ANN process
# Dependencies: Python 3 with necessary packages, Clingo, Graphviz, fuzzy finder (fzf)
# Usage: bash ./Adaptive_Network/Clingo_ANN/ann_manager.sh


# WORKFLOW:
# 1. Create or load an ANN model
# 2. Train the ANN model on the dataset
#   2.1. Push input data into ann_scaled_int.lp or ann_float_str.lp
#   2.2. Run excitation functions and hidden neuron activations (most of the feed forward pass)
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


# Config
load_model=true # Set to true to load an existing model, false to create a new one

# Filenames
create_network="./Adaptive_Network/Clingo_ANN/create_network.lp"
save_network="./Adaptive_Network/Clingo_ANN/save_network.py"

# Creates or loads ANN model
if [ "$load_model" = true ]; then
  echo "Loading existing ANN model..."
  model_file=$(ls -t ./Adaptive_Network/Clingo_ANN/models/*.lp | fzf)

  if [ -z "$model_file" ]; then
    echo "No model selected."
    exit 1
  fi
else
  echo "Creating new ANN model..."
  clingo "$create_network" "-c" "i=784" "h=128" "n=2" "o=10" | python "$save_network" "-v False" "-s True" "-p 4" "-f 'randomized'"
fi

echo "Model file: $model_file"