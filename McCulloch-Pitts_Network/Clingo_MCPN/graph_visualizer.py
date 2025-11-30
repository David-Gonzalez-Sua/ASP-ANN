## Creates DOT code to visualize a graph made by the 8bit_adder.lp program.
## Use: clingo '.\McCulloch-Pitts_Network\Clingo_MCPN\8bit_adder.lp' | python '.\McCulloch-Pitts_Network\Clingo_MCPN\graph_visualizer.py' | dot -T pdf -o '.\McCulloch-Pitts_Network\Clingo_MCPN\network_visualizer.pdf'


# Reading in clingo output
toks_last = None
toks = None
toks_next = input().split()

while not (toks_next and toks_next[0].startswith("OPT") or toks_next[0].startswith("SAT") or toks_next[0].startswith("UNSAT")):
    toks_last = toks
    toks = toks_next
    toks_next = input().split()

# Scripting graph
output = '''// Graph visualization using dot
strict digraph G {
    rankdir=LR; // makes the graph flow left-to-right

    // Align all inputs (bit0_a, bit0_b, ..., bit7_a, bit7_b)
    { rank=same;
      bit0_carry;
      bit0_a; bit0_b;
      bit1_a; bit1_b;
      bit2_a; bit2_b;
      bit3_a; bit3_b;
      bit4_a; bit4_b;
      bit5_a; bit5_b;
      bit6_a; bit6_b;
      bit7_a; bit7_b;
    }

    // Align all output sums horizontally
    { rank=same;
      bit0_output;
      bit1_output;
      bit2_output;
      bit3_output;
      bit4_output;
      bit5_output;
      bit6_output;
      bit7_output;
      bit8_carry;
    }

'''

if toks_next[0].startswith("OPT") or toks_next[0].startswith("SAT"):
    if toks_next[0].startswith("OPT"):
        toks = toks_last
    
    for t in toks:
        if t.startswith("edge"):
            line = t[5:-1]
            param = line.split(',')
            if param[1] == 'carry':
                edge = f'    bit{int(param[2])-1}_{param[0]} -> bit{param[2]}_{param[1]} [label={param[3]}] ;\n'
            else:
                edge = f'    bit{param[2]}_{param[0]} -> bit{param[2]}_{param[1]} [label={param[3]}] ;\n'
            output += edge 

    output += "\n} // Graph"
    print(output + "\n")

# In case of unsatisfiability
elif toks_next[0].startswith("UNSAT"):
    print("No solution found.")