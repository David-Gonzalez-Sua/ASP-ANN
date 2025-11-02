#!/bin/bash
# 
# Script managing the workflow to manipulate images from MNIST dataset using Clingo
# This version uses non-unique image names for space efficiency
#
# Usage: bash ./image_manipulation/image_manipulator_testing.sh <Manipulation Type> <Image Index>
#   where <Manipulation Type> is the name of the manipulation ('invert_color', 'flip_horiz', 'flip_vert', 'transpose', 'all')
#               'all' will run all manipulations sequentially
#         <Image Index> is the index of the image in the MNIST dataset (optional
#
# Examples::
# All Manipulations: bash ./image_manipulation/image_manipulator_testing.sh all
# Inverting Colors: bash ./image_manipulation/image_manipulator_testing.sh invert_color
#


# NOTE: Change this to your Python path which includes necessary packages
PYTHON="/mnt/c/Users/dgjsu/anaconda3/envs/potcassco/python.exe"

manip="$1" # Manipulator name
image_index="$2" # Image index (optional)

# If no argument is provided, show usage and exit
if [ -z "$manip" ]; then
  echo "Usage: $0 <manipulator_name>"
  echo "Example: $0 invert_color"
  exit 1
fi

if [ -z "$image_index" ]; then
  echo "No index provided. Using default image index 0."
  image_index="0" # Default to first image if not provided
fi


# Workflow
# 1. Start workflow (THROUGH BASH)
# 2. Take image from MNIST_dataset (np_clingo_converter.py)
# 3. Convert image from numpy to clingo facts (np_clingo_converter.py)
# 4. Use clingo to manipulate image (THROUGH BASH)
# 5. Convert clingo output to facts (THROUGH BASH)
# 6. Convert clingo facts back to numpy (clingo_np_converter.py)
# 7. Display original and manipulated images (image_printer.py)


create_image() {
    # Function to create manipulated image
    echo "Creating ${manip} image for index ${image_index}..."

    # Construct filenames automatically
    original_image_name="MNIST_image"
    new_image_name="MNIST_image_${manip}"

    np_clingo_converter="./image_manipulation/np_clingo_converter.py"
    original_clingo_file="./new_datasets/${original_image_name}.lp"

    manip_program="./image_manipulation/clingo_${manip}.lp"
    interpreter="./image_manipulation/Clingo_Image_Interpreter.py"

    clingo_np_converter="./image_manipulation/clingo_np_converter.py"
    image_printer="./image_manipulation/image_printer.py"

    # Run the commands
    #conda activate potcassco
    $PYTHON "$np_clingo_converter" "-n" "${image_index}" "-o" "${original_image_name}" "-d" "new_datasets"
    clingo "$manip_program" "$original_clingo_file" | python3 "$interpreter" "-o" "${new_image_name}" "-d" "new_datasets"
    $PYTHON "$clingo_np_converter" "-f" "${new_image_name}" "-i" "new_datasets" "-o" "${new_image_name}" "-d" "new_datasets"
}


if [ "$manip" == "all" ]; then
    # Run all manipulations sequentially
    for m in invert_color flip_horiz flip_vert transpose; do
        manip="$m"
        create_image
    done

    $PYTHON "$image_printer" "-n" "${image_index}" "-i" "new_datasets" "-a" "True"

else
    create_image
    $PYTHON "$image_printer" "-n" "${image_index}" "-f" "${new_image_name}" "-i" "new_datasets"

fi

echo "✅ Created: .np graphs using $manip manipulation for image index ${image_index}."
