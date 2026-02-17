## Creates DOT code to visualize a graph made by the ann.lp program.
## Use: clingo .\Adaptive_Network\Clingo_ANN\ann.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'


show_edge_weights = False
show_bias_nodes = False
scaled_integer = True
precision = 4    # Can be 4 or 6 for 1e4 1e6 respectively

# Reading in clingo output
toks_last = None
toks = None
toks_next = input().split()

while not (toks_next and toks_next[0].startswith("OPT") or toks_next[0].startswith("SAT") or toks_next[0].startswith("UNSAT")):
    toks_last = toks
    toks = toks_next
    toks_next = input().split()

# Scripting graph
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
layer_nodes = {}
bias_nodes = {}
edges = ''

if toks_next[0].startswith("OPT") or toks_next[0].startswith("SAT"):
    if toks_next[0].startswith("OPT"):
        toks = toks_last
    
    for t in toks:
        if t.startswith("neuron"):
            line = t[7:-1]
            param = line.split(',')
            n_type = param[0]
            layer = int(param[1])
            index = int(param[2])
            if scaled_integer:
                val = f'{(float(param[3]) / (10**precision)):.3f}'
            else:
                val = f'{float(param[3])}'
            # val = f'{(float(param[3]) / (1e6)):.3f}'
            # val = f'{(float(param[3]) / (1e4)):.3f}'
            
            try:
                if n_type == 'bias':
                    bias_nodes[layer] = f"      node_{layer}_{index} [label={val}, color=yellow] ;\n"
                else:
                    layer_nodes[layer] += f"      node_{layer}_{index} [label={val}] ;\n"
            except KeyError:
                if n_type == 'input':
                    layer_nodes[layer] = "    { rank=same; node [color=green];\n" + f"      node_{layer}_{index} [label={val}] ;\n"
                elif n_type == 'hidden':
                    layer_nodes[layer] = "    { rank=same; node [color=red];\n" + f"      node_{layer}_{index} [label={val}] ;\n"
                elif n_type == 'output':
                    layer_nodes[layer] = "    { rank=same; node [color=blue];\n" + f"      node_{layer}_{index} [label={val}] ;\n"
                else:
                    layer_nodes[layer] = "    { rank=same;\n" + f"      node_{layer}_{index} [label={val}] ;\n"

        elif t.startswith("edge"):
            line = t[5:-1]
            param = line.split(',')
            source_layer = int(param[0])
            source_index = int(param[1])
            target_layer = int(param[2])
            target_index = int(param[3])
            if scaled_integer:
                weight = f'{(float(param[4]) / (10**precision)):.3f}'
            else:
                weight = f'{float(param[4])}'

            if source_index != 0 or (source_index == 0 and show_bias_nodes):
                if show_edge_weights:
                    edge = f'    node_{source_layer}_{source_index} -> node_{target_layer}_{target_index} [label={weight}] ;\n'
                else:
                    edge = f'    node_{source_layer}_{source_index} -> node_{target_layer}_{target_index} ;\n'
                edges += edge

    if show_bias_nodes:
        layer_nodes.update({k: layer_nodes[k] + v for k, v in bias_nodes.items()})
    full_layers = {k: v + '    }\n\n' for k, v in layer_nodes.items()}

    output += ''.join(full_layers.values()) + edges + "\n} // Graph"
    print(output + "\n")

# In case of unsatisfiability
elif toks_next[0].startswith("UNSAT"):
    print("No solution found.")