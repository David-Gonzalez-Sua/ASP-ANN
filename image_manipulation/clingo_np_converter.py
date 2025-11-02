# Convert Clingo facts to MNIST image numpy arrays and save to .npy file
# 
# Use: clingo_np_converter.py -f <input_file> -i <input_folder> -o <output_file> -d <output_folder>
#   where: 
#       input_file is the name of the input .lp file
#       input_folder is the folder to get the input files from
#       output_file is the name of the output .npy file
#       output_folder is the folder to save the output files in
# 


import argparse
import numpy as np


def clingo_facts_to_array(facts, predicate_name, shape, start_index=0):
    """
    Convert a list of clingo facts to a numpy array.

    Parameters:
    facts (List[str]): The input list of clingo facts.
    predicate_name (str): The name of the predicate in the clingo facts.
    shape (Tuple[int]): The desired shape of the output numpy array.
    start_index (int): The starting index used in the facts (default is 0).

    Returns:
    Tuple[np.ndarray, int]: A tuple containing the numpy array and the label.
    """
    label = None
    np_array = np.zeros(shape, np.uint8)
    for fact in facts:
        if fact.startswith(predicate_name):
            # Extract the arguments from the predicate
            args = fact[len(predicate_name) + 1:-2].split(', ')
            row, col, color, label = args
            row, col = int(row) - start_index, int(col) - start_index
            np_array[row, col] = np.uint8(color)
        label = np.uint8(label)
    return (np_array, label)


parser = argparse.ArgumentParser()

parser.add_argument('-f', default = "MNIST_image", type = str,
                    help = "Input .lp file name. (Default = 'MNIST_image')")

parser.add_argument('-i', default = "new_datasets", type = str,
                    help = "Folder to get the input files from. (Default = 'new_datasets')")

parser.add_argument('-o', default = "MNIST_image_new", type = str,
                    help = "Output .npy file name. (Default = 'MNIST_image_new')")

parser.add_argument('-d', default = "new_datasets", type = str,
                    help = "Folder to save the output files in. (Default = 'new_datasets')")

args = parser.parse_args()

input_file = args.f
input_folder = args.i
output_file = args.o
output_folder = args.d

# Load the data
# NOTE: If issues show up, use (, encoding='utf-16') in the open() function
clingo_facts = open(input_folder + "/" + input_file + ".lp", 'r')

facts = clingo_facts.readlines()
facts = [line.strip() for line in facts]

np_array = clingo_facts_to_array(facts, "pixel", (28, 28), start_index=1)

# .npy file output
np.save(output_folder + "/" + output_file + ".npy", np_array[0])
np.save(output_folder + "/" + output_file + "_label.npy", np_array[1])

# NOTE: Still need to implement saving multiple images to a single .npy file