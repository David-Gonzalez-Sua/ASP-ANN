# Convert MNIST image numpy arrays to clingo facts and save to .lp file
# 
# Use: np_clingo_converter.py -n <index> -o <output_file> -d <output_folder> -n <index>
#   where: 
#       index is the image index in the MNIST dataset
#       output_file is the name of the output .lp file 
#       output_folder is the name of the folder to save in
# 


import argparse
import numpy as np


def array_to_clingo_facts(arr, predicate_name, label, start_index=0):
    """
    Convert a numpy array to a list of clingo facts.

    Parameters:
    arr (np.ndarray): The input numpy array.
    predicate_name (str): The name of the predicate for the clingo facts.
    start_index (int): The starting index for the facts (default is 0).

    Returns:
    List[str]: A list of strings representing clingo facts.
    """
    facts = []
    iter = np.nditer(arr, flags=['multi_index'])
    for grey in iter:
        index = iter.multi_index
        # Adjust index based on start_index
        coordinates = tuple(i + start_index for i in index)
        fact = f"{predicate_name}({', '.join(map(str, coordinates))}, {grey}, {label})."
        facts.append(fact)
    return facts


parser = argparse.ArgumentParser()

parser.add_argument('-n', default = 0, type = int,
                    help = "Index of the image in the dataset to convert. (Default = 0)")

parser.add_argument('-o', default = "MNIST_image", type = str,
                    help = "Output .lp file name. (Default = 'MNIST_image')")

parser.add_argument('-d', default = "new_datasets", type = str,
                    help = "Folder to save the output files in. (Default = 'new_datasets')")

args = parser.parse_args()

image_index = args.n
output_file = args.o
output_folder = args.d

# Load the data
train_images = np.load("MNIST_Dataset/train_images.npy")
train_labels = np.load("MNIST_Dataset/train_labels.npy")

# NOTE: If needed, uncomment the following lines to save the numpy arrays, but not required for conversion. Could be useful for testing
# Save image index to .npy file for reference
# np.save(folder + "/" + file_name + "_" + image_index + ".npy", train_images[image_index])
# np.save(folder + "/" + file_name + "_label_" + image_index + ".npy", train_labels[image_index])

# Convert image to clingo facts
image_facts = array_to_clingo_facts(train_images[image_index], "pixel", train_labels[image_index], start_index=1)

# .lp file output
with open(output_folder + "/" + output_file + ".lp", "w") as f:
    f.write("\n".join(image_facts))
