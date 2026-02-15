# ANN.py
# This file defines the ANN class, which represents an artificial neural network.

import numpy as np

from neuron import Neuron

class ANN:
    def __init__(self):
        self.input_layer = []
        self.hidden_layers = []  # List of hidden layers, where each hidden layer is a list of neurons
        self.output_layer = []
        self.edges = {}  # Key is a neuron and value is a list of neurons that it has directed edges to
        self.weights = {}  # Key is a tuple of (source_neuron, target_neuron) and value is the weight of the edge

    def build_network(self, input_size, hidden_size, num_hidden_layers, output_size):
        try:
            self.hidden_layers = [[] for _ in range(num_hidden_layers)]

            # Build output layer
            for i in range(output_size):
                neuron = Neuron(neuron_type='OUTPUT', name=f'output_{i}')
                self.output_layer.append(neuron)
                self.edges[neuron] = []
            
            # Build hidden layer
            for layer_num in range(num_hidden_layers - 1, -1, -1):
                hidden_layer = []
                for i in range(hidden_size):
                    # Create Neuron
                    neuron = Neuron(neuron_type='HIDDEN', name=f'hidden_{layer_num}_{i}')
                    hidden_layer.append(neuron)
                    self.edges[neuron] = []
                    
                    # Create Edges
                    if layer_num == num_hidden_layers - 1:
                        next_layer = self.output_layer
                    else:
                        next_layer = self.hidden_layers[layer_num + 1]

                    for next_neuron in next_layer:
                        self.edges[neuron].append(next_neuron)
                        self.weights[(neuron, next_neuron)] = np.random.uniform(-0.5, 0.5)  # Initialize weights randomly between -0.5 and 0.5

                self.hidden_layers[layer_num] = hidden_layer

            # Build input layer
            for i in range(input_size):
                neuron = Neuron(neuron_type='INPUT', name=f'input_{i}')
                self.input_layer.append(neuron)
                self.edges[neuron] = []
                for next_neuron in self.hidden_layers[0]:
                    self.edges[neuron].append(next_neuron)
                    self.weights[(neuron, next_neuron)] = np.random.uniform(-0.5, 0.5)  # Initialize weights randomly between -0.5 and 0.5
            
            return 1

        except Exception as e:
            print(f'Error in build_network: {e}')
            return 0

    def forward_pass(self, activation, input_data):
        # activation is the activation function tag ('SIGMOID', 'ReLU', 'SOFTMAX', 'ReLU_SOFTMAX')
        # input_data is a list of values corresponding to the data for a single image (flattened 28x28 pixel values for MNIST)
        try:
            ## Set input layer values
            for i, neuron in enumerate(self.input_layer):
                neuron.set_value(input_data[i])

            ## Forward pass through the hidden layers
            for index in range(len(self.hidden_layers)):
                if index == 0:
                    input_layer = self.input_layer
                    layer = self.hidden_layers[0]
                else:
                    input_layer = self.hidden_layers[index - 1]
                    layer = self.hidden_layers[index]

                inputs = [neuron.get_value() for neuron in input_layer]

                # Uses activation tag
                if activation == 'SIGMOID':
                    for i, neuron in enumerate(layer):
                        weights = [self.weights[(input_neuron, neuron)] for input_neuron in input_layer]
                        excitation = neuron.excitation_function(inputs, weights)
                        neuron.activation_function(activation, excitation)
                
                # Uses 'ReLU' tag
                elif activation == 'ReLU' or activation == 'ReLU_SOFTMAX':
                    for i, neuron in enumerate(layer):
                        weights = [self.weights[(input_neuron, neuron)] for input_neuron in input_layer]
                        excitation = neuron.excitation_function(inputs, weights)
                        neuron.activation_function('ReLU', excitation)

                # Uses 'SOFTMAX' tag
                elif activation == 'SOFTMAX':
                    excitation = [0] * len(layer)

                    for i, neuron in enumerate(layer):
                        weights = [self.weights[(input_neuron, neuron)] for input_neuron in input_layer]
                        excitation[i] = neuron.excitation_function(inputs, weights)
                    
                    values = Neuron.softmax(excitation)
                    for i, neuron in enumerate(layer):
                        neuron.activation_function('SOFTMAX', values[i])

                else:
                    raise Exception(f'Activation function {activation} not implemented for hidden layers!')

            ## Forward pass through the output layer
            input_layer = self.hidden_layers[-1]
            inputs = [neuron.get_value() for neuron in input_layer]

            # Uses activation tag
            if activation == 'SIGMOID' or activation == 'ReLU':
                for i, neuron in enumerate(self.output_layer):
                    weights = [self.weights[(input_neuron, neuron)] for input_neuron in input_layer]
                    excitation = neuron.excitation_function(inputs, weights)
                    neuron.activation_function(activation, excitation)
            
            # Uses 'SOFTMAX' tag
            elif activation == 'SOFTMAX' or activation == 'ReLU_SOFTMAX':
                excitation = [0] * len(self.output_layer)

                for i, neuron in enumerate(self.output_layer):
                    weights = [self.weights[(input_neuron, neuron)] for input_neuron in input_layer]
                    excitation[i] = neuron.excitation_function(inputs, weights)
                
                values = Neuron.softmax(excitation)
                for i, neuron in enumerate(self.output_layer):
                    neuron.activation_function('SOFTMAX', values[i])

            else:
                raise Exception(f'Activation function {activation} not implemented for output layer!')
            
            return 1
        
        except Exception as e:
            print(f'Error in forward_pass: {e}')
            return 0
        
    def backward_pass(self, loss, activation, target_output, alpha=0.01):
        # loss is the loss function tag ('MSE', 'CCE')
        #    note: MSE = Mean Squared Error    CCE = Categorical Cross Entropy
        # activation is the activation function tag ('SIGMOID', 'ReLU', 'SOFTMAX', 'ReLU_SOFTMAX')
        # target_output is a list of values corresponding to the correct output for the given input data (one-hot encoded vector for MNIST)
        # alpha is the learning rate for weight updates
        # Backpropagation algorithm: Calculates output error, propagates it back through the network, and updates weights accordingly
        # Outputs the MSE for the output layer with original weights and inputs

        try:
            # List of tuples (neuron, error) for output layer mean squared error
            output_MSE = [] 
            # List of lists of tuples (neuron, error) for hidden layer backpropagation error, where layer_BPE[i] is the list of tuples for hidden layer i and layer_BPE[-1] is the list of tuples for the output layer backpropagation error
            layer_BPE = [[] for _ in range(len(self.hidden_layers) + 1)] 

            # Compute output layer backpropagation error
            for i, neuron in enumerate(self.output_layer):
                neuron_error = (1/2) * ( (neuron.get_value() - target_output[i]) ** 2 )  # Mean Squared Error (MSE)
                output_MSE.append(neuron_error)

                y = neuron.get_value()
                t = target_output[i]
                if loss == 'MSE' and activation == 'SIGMOID':
                    neuron_BPE = (y - t) * Neuron.sigmoid_derivative(y)
                
                elif loss == 'CCE' and (activation == 'SOFTMAX' or activation == 'ReLU_SOFTMAX'):
                    neuron_BPE = y - t
                
                else:
                    raise Exception(f'Loss ({loss}) and activation ({activation}) function combo not implemented for output layer!')
                
                layer_BPE[-1].append((neuron, neuron_BPE))
        
            # Comput hidden layer backpropagation error
            for layer_index in reversed(range(len(self.hidden_layers))):
                for neuron in self.hidden_layers[layer_index]:
                    weighted_error = 0
                    for next in layer_BPE[layer_index + 1]:
                        weighted_error += self.weights[(neuron, next[0])] * next[1]
                    
                    z = neuron.get_value()
                    if activation == 'SIGMOID':
                        neuron_BPE = weighted_error * Neuron.sigmoid_derivative(z)

                    elif activation == 'ReLU' or activation == 'ReLU_SOFTMAX':
                        neuron_BPE = weighted_error * Neuron.relu_derivative(z)

                    else:
                        raise Exception(f'Activation function {activation} not implemented for hidden layers!')
                    
                    layer_BPE[layer_index].append((neuron, neuron_BPE))

            # Update output edge weights and neuron bias based on backpropagation error
            for layer_index in reversed(range(len(layer_BPE))):
                for neuron, error in layer_BPE[layer_index]:
                    neuron.bias = neuron.bias - alpha * error
                    if layer_index == 0:
                        input_layer = self.input_layer
                    else:
                        input_layer = self.hidden_layers[layer_index - 1]

                    for input_neuron in input_layer:
                        self.weights[(input_neuron, neuron)] = self.weights[(input_neuron, neuron)] - alpha * error * input_neuron.get_value()

            return sum(output_MSE) / len(output_MSE)  # Return the average MSE for the output layer for this training example
        
        except Exception as e:
            print(f'Error in backward_pass: {e}')
            return 0

    @staticmethod
    def print_network_dot(network):
        output = ''
        output += """
digraph G {
    rankdir=LR; // makes the graph flow left-to-right
    splines=line;

    node [
        shape=circle,
        fixedsize=true,
        width=0.5,
        fontsize=10
    ];

    edge [
        arrowsize=0.5,
        fontsize=8,
        labeldistance=2,
        labelangle=30
    ];
    
    // Align all inputs from a given layer
"""
        output += '    { rank=same;\n'
        for neuron in network.input_layer:
            output += f'      {neuron.name} [label={neuron.get_value()}] ;\n'
            # output += f'      {neuron.name} [label=''] ;\n'
        output += '    }\n\n'

        output += '    { rank=same;\n'
        for neuron in network.output_layer:
            output += f'      {neuron.name} [label={neuron.get_value():.3f}] ;\n'
            # output += f'      {neuron.name} [label=''] ;\n'
        output += '    }\n\n'

        for layer in network.hidden_layers:
            output += '    { rank=same ;\n'
            for neuron in layer:
                output += f'      {neuron.name} [label={neuron.get_value():.3f}] ;\n'
                # output += f'      {neuron.name} [label=''] ;\n'
            output += '    }\n\n'

        for neuron in network.edges:
            for target in network.edges[neuron]:
                # output += f'    {neuron.name}:e -> {target.name}:w [xlabel={neuron.value}] ;'
                # output += f'    {neuron.name}:e -> {target.name}:w [penwidth={neuron.value}] ;'
                output += f'    {neuron.name}:e -> {target.name}:w ;\n'

        output += "}\n"
        return output

    @staticmethod
    def print_network_list(network):
        # Print adjacency list representation of the network
        output = ''
        for node in network.edges:
            output += f"{node.name} -> {', '.join(map(str, [n.name for n in network.edges[node]]))}\n\n"
        return output
    
    def save_network(self, filename):
        # Save the network's structure and weights to a file
        network_state = {
            'input_layer': [neuron.save() for neuron in self.input_layer],
            'hidden_layers': [[neuron.save() for neuron in layer] for layer in self.hidden_layers],
            'output_layer': [neuron.save() for neuron in self.output_layer],
            'edges': {neuron.name: [target.name for target in targets] for neuron, targets in self.edges.items()},
            'weights': {(source.name, target.name): weight for (source, target), weight in self.weights.items()}
        }
        np.save(filename, network_state)

    def load_network(self, filename):
        # Load the network's structure and weights from a file
        network_state = np.load(filename, allow_pickle=True).item()
        # Reconstruct neurons and layers based on saved state
        # This is a placeholder implementation and may need adjustments based on how to handle neuron references and connections
        self.input_layer = [Neuron(**neuron_data) for neuron_data in network_state['input_layer']]
        self.hidden_layers = [[Neuron(**neuron_data) for neuron_data in layer] for layer in network_state['hidden_layers']]
        self.output_layer = [Neuron(**neuron_data) for neuron_data in network_state['output_layer']]
        # Reconstruct edges and weights based on saved state
        # Mapp neuron names back to neuron objects
        neuron_name_map = {}
        for neuron in self.input_layer:
            neuron_name_map[neuron.name] = neuron
        for layer in self.hidden_layers:
            for neuron in layer:
                neuron_name_map[neuron.name] = neuron
        for neuron in self.output_layer:
            neuron_name_map[neuron.name] = neuron

        self.edges = {}
        for source_name, target_names in network_state['edges'].items():
            source_neuron = neuron_name_map[source_name]
            self.edges[source_neuron] = [neuron_name_map[name] for name in target_names]

        self.weights = {}
        for (source_name, target_name), weight in network_state['weights'].items():
            source_neuron = neuron_name_map[source_name]
            target_neuron = neuron_name_map[target_name]
            self.weights[(source_neuron, target_neuron)] = weight