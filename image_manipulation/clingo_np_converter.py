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


# Load the data (NOTE: Need to add argument for image name)
# NOTE: If issues show up, use (, encoding='utf-16') in the open() function
clingo_facts = open("new_datasets/MNIST_image_color_invert.lp", 'r')

facts = clingo_facts.readlines()
facts = [line.strip() for line in facts]

np_array = clingo_facts_to_array(facts, "pixel", (28, 28), start_index=1)

# .npy file output (NOTE: Need to add argument for image name)
np.save("new_datasets/MNIST_image_new.npy", np_array[0])
np.save("new_datasets/MNIST_image_label_new.npy", np_array[1])
