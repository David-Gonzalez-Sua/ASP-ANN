# Convert clingo image output to .lp file
# 
# Use: Clingo_Image_Interpreter.py -f <input_file> -i <input_folder> -o <output_file> -d <output_folder>
#   where: 
#       input_file is the optional name of the input txt file. This input can be piped in.
#       input_folder is the optional folder to get the input files from
#       output_file is the name of the output .lp file
#       output_folder is the folder to save the output files in
# 
# Example Use: 
# clingo .\image_manipulation\clingo_color_invert.lp .\new_datasets\MNIST_image.lp | python .\image_manipulation\Clingo_Image_Interpreter.py > .\new_datasets\MNIST_image_new.lp
# 


import re
import argparse


parser = argparse.ArgumentParser()

parser.add_argument('-f', default = "na", type = str,
                    help = "Optional input txt file name. This input can be piped in. (Default = 'na')")

parser.add_argument('-i', default = "na", type = str,
                    help = "Optional folder to get the input files from. (Default = 'na')")

parser.add_argument('-o', default = "MNIST_image_new", type = str,
                    help = "Output .lp file name. (Default = 'MNIST_image_new')")

parser.add_argument('-d', default = "new_datasets", type = str,
                    help = "Folder to save the output files in. (Default = 'new_datasets')")

args = parser.parse_args()

input_file = args.f
input_folder = args.i
output_file = args.o
output_folder = args.d

# Reading in clingo image output
if input_file != "na":
    with open(f"{input_folder}/{input_file}", "r") as f:
        toks = f.read().split()

else:
    toks = None
    toks_next = input().split()

    while not (toks_next and toks_next[0].startswith("SAT") or toks_next[0].startswith("UNSAT")):
        toks = toks_next
        toks_next = input().split()

facts = []

if toks_next[0].startswith("SAT"):
    
    for t in toks:
        if re.search(r"pixel", t, re.IGNORECASE):
            data = re.findall(r"\d+", t)
            fact = f"pixel({', '.join(map(str, data))})."
            facts.append(fact)

# In case of unsatisfiability
elif toks_next[0].startswith("UNSAT"):
    print("Error parsing! Unsatisfiable instance.")

# .lp file output
with open(output_folder + "/" + output_file + ".lp", "w") as f:
    f.write("\n".join(facts))
