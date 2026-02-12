## Creates DOT code to visualize a graph made by the ann.lp program.
## Use: clingo .\Adaptive_Network\Clingo_ANN\ann.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\network_visualizer.pdf'


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

            try:
                layer_nodes[layer] += f'      node_{layer}_{index} [label={n_type}] ;\n'
            except KeyError:
                layer_nodes[layer] = '    { rank=same;\n' + f'      node_{layer}_{index} [label={n_type}] ;\n'

        if t.startswith("edge"):
            line = t[5:-1]
            param = line.split(',')
            source_layer = int(param[0])
            source_index = int(param[1])
            target_layer = int(param[2])
            target_index = int(param[3])

            edge = f'    node_{source_layer}_{source_index} -> node_{target_layer}_{target_index} ;\n'
            edges += edge

    my_dict = {k: v + '    }\n\n' for k, v in layer_nodes.items()}

    output += ''.join(my_dict.values()) + edges + "\n} // Graph"
    print(output + "\n")

# In case of unsatisfiability
elif toks_next[0].startswith("UNSAT"):
    print("No solution found.")