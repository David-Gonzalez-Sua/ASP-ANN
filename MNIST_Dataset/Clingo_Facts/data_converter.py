# Converts datasets into .lp format.

import numpy as np


def convert_image(image, label, start_index=1):
    """
    Converts a 2D image array into a list of clingo facts in the format:
    neuron(input, 1, Index, GreyValue).
    The label is returned as a separate fact in the format:
    label(Label).
    The Index is calculated as a flat index from the 2D coordinates, starting from start_index.
    """
    flat = image.flatten()
    facts = []
    facts.append(f"label({label}).")
    for i, grey in enumerate(flat):
        # Calculate 2D coordinates from the flat index
        index = i + start_index
        fact = f"neuron(input, 1, {index}, {grey})."
        facts.append(fact)
    return facts


# Load the data
train_images = np.load("MNIST_Dataset/train_images.npy")
train_labels = np.load("MNIST_Dataset/train_labels.npy")
test_images = np.load("MNIST_Dataset/test_images.npy")
test_labels = np.load("MNIST_Dataset/test_labels.npy")

# Convert images to Clingo facts
start = 0
end = train_images.shape[0]  # 60000
for i in range(start, end):
    image_facts = convert_image(train_images[i], train_labels[i], start_index=1)
    # .lp file output
    with open(f"MNIST_Dataset/Clingo_Facts/train_data/train_image_{i}.lp", "w") as f:
        f.write("\n".join(image_facts))
    print(f"Successfully converted training data {i}/{end-1} to Clingo facts.")

start = 0
end = test_images.shape[0]  # 10000
for i in range(start, end):
    image_facts = convert_image(test_images[i], test_labels[i], start_index=1)
    # .lp file output
    with open(f"MNIST_Dataset/Clingo_Facts/test_data/test_image_{i}.lp", "w") as f:
        f.write("\n".join(image_facts))
    print(f"Successfully converted test data {i}/{end-1} to Clingo facts.")
