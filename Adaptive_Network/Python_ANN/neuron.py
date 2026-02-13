# Simple implementation of a neuron class that can be used to create a nerual network.

import math

class Neuron:
    def __init__(self, threshold=1, neuron_type='NONE', value=0, bias=0, name=''):
        self.neuron_type = neuron_type
        # self.threshold = threshold  # necessary? idk
        self.value = value
        self.bias = bias
        self.name = name        
        
        # self.activated = False  # Is this necessary anymore? Maybe for debugging purposes to see if a neuron has been activated or not. Could also be used to implement a learning algorithm where only activated neurons have their weights updated.

    def excitation_function(self, inputs, weights):  # Use circuit model to create a function that will learn the correct weights to perform digit classification on the MNIST dataset        
        # inputs is a list of input values [x1, x2, x3, ...]
        # weights is a list of a list of weights corresponding to the input values, where weights[i] are the weights for input i
        try:
            # self.activated  = True

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
        
    def activation_function(self, activation, excitation):
        # activation is the activation function ('SIGMOID', 'ReLU', 'SOFTMAX')
        try:
            if activation == 'SIGMOID':
                self.value = self.sigmoid(excitation)

            elif activation == 'ReLU':
                self.value = self.relu(excitation)

            elif activation == 'SOFTMAX':
                self.value = excitation
        
            return self.value
        
        except Exception as e: 
            print(f'Error in activation_function for {self.neuron_type} neuron: {e}')
            return 0
    
    @staticmethod
    def sigmoid(x):
        return 1 / (1 + math.exp(-x))
    
    @staticmethod
    def sigmoid_derivative(z):
        return z * (1 - z)
    
    @staticmethod
    def relu(x):
        return max(0, x)
    
    @staticmethod
    def relu_derivative(z):
        return 1 if z > 0 else 0
    
    @staticmethod
    def softmax(z):
        # Takes in a vector, returns a vector
        m = max(z)
        exps = [math.exp(zi - m) for zi in z]
        s = sum(exps)
        y = [yi / s for yi in exps]
        return y
    
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