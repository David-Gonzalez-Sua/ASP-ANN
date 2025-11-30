#!/bin/bash
# 
# Script managing the workflow to manipulate images from MNIST dataset using Clingo
#
# Usage: bash ./image_manipulation/image_manipulator.sh <Manipulation Type> <Image Index>
#   where <Manipulation Type> is the name of the manipulation (e.g., color_invert)
#         <Image Index> is the index of the image in the MNIST dataset (optional
#
# Inverting Colors: bash ./image_manipulation/image_manipulator.sh color_invert
#


# NOTE: Change this to your Python path which includes necessary packages
PYTHON="/mnt/c/Users/dgjsu/anaconda3/envs/potcassco/python.exe"

input_a="$1"
input_b="$2"
num_bits="$3"

# If no argument is provided, show usage and exit
if [ -z "$2" ]; then
  echo "No inputs given. Using default inputs: 5 and 35."
fi

# Currently only an 8-bit adder is supported
if [ -z "$3" ]; then
  echo "No bit size provided. Using default bit size 8."
  num_bits="8"
fi

# Filenames
eight_bit_adder="./McCulloch-Pitts_Network/Clingo_MCPN/8bit_adder.lp"
full_adder="./McCulloch-Pitts_Network/Clingo_MCPN/full_adder_network.lp"
neuron_def="./McCulloch-Pitts_Network/Clingo_MCPN/logical_neuron.lp"
num_conv_clingo="./McCulloch-Pitts_Network/Clingo_MCPN/decimal_binary_converter.lp"
num_conv_python="./McCulloch-Pitts_Network/Python_MCPN/decimal_binary_converter.py"
default_input="./McCulloch-Pitts_Network/TestingAndDebugging/temp_binary_number.lp"
graph_visualizer="./McCulloch-Pitts_Network/Clingo_MCPN/graph_visualizer.py"

# Run the commands
# $PYTHON "$np_clingo_converter" "-n" "${image_index}" "-o" "${original_image_name}" "-d" "new_datasets"
# clingo "$manip_program" "$original_clingo_file" | python3 "$interpreter" "-o" "${new_image_name}" "-d" "new_datasets"
# $PYTHON "$clingo_np_converter" "-f" "${new_image_name}" "-i" "new_datasets" "-o" "${new_image_name}" "-d" "new_datasets"
# $PYTHON "$image_printer" "-n" "${image_index}" "-f" "${new_image_name}" "-i" "new_datasets"

# echo "✅ Created: $output using $program"

if [ -z "$2" ]; then
  # Uses default input values
  clingo "$eight_bit_adder" "$full_adder" "$neuron_def" "$default_input"

else
  # Uses Clingo input converter
  # clingo "$eight_bit_adder" "$full_adder" "$neuron_def" "$default_input" "-c input_a=${input_a} -c input_b=${input_b} -c bits=${num_bits}"

  # Uses Python input converter
  $PYTHON "$num_conv_python" "${input_a} ${input_b} ${num_bits}" | clingo "$eight_bit_adder" "$full_adder" "$neuron_def" | tee >($PYTHON "$graph_visualizer") | $PYTHON "$num_conv_python"

fi