#!/bin/bash
# Usage: bash ./image_manipulation/image_manipulator.sh <Manipulation Type>
#
# Inverting Colors: bash ./image_manipulation/image_manipulator.sh color_invert
#


PYTHON="/mnt/c/Users/dgjsu/anaconda3/envs/potcassco/python.exe"

manip="$1"  # this is the argument you pass

# If no argument is provided, show usage and exit
if [ -z "$manip" ]; then
  echo "Usage: $0 <manipulator_name>"
  echo "Example: $0 color_invert"
  exit 1
fi

# Workflow
# 1. Start workflow (THROUGH BASH)
# 2. Take image from MNIST_dataset (np_clingo_converter.py)
# 3. Convert image from numpy to clingo facts (np_clingo_converter.py)
# 4. Use clingo to manipulate image (THROUGH BASH with OTHER .lp)
# 5. Convert clingo output to facts (THROUGH BASH with OTHER .py)
# 6. Convert clingo facts back to numpy (clingo_np_converter.py)
# 7. Display original and manipulated images (image_printer.py)

# Use the manipulator name to construct filenames automatically
program="./image_manipulation/clingo_${manip}.lp"
clingo_input="./new_datasets/MNIST_image.lp"
output="./new_datasets/MNIST_image_${manip}.lp"
interpreter="./image_manipulation/Clingo_Image_Interpreter.py"
np_clingo_converter="./image_manipulation/np_clingo_converter.py"
clingo_np_converter="./image_manipulation/clingo_np_converter.py"
image_printer="./image_manipulation/image_printer.py"

# Run the commands
#conda activate potcassco
$PYTHON "$np_clingo_converter"
clingo "$program" "$clingo_input" | python3 "$interpreter" > "$output"
$PYTHON "$clingo_np_converter"
$PYTHON "$image_printer"

echo "✅ Created: $output using $program"
