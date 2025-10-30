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


# Load the data
train_images = np.load("MNIST_Dataset/train_images.npy")
train_labels = np.load("MNIST_Dataset/train_labels.npy")

# NOTE: Need to add argument for image index
image_index = 0  # Change this index to test different images

# Save image index to .npy file for reference
np.save("new_datasets/MNIST_image.npy", train_images[image_index])
np.save("new_datasets/MNIST_image_label.npy", train_labels[image_index])

# Convert image to clingo facts
image_facts = array_to_clingo_facts(train_images[image_index], "pixel", train_labels[image_index], start_index=1)

# .lp file output (NOTE: Need to add argument for image name)
with open("new_datasets/MNIST_image.lp", "w") as f:
    f.write("\n".join(image_facts))