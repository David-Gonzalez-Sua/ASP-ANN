#!/bin/bash
# 
# Script managing the workflow to manipulate images from MNIST dataset using Clingo
#
# bash ./McCulloch_Pitts_Network/Clingo_MCPN/run_adder.sh 10 3 4
# Usage: bash ./image_manipulation/image_manipulator.sh <Manipulation Type> <Image Index>
#   where <Manipulation Type> is the name of the manipulation (e.g., color_invert)
#         <Image Index> is the index of the image in the MNIST dataset (optional
#


source "venv/bin/activate" \
  || { echo "Error: could not activate venv. Make sure you have run 'python3 -m venv venv' from the project root."; 
  exit 1; }
echo "Successfully activated Python virtual environment."

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
eight_bit_adder="./McCulloch_Pitts_Network/Clingo_MCPN/8bit_adder.lp"
full_adder="./McCulloch_Pitts_Network/Clingo_MCPN/full_adder_network.lp"
neuron_def="./McCulloch_Pitts_Network/Clingo_MCPN/logical_neuron.lp"
decimal_binary_converter_clingo="./McCulloch_Pitts_Network/Clingo_MCPN/decimal_binary_converter.lp"
decimal_binary_converter_python="./McCulloch_Pitts_Network/Clingo_MCPN/decimal_binary_converter_for_clingo.py"
default_input="./McCulloch_Pitts_Network/TestingAndDebugging/temp_binary_number.lp"
graph_visualizer="./McCulloch_Pitts_Network/Clingo_MCPN/graph_visualizer.py"
graph_code="./McCulloch_Pitts_Network/Clingo_MCPN/network_visualizer.dot"
graph_pdf="./McCulloch_Pitts_Network/Clingo_MCPN/network_visualizer.pdf"
binary_input="./McCulloch_Pitts_Network/Clingo_MCPN/binary_input.lp"
clingo_output="./McCulloch_Pitts_Network/Clingo_MCPN/clingo_output.txt"

if [ -z "$2" ]; then
  # Uses default input values
  clingo "$eight_bit_adder" "$full_adder" "$neuron_def" "$default_input" \
  | tee "$clingo_output" \
  | PYTHON "$decimal_binary_converter_python" "-f 1"
  echo "✅ Created McCulloch-Pitts 8-Bit Adder with default values."

  PYTHON "$graph_visualizer" < "$clingo_output" > "$graph_code"
  dot "$graph_code" "-T" "pdf" "-o" "${graph_pdf}"
  echo "✅ Visualized network created as PDF."

else
  # Uses Clingo input converter
  # clingo "$eight_bit_adder" "$full_adder" "$neuron_def" "$default_input" "-c input_a=${input_a} -c input_b=${input_b} -c bits=${num_bits}"

  # Uses Python input converter
  PYTHON "$decimal_binary_converter_python" "-f 0" "-a ${input_a}" "-b ${input_b}" "-s ${num_bits}" > "$binary_input"
  clingo "$eight_bit_adder" "$full_adder" "$neuron_def" "$binary_input" \
  | tee "$clingo_output" \
  | PYTHON "$decimal_binary_converter_python" "-f 1"

  echo "✅ Created McCulloch-Pitts 8-Bit Adder with inputs ${input_a} and ${input_b}."
  
  PYTHON "$graph_visualizer" < "$clingo_output" > "$graph_code"
  dot "$graph_code" "-T" "pdf" "-o" "${graph_pdf}"
  echo "✅ Visualized network created as PDF."

fi

# echo "✅ Created: $output using $program"