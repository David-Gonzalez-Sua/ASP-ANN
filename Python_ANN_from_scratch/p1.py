# ---------------------------------------- Imports ----------------------------------------
import numpy as np


# ---------------------------------------- Inputs, Weights, Biases ----------------------------------------


# All values come from the book and youtube tutorial

## Modeling one neuron: 1 output
## Modeling the output layer with 3 neurons gives three outputs

# Unique input data
inputs = [1, 2, 3, 2.5]

# Unique weights
weights1 = [0.2, 0.8, -0.5, 1.0]
weights2 = [0.5, -0.91, 0.26, -0.5]
weights3 = [-0.26, -0.27, 0.17, 0.87]

# weights = [[0.2, 0.8, -0.5, 1.0],
#            [0.5, -0.91, 0.26, -0.5],
#            [-0.26, -0.27, 0.17, 0.87]]

# Neuron Unique Bias
bias1 = 2
bias2 = 3
bias3 = 0.5

#biases = [2, 3, 0.5]


# ---------------------------------------- Calculations ----------------------------------------


# Manual output of neuron
# note: having the bias added at the start seemed to introduce some error in the calculation
output = [inputs[0] * weights1[0] + inputs[1] * weights1[1] + inputs[2] * weights1[2] + inputs[3] * weights1[3] + bias1,
          inputs[0] * weights2[0] + inputs[1] * weights2[1] + inputs[2] * weights2[2] + inputs[3] * weights2[3] + bias2,
          inputs[0] * weights3[0] + inputs[1] * weights3[1] + inputs[2] * weights3[2] + inputs[3] * weights3[3] + bias3]
print(output)


# Neuron output using loops
# layer_outputs = [] # Output of current layer
# for neuron_weights, neuron_bias in zip(weights, biases):
#     neuron_output = 0 # Output of current neuron
#     for n_input, weight in zip(inputs, neuron_weights):
#         neuron_output += n_input * weight
#     neuron_output += neuron_bias
#     layer_outputs.append(neuron_output)

# print(layer_outputs)


# Neuron output using numpy
