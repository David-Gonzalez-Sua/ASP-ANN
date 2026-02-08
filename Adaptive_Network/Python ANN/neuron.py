# Simple implementation of a neuron class that can be used to create a nerual network.

import numpy as np

class Neuron:
    def __init__(self, threshold=1, neuron_type='NONE', value=0, bias=0, name=''):
        self.neuron_type = neuron_type
        # self.threshold = threshold  # necessary? idk
        self.value = value
        self.bias = bias
        self.name = name        
        
        self.activated = False  # Is this necessary anymore? Maybe for debugging purposes to see if a neuron has been activated or not. Could also be used to implement a learning algorithm where only activated neurons have their weights updated.

    def excitation_function_input(self, input):  # Use circuit model to create a function that will learn the correct weights to perform digit classification on the MNIST dataset        
        # input is a single value 
        try:
            self.activated  = True
            
            if self.neuron_type == 'INPUT':
                return input
            
            else:
                print('No operation specified for non-INPUT neuron type in excitation_function.')
                return 0

        except Exception as e: 
            print(f'Error in excitation_function for {self.neuron_type} neuron: {e}')
            return 0

    def excitation_function(self, inputs, weights):  # Use circuit model to create a function that will learn the correct weights to perform digit classification on the MNIST dataset        
        # inputs is a list of input values [x1, x2, x3, ...]
        # weights is a list of a list of weights corresponding to the input values, where weights[i] are the weights for input i
        try:
            self.activated  = True

            if self.neuron_type == 'HIDDEN' or self.neuron_type == 'OUTPUT':
                excitation = 0
                # Calculate dot product of inputs and weights, then add the bias/threshold function
                for i in range(len(inputs)):
                    excitation += inputs[i]*weights[i]  # w is a list of a single weight, so w[0] is the weight value
                excitation += self.bias
                return excitation

            else:
                print('No operation specified for non-HIDDEN/OUTPUT neuron type in excitation_function.')
                return 0
            
        except Exception as e: 
            print(f'Error in excitation_function for {self.neuron_type} neuron: {e}')
            return 0
        
    def activation_function(self, inputs, weights):
        # inputs is a list of input values [x1, x2, x3, ...]
        # weights is a list of a list of weights corresponding to the input values, where weights[i] are the weights for input i
        # For an input neuron, use an empty list for weights
        if self.neuron_type == 'INPUT':
            excitation = self.excitation_function_input(inputs[0])
        else:
            excitation = self.excitation_function(inputs, weights)
            excitation = self.sigmoid(excitation)
    
        self.value = excitation
        return excitation
    
    @staticmethod
    def sigmoid(x):
        return 1 / (1 + np.exp(-x))
    
    def get_value(self):
        return self.value
    
    def set_value(self, new_value):
        self.value = new_value

    def save(self):
        # return the neuron's state as a dictionary that can be easily saved to a file or database
        return {
            'neuron_type': self.neuron_type,
            'value': self.value,
            'bias': self.bias,
            'name': self.name
        }
    
    def __hash__(self):
        return hash(self.name)

    def __eq__(self, other):
        return self.name == other.name

    def __ne__(self, other):
        # Not strictly necessary, but to avoid having both x==y and x!=y
        # True at the same time
        return not(self == other)