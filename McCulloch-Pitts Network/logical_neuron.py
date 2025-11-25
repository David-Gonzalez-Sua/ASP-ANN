# Single logical neuron implementation in a McCulloch-Pitts network


class LogicalNeuron:
    def __init__(self, threshold=1, neuron_type='AND'):
        self.neuron_type = neuron_type
        self.threshold = threshold

    def activation_function(self, input_tuple):
        if self.neuron_type == 'AND':
            excitation = input_tuple[0] * input_tuple[1]
            return 1 if excitation >= self.threshold else 0

        elif self.neuron_type == 'OR':
            excitation = input_tuple[0] + input_tuple[1]
            return 1 if excitation >= self.threshold else 0

        elif self.neuron_type == 'XOR':
            excitation = abs(input_tuple[0] - input_tuple[1])
            return 1 if excitation >= self.threshold else 0
