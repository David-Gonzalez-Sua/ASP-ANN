import numpy as np
from matplotlib import pyplot


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
    it = np.nditer(arr, flags=['multi_index'])
    for x in it:
        index = it.multi_index
        # Adjust index based on start_index
        coordinates = tuple(i + start_index for i in index)
        fact = f"{predicate_name}({', '.join(map(str, coordinates))}, {x}, {label})."
        facts.append(fact)
    return facts


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


# Load the data
train_images = np.load("MNIST_Dataset/train_images.npy")
train_labels = np.load("MNIST_Dataset/train_labels.npy")
#test_images = np.load("MNIST_Dataset/test_images.npy")
#test_labels = np.load("MNIST_Dataset/test_labels.npy")


image_facts = array_to_clingo_facts(train_images[0], "pixel", train_labels[0], start_index=1)

#print("\n".join(image_facts))
#plot_image(train_images[0], train_labels[0])

# .lp file output
with open("new_datasets/MNIST_image.lp", "w") as f:
    f.write("\n".join(image_facts))