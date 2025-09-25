import numpy as np
from matplotlib import pyplot

def clingo_facts_to_array(facts, predicate_name, shape, start_index=0):
    """
    Convert a list of clingo facts to a numpy array.

    Parameters:
    facts (List[str]): The input list of clingo facts.
    predicate_name (str): The name of the predicate in the clingo facts.
    shape (Tuple[int]): The desired shape of the output numpy array.
    start_index (int): The starting index used in the facts (default is 0).

    Returns:
    np.ndarray: The resulting numpy array.
    """
    np_array = np.zeros(shape, np.uint8)
    for fact in facts:
        if fact.startswith(predicate_name):
            # Extract the arguments from the fact
            args = fact[len(predicate_name) + 1:-2].split(', ')
            *coords, value, label = args
            coords = tuple(int(c) - start_index for c in coords)
            np_array[coords] = np.uint8(value)
    return (np_array, label)


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
clingo_facts = open("new_datasets/MNIST_image.lp", 'r')

np_array = clingo_facts_to_array(clingo_facts.readlines(), "pixel", (28, 28), start_index=1)

print("Image shape: " + str(np_array[0].shape))
print("Label: " + str(np_array[1]))
np.set_printoptions(linewidth=np.inf)
print("Image array: \n" + str(np_array[0]))

#plot_image(np_array[0], np_array[1])

# .npy file output
np.save("new_datasets/MNIST_image.npy", np_array[0])
