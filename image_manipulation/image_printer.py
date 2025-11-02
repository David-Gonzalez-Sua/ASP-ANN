# Prints 1 or 2 images in .npy format using matplotlib
# 
# Use: image_printer.py -n <image_index> -f <input_file> -i <input_folder>
#   where: 
#       image_index is the original index of the image in the dataset. Prints both images if included. Only prints manipulated image otherwise.
#       input_file is the name of the input .npy file
#       input_folder is the folder to get the input files from
# 


import argparse
import numpy as np
from matplotlib import pyplot


def plot_image(arr, label):
    """
    Plot a 2D numpy array as an image with a title.

    Parameters:
    arr (np.ndarray): The input 2D numpy array.
    label (int): The label to display in the title.
    """
    pyplot.imshow(arr, cmap=pyplot.get_cmap('gray'))
    pyplot.title("Label: " + str(label))
    pyplot.axis('off')
    pyplot.show()


def plot_multiple_images(images, labels, rows=3, cols=3):
    """
    Plot multiple 2D numpy arrays as images in a grid.

    Parameters:
    images (List[np.ndarray]): The list of 2D numpy arrays.
    labels (List[int]): The list of labels corresponding to the images.
    rows (int): Number of rows in the grid.
    cols (int): Number of columns in the grid.
    """
    for i in range(min(len(images), rows * cols)):
        pyplot.subplot(rows, cols, i + 1)
        pyplot.imshow(images[i], cmap=pyplot.get_cmap('gray'))
        pyplot.title("Label: " + str(labels[i]))
        pyplot.axis('off')
    pyplot.show()


parser = argparse.ArgumentParser()

parser.add_argument('-n', default = -1, type = int,
                    help = "Original index of the image in the dataset. Prints both images if included. Only prints manipulated image otherwise. (Default = -1)")

parser.add_argument('-f', default = "MNIST_image_new", type = str,
                    help = "Input .npy file name. (Default = 'MNIST_image_new')")

parser.add_argument('-i', default = "new_datasets", type = str,
                    help = "Folder to get the input files from. (Default = 'new_datasets')")

args = parser.parse_args()

image_index = args.n
input_file = args.f
input_folder = args.i

# Load original image from .npy file
train_images = np.load("MNIST_Dataset/train_images.npy")
train_labels = np.load("MNIST_Dataset/train_labels.npy")

original_image = train_images[image_index]
original_label = train_labels[image_index]

# Display original image
#plot_image(original_image, original_label)

# Print manipulated image from .npy file
manipulated_image = np.load(input_folder + "/" + input_file + ".npy")
manipulated_label = np.load(input_folder + "/" + input_file + "_label.npy", allow_pickle=True).item()

# Display manipulated image
if image_index == -1:
    plot_image(manipulated_image, manipulated_label)

# Display original and manipulated images side by side
else:
    plot_multiple_images([original_image, manipulated_image], [original_label, str(manipulated_label) + " - modified"], rows=1, cols=2)
