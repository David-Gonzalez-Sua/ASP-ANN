# Full adder implementation using McCulloch-Pitts neurons
from logical_neuron import LogicalNeuron


class FullAdderNetwork:
    def __init__(self):
        # initialize all variables as None
        self.input_a = None
        self.input_b = None
        self.input_carry = None
        self.xor1 = None
        self.and1 = None
        self.xor2 = None
        self.and2 = None
        self.or_ = None
        self.output_sum = None
        self.output_carry = None
        self.graph = {}
        pass
    
    # def build_network(self):
    #     # Create neurons
    #     self.input_a = LogicalNeuron(neuron_type='INPUT')
    #     self.input_b = LogicalNeuron(neuron_type='INPUT')
    #     self.input_carry = LogicalNeuron(neuron_type='INPUT')

    #     self.xor1 = LogicalNeuron(neuron_type='XOR')
    #     self.and1 = LogicalNeuron(neuron_type='AND')

    #     self.xor2 = LogicalNeuron(neuron_type='XOR')
    #     self.and2 = LogicalNeuron(neuron_type='AND')
        
    #     self.or_ = LogicalNeuron(neuron_type='OR')
        
    #     self.output_sum = LogicalNeuron(neuron_type='OUTPUT')
    #     self.output_carry = LogicalNeuron(neuron_type='OUTPUT')

    #     # Create directed graph
    #     self.graph = {
    #         self.input_a: [self.xor1, self.and1],
    #         self.input_b: [self.xor1, self.and1],

    #         self.xor1: [self.xor2, self.and2],
    #         self.and1: [self.or_],

    #         self.xor2: [self.output_sum],
    #         self.and2: [self.or_],

    #         self.or_: [self.output_carry]
    #     }
        
    def build_general_network(self, graph, input_a, input_b, carry_in, prefix='', suffix=''):
        xor1 = LogicalNeuron(neuron_type='XOR', name=prefix+'xor1'+suffix)
        and1 = LogicalNeuron(neuron_type='AND', name=prefix+'and1'+suffix)
        xor2 = LogicalNeuron(neuron_type='XOR', name=prefix+'xor2'+suffix)
        and2 = LogicalNeuron(neuron_type='AND', name=prefix+'and2'+suffix)
        or1 = LogicalNeuron(neuron_type='OR', name=prefix+'or1'+suffix)
        output_sum = LogicalNeuron(neuron_type='OUTPUT', name=prefix+'output_sum'+suffix)
        carry_out = LogicalNeuron(neuron_type='OUTPUT', name=prefix+'carry_out'+suffix)

        graph[input_a].extend([xor1, and1])
        graph[input_b].extend([xor1, and1])
        graph[carry_in].extend([xor2, and2])

        graph[xor1] = [xor2, and2]
        graph[and1] = [or1]

        graph[xor2] = [output_sum]
        graph[and2] = [or1]

        graph[or1] = [carry_out]

        graph[output_sum] = []
        graph[carry_out] = []

        return output_sum, carry_out

        
    # def __hash__(self):
    #     return hash((self.graph))

    # def __eq__(self, other):
    #     return (self.graph) == (other.graph)

    # def __ne__(self, other):
    #     # Not strictly necessary, but to avoid having both x==y and x!=y
    #     # True at the same time
    #     return not(self == other)
        

    # def sum_first_try(self, a, b, carry_in):
    #     and_neuron = LogicalNeuron(neuron_type='AND')
    #     or_neuron = LogicalNeuron(neuron_type='OR')
    #     xor_neuron = LogicalNeuron(neuron_type='XOR')

    #     sum1 = xor_neuron.activation_function((a, b))
    #     sum_out = xor_neuron.activation_function((sum1, carry_in))

    #     carry1 = and_neuron.activation_function((a, b))
    #     carry2 = and_neuron.activation_function((sum1, carry_in))
    #     carry_out = or_neuron.activation_function((carry1, carry2))

    #     return sum_out, carry_out

    # def sum_no_network(self, a, b, carry_in):
    #     # Define neurons
    #     xor1 = LogicalNeuron(neuron_type='XOR')
    #     xor2 = LogicalNeuron(neuron_type='XOR')
    #     and1 = LogicalNeuron(neuron_type='AND')
    #     and2 = LogicalNeuron(neuron_type='AND')
    #     or_ = LogicalNeuron(neuron_type='OR')

    #     # First layer
    #     sum1 = xor1.activation_function((a, b))
    #     carry1 = and1.activation_function((a, b))

    #     # Second layer
    #     sum_out = xor2.activation_function((sum1, carry_in))
    #     carry2 = and2.activation_function((sum1, carry_in))

    #     # Final carry out
    #     carry_out = or_.activation_function((carry1, carry2))

    #     return sum_out, carry_out