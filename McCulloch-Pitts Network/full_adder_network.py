# Full adder implementation using McCulloch-Pitts neurons
from logical_neuron import LogicalNeuron


class FullAdderNetwork:
    def __init__(self):
        self.and_neuron = LogicalNeuron(neuron_type='AND')
        self.or_neuron = LogicalNeuron(neuron_type='OR')
        self.xor_neuron = LogicalNeuron(neuron_type='XOR')
    
    def compute(self, a, b, carry_in):
        sum1 = self.xor_neuron.activation_function((a, b))
        sum_out = self.xor_neuron.activation_function((sum1, carry_in))

        carry1 = self.and_neuron.activation_function((a, b))
        carry2 = self.and_neuron.activation_function((sum1, carry_in))
        carry_out = self.or_neuron.activation_function((carry1, carry2))

        return sum_out, carry_out
