# Use:
# clingo .\data_manip\clingo_color_inverter.lp .\new_datasets\MNIST_image.lp | python .\data_manip\Clingo_Image_Interpreter.py > .\new_datasets\MNIST_image_inverted.lp
# 
#
# Note:
#


import re

# Reading in clingo image output
toks = None
toks_next = input().split()

while not (toks_next and toks_next[0].startswith("SAT") or toks_next[0].startswith("UNSAT")):
    toks = toks_next
    toks_next = input().split()


if toks_next[0].startswith("SAT"):
    
    for t in toks:
        if re.search(r"pixel", t, re.IGNORECASE):
            data = re.findall(r"\d+", t)
            fact = f"pixel({', '.join(map(str, data))})."
            print(fact)

# In case of unsatisfiability
elif toks_next[0].startswith("UNSAT"):
    print("Error parsing! Unsatisfiable instance.")
