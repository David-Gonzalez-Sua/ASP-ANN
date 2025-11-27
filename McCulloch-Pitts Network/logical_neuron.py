# Single logical neuron implementation in a McCulloch-Pitts network


class LogicalNeuron:
    def __init__(self, threshold=1, neuron_type='NONE', inputs=[], name=''):
        self.neuron_type = neuron_type
        self.threshold = threshold
        self.inputs = inputs
        self.name = name
        
        self.output_edges = []
        self.activated = False

    def activation_function(self):
        try:
            self.activated  = True

            if self.neuron_type == 'AND':
                excitation = self.inputs[0] * self.inputs[1]
                return 1 if excitation >= self.threshold else 0

            elif self.neuron_type == 'OR':
                excitation = self.inputs[0] + self.inputs[1]
                return 1 if excitation >= self.threshold else 0

            elif self.neuron_type == 'XOR':
                excitation = abs(self.inputs[0] - self.inputs[1])
                return 1 if excitation >= self.threshold else 0

            elif self.neuron_type == 'NOT':
                excitation = 1 - self.inputs[0]
                return excitation
            
            elif self.neuron_type == 'INPUT':
                return self.inputs[0]
            
            elif self.neuron_type == 'OUTPUT':
                return self.inputs[0]
            
            elif self.neuron_type == 'NONE':
                print('No operation specified for NONE neuron type.')
                return self.inputs
            
        except Exception as e: 
            print(f'Error in activation_function for {self.neuron_type} neuron: {e}')
            return 0
        
    def append_input(self, new_input):
        self.inputs.append(new_input)

    def set_inputs(self, new_inputs):
        self.inputs = new_inputs

    def get_inputs(self):
        return self.inputs

    def add_output_edge(self, neuron):
        self.output_edges.append(neuron)

    def get_output_edges(self):
        return self.output_edges
    
    def __hash__(self):
        return hash(self.name)

    def __eq__(self, other):
        return self.name == other.name

    def __ne__(self, other):
        # Not strictly necessary, but to avoid having both x==y and x!=y
        # True at the same time
        return not(self == other)