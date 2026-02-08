# Neural network implementation of an 8-bit adder using McCulloch-Pitts neurons
# Each bit addition is handled by a full adder network
# The network is built bit by bit, propagating carry bits as needed
# Use: python 8bit_adder.py -a <value1> -b <value2> -s <bits>
# Example usage: python '.\McCulloch-Pitts Network\Python_MCPN\8bit_adder.py' -a 250 -b 750 -s 16


from collections import defaultdict
from collections import deque
import argparse


import decimal_binary_converter as dbc
from logical_neuron import LogicalNeuron
from full_adder_network import FullAdderNetwork


parser = argparse.ArgumentParser()

parser.add_argument('-x1', default = 5, type = int,
                    help = "x value to be added. 0-127 for 8 bits. (Default = 5)")

parser.add_argument('-x2', default = 25, type = int,
                    help = "y value to be added, 0-127 for 8 bits. (Default = 25)")

parser.add_argument('-b', default=8, type = int,
                    help = "Number of bits for the adder. (Default = 8)")

args = parser.parse_args()

x1 = args.a
x2 = args.b
bits = args.s

x1_bin = dbc.decimal_to_binary(x1, bits)
x2_bin = dbc.decimal_to_binary(x2, bits)

# Directed edges from neurons to neurons stored as adjacency list
# {nueron1: [neuron2, neuron3]} 
graph = defaultdict(list)

full_adder = FullAdderNetwork()

processing_queue = deque()

carry = LogicalNeuron(neuron_type='INPUT', name='carry_in')
carry.set_inputs([0])  # initial carry is 0

# Build the 8-bit adder network bit by bit
for bit_index in range(bits - 1, -1, -1):
    # Build network for each bit position
    prefix = f'bit{bits - 1 - bit_index}_'

    input_a = LogicalNeuron(neuron_type='INPUT', name=prefix+'input_a')
    input_a.set_inputs([x1_bin[bit_index]])
    processing_queue.append(input_a)

    input_b = LogicalNeuron(neuron_type='INPUT', name=prefix+'input_b')
    input_b.set_inputs([x2_bin[bit_index]])
    processing_queue.append(input_b)

    outputs = full_adder.build_general_network(
        graph,
        input_a,
        input_b,
        carry,
        prefix=prefix
    )
    
    if 'carry_in' in carry.name:
        processing_queue.append(carry)

    carry = outputs[1]  # Update carry for next bit position


# Evaluate the network in a breadth-first manner
sum_result = [0]*bits  # to store the final sum bits
while processing_queue:
    current_neuron = processing_queue.popleft()
    
    if current_neuron.activated:
        continue  # Skip if already activated
    
    output = current_neuron.activation_function()

    # print(f'Neuron: {current_neuron.name}, Inputs: {current_neuron.get_inputs()}, Output: {output}')

    if 'input' in current_neuron.name.lower():
        current_neuron2 = processing_queue.popleft()
        output2 = current_neuron2.activation_function()

    output_neurons = graph[current_neuron]

    for target_neuron in output_neurons:
        if 'carry' in target_neuron.name:
            processing_queue.appendleft(target_neuron)

        else:
            processing_queue.append(target_neuron)

        if 'input' in current_neuron.name.lower():
            target_neuron.set_inputs([output, output2])

        else:
            target_neuron.set_inputs(target_neuron.get_inputs() + [output])
    
    if 'sum' in current_neuron.name.lower():
        bit_index = int(current_neuron.name.split('bit')[1].split('_')[0])
        sum_result[bits - 1 - bit_index] = output


print("8-bit Adder using McCulloch-Pitts Network")
print("---------------------------------------")
print("""
digraph G {
    rankdir=LR; // makes the graph flow left-to-right
    
    // Align all inputs (bit0_input_a, bit0_input_b, ..., bit7_input_a, bit7_input_b)
    { rank=same;
      bit0_input_a; bit0_input_b;
      bit1_input_a; bit1_input_b;
      bit2_input_a; bit2_input_b;
      bit3_input_a; bit3_input_b;
      bit4_input_a; bit4_input_b;
      bit5_input_a; bit5_input_b;
      bit6_input_a; bit6_input_b;
      bit7_input_a; bit7_input_b;
    }

    // Align all output sums horizontally
    { rank=same;
      bit0_output_sum;
      bit1_output_sum;
      bit2_output_sum;
      bit3_output_sum;
      bit4_output_sum;
      bit5_output_sum;
      bit6_output_sum;
      bit7_output_sum;
    }
      """)
for neuron in graph:
    for target in graph[neuron]:
        print(f'    {neuron.name} -> {target.name} [label={neuron.activation_function()}] ;')
print("}")


# Display the result
sum_int = dbc.binary_to_decimal(sum_result)
print(f"{x1} + {x2} = {sum_int}")
print(f"Binary: {x1_bin} + {x2_bin} = {sum_result}")