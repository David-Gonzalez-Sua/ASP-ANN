# save_network.py
# This script saves Clingo Answer Set output to a .lp file
#
# Usage:
# clingo ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/create_network.lp | python ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/save_network.py --save_values --scaled_integers --precision 4 --filepath './models/ann.lp'

import argparse
import sys


parser = argparse.ArgumentParser()
parser.add_argument('--save_values', action='store_true', help='Whether to include neuron values in the output file. (Default = False)')
parser.add_argument('--scaled_integers', action='store_true', help='Whether to use scaled integers for weights. (Default = False)')
parser.add_argument('--precision', type=int, default=4, help='Precision for scaled integers. Can be 4 or 6 for 1e4 or 1e6 respectively. (Default = 4)')
parser.add_argument('--filepath', type=str, help='Full file path for the output file. Output printed to console if not provided.')
args = parser.parse_args()

# NOTE: This script will always save excitation values if they are included in the clingo output, regardless of the -v option.
save_values = args.save_values  # If true, saves neuron values in the output file.
scaled_integers = args.scaled_integers
precision = args.precision
filepath = args.filepath

# Reading in clingo output
toks_last = None
toks = None
toks_next = input().split()

while not (toks_next and toks_next[0].startswith("OPT") or toks_next[0].startswith("SAT") or toks_next[0].startswith("UNSAT")):
    toks_last = toks
    toks = toks_next
    toks_next = input().split()

# Parsing clingo output into facts and network parameters
if toks_next[0].startswith("OPT") or toks_next[0].startswith("SAT"):
    if toks_next[0].startswith("OPT"):
        toks = toks_last
    
    facts = []
    hidden_sizes = []
    input_size = None
    hidden_depth = None
    output_size = None

    for t in toks:
        if t.startswith("input_size"):
            line = t[11:-1]
            input_size = int(line)
            facts.append(f"input_size({input_size}).")

        elif t.startswith("hidden_depth"):
            line = t[13:-1]
            hidden_depth = int(line)
            facts.append(f"hidden_depth({hidden_depth}).")

        elif t.startswith("hidden_size"):
            line = t[12:-1]
            layer, hidden_size = map(int, line.split(','))
            hidden_sizes.append(hidden_size)
            facts.append(f"hidden_size({layer}, {hidden_size}).")

        elif t.startswith("output_size"):
            line = t[12:-1]
            output_size = int(line)
            facts.append(f"output_size({output_size}).")
        
        elif t.startswith("neuron"):
            line = t[7:-1]
            param = line.split(',')
            n_type = param[0]
            layer = int(param[1])
            index = int(param[2])
            if save_values and scaled_integers and len(param) > 3:
                value = f'{int(param[3])}'
            elif save_values and not scaled_integers and len(param) > 3:
                value = f'{str(param[3])}'

            if len(param) == 3:
                facts.append(f"neuron({n_type}, {layer}, {index}).")
            if save_values and len(param) > 3:
                facts.append(f"neuron({n_type}, {layer}, {index}, {value}).")

        elif t.startswith("edge"):
            line = t[5:-1]
            param = line.split(',')
            source_layer = int(param[0])
            source_index = int(param[1])
            target_layer = int(param[2])
            target_index = int(param[3])
            if scaled_integers:
                weight = f'{int(param[4])}'
            else:
                weight = f'{str(param[4])}'

            facts.append(f"edge({source_layer}, {source_index}, {target_layer}, {target_index}, {weight}).")

        elif t.startswith("excitation"):
            line = t[11:-1]
            param = line.split(',')
            layer = int(param[0])
            index = int(param[1])
            if scaled_integers:
                excitation = f'{int(param[2])}'
            else:
                excitation = f'{str(param[2])}'

            facts.append(f"excitation({layer}, {index}, {excitation}).")

    # Saving network parameters and facts to the filepath specified by the user
    if filepath:
        with open(filepath, "w") as f:
                f.write("\n".join(facts))
    else:
        print("\n".join(facts))

# In case of unsatisfiability
elif toks_next[0].startswith("UNSAT"):
    print("No solution found.")
    sys.exit(1)