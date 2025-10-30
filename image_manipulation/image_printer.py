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


# Print original image from .npy file
original_image = np.load("new_datasets/MNIST_image.npy")
original_label = np.load("new_datasets/MNIST_image_label.npy")

# Display original image
#plot_image(original_image, original_label)

# Print manipulated image from .npy file
manipulated_image = np.load("new_datasets/MNIST_image_new.npy")
manipulated_label = np.load("new_datasets/MNIST_image_label_new.npy", allow_pickle=True).item()

# Display manipulated image
# plot_image(manipulated_image, manipulated_label)

# Display both images side by side
plot_multiple_images([original_image, manipulated_image], [original_label, str(manipulated_label) + " - modified"], rows=1, cols=2)