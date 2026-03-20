'''
create_network.py
Creates a new ANN base model with specified parameters and saves it as a .lp file for use in Clingo.
Usage example:
python3 create_network.py --input_size 3 --hidden_sizes 5 5 --output_size 2 --randomize_weights --scaled_integers --precision 4 --identifier v1 --folder models/
Testing example:
clingo show.lp models/ann_3in_5_5hidden_2out_v1.lp | python3 ../clingo_og_ann/graph_visualizer.py -v False -b True | dot -T pdf -o 'network_visualizer.pdf'
'''

import random
import argparse


def create_network(input_size, hidden_sizes, output_size, randomize_weights=True, scaled_integers=True, precision=4):
    '''
    Creates the facts for an ANN model
    Parameters:
    - input_size: Number of neurons in the input layer
    - hidden_sizes: List of sizes for each hidden layer
    - output_size: Number of neurons in the output layer
    - randomize_weights: Whether to initialize weights with random values (if False, weights will be initialized to 0)
    - scaled_integers: Whether to scale weights and excitations to integers (for Clingo compatibility)
    - precision: Number of decimal places to round to (if scaled_integers is True)
    Returns:
    - facts: List of strings representing the facts for the ANN model
    '''
    facts = []

    # Adding network parameters as facts
    facts.append(f"input_size({input_size}).")
    facts.append(f"hidden_depth({len(hidden_sizes)}).")
    for i, hidden_size in enumerate(hidden_sizes):
        facts.append(f"hidden_size({i}, {hidden_size}).")
    facts.append(f"output_size({output_size}).")


    ## neuron(type, layer, index) -- index 0 is bias

    # Adding input layer neurons
    facts.append(f"neuron(bias, 0, 0).")  # Bias neuron for input layer
    for index in range(1, input_size + 1):  # +1 for bias neuron
        facts.append(f"neuron(input, 0, {index}).")

    # Adding hidden layer neurons
    for layer, layer_size in enumerate(hidden_sizes, start=1):
        facts.append(f"neuron(bias, {layer}, 0).")  # Bias neuron for hidden layer
        for index in range(1, layer_size + 1):  # +1 for bias neuron
            facts.append(f"neuron(hidden, {layer}, {index}).")
    
    # Adding output layer neurons
    for index in range(output_size):
        layer = len(hidden_sizes) + 1
        facts.append(f"neuron(output, {layer}, {index}).")

    
    ## edge(source_layer, source_index, target_layer, target_index, weight)
    # If randomize_weights is True, initialize weights with random values between -1 and 1
    # If randomize_weights is False, initialize all weights to 0.5
    # If scaled_integers is True, scale weights to integers by multiplying by 10^precision

    # Adding edges from input layer to first hidden layer
    for source_index in range(input_size + 1):  # +1 for bias neuron
        for target_index in range(1, hidden_sizes[0] + 1):  # +1 for bias neuron
            if randomize_weights:
                weight = random.uniform(-1, 1)
            else:
                weight = 0.5
            
            if scaled_integers:
                weight = f'{round(weight * (10 ** precision))}'
            else:
                weight = f'{str(weight)}'

            facts.append(f"edge(0, {source_index}, 1, {target_index}, {weight}).")

    # Adding edges between hidden layers
    for layer in range(1, len(hidden_sizes)):
        for source_index in range(hidden_sizes[layer - 1] + 1):  # +1 for bias neuron
            for target_index in range(1, hidden_sizes[layer] + 1):  # +1 for bias neuron
                if randomize_weights:
                    weight = random.uniform(-1, 1)
                else:
                    weight = 0.5
                
                if scaled_integers:
                    weight = f'{round(weight * (10 ** precision))}'
                else:
                    weight = f'{str(weight)}'

                facts.append(f"edge({layer}, {source_index}, {layer + 1}, {target_index}, {weight}).")
    
    # Adding edges from last hidden layer to output layer
    layer = len(hidden_sizes)
    for source_index in range(hidden_sizes[-1] + 1):  # +1 for bias neuron
        for target_index in range(output_size):
            if randomize_weights:
                weight = random.uniform(-1, 1)
            else:
                weight = 0.5
            
            if scaled_integers:
                weight = f'{round(weight * (10 ** precision))}'
            else:
                weight = f'{str(weight)}'

            facts.append(f"edge({layer}, {source_index}, {layer + 1}, {target_index}, {weight}).")

    return facts

def save_network(facts, filename):
    '''
    Saves the ANN model facts to a .lp file
    Parameters:
    - facts: List of strings representing the facts for the ANN model
    - filename: Name of the file to save the facts to (should end with .lp)
    '''
    with open(filename, 'w') as f:
        f.write('\n'.join(facts))

def __main__():
    '''
    Parses arguments and creates/saves the ANN model
    '''
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_size', type=int, required=True, help='Number of neurons in the input layer')
    parser.add_argument('--hidden_sizes', type=int, nargs='+', required=True, help='List of sizes for each hidden layer (e.g. --hidden_sizes 5 5 for two hidden layers with 5 neurons each)')
    parser.add_argument('--output_size', type=int, required=True, help='Number of neurons in the output layer')
    parser.add_argument('--randomize_weights', action='store_true', help='Whether to initialize weights with random values (if not set, weights will be initialized to 0.5)')
    parser.add_argument('--scaled_integers', action='store_true', help='Whether to scale weights and excitations to integers (for Clingo compatibility)')
    parser.add_argument('--precision', type=int, default=4, help='Number of decimal places to round to (if --scaled_integers is set)')
    parser.add_argument('--identifier', type=str, default='', help='Optional identifier to include in the filename (e.g. for versioning or distinguishing different models)')
    parser.add_argument('--folder', type=str, default='models/', help='Folder to save the .lp file in (default: models/)')
    args = parser.parse_args()

    print(args.input_size, args.hidden_sizes, args.output_size, args.randomize_weights, args.scaled_integers, args.precision)

    facts = create_network(args.input_size, args.hidden_sizes, args.output_size, args.randomize_weights, args.scaled_integers, args.precision)
    filename = f"{args.folder}ann_{args.input_size}in_{'_'.join(map(str, args.hidden_sizes))}hidden_{args.output_size}out{f'_{args.identifier}' if args.identifier else ''}.lp"
    save_network(facts, filename)
    print(f"ANN model saved to {filename}")
    return filename

if __name__ == "__main__":
    __main__()