#!/usr/bin/env python3
#
# Converts decimal numbers to binary and vice versa
# Use: bash ./McCulloch-Pitts_Network/Clingo_MCPN/run_adder.sh 


import argparse


# 8bit numbers: 0-255
def decimal_to_binary(n, bits=8):
    """Convert a decimal number to its binary representation with a fixed number of bits."""
    return [int(x) for x in format(n, f'0{bits}b')]

def binary_to_decimal(bit_list):
    """Convert a binary representation (list of bits) to its decimal number."""
    return int("".join(str(bit) for bit in bit_list), 2)

def decimal_to_binary_facts(decimal_a, decimal_b, num_bits):
    # Inputs conversion from decimal to binary
    output = ''

    # num_bits broken for some reason
    binary_a = decimal_to_binary(decimal_a, num_bits)
    binary_b = decimal_to_binary(decimal_b, num_bits)

    output += f"binary_a({','.join(list(map(str, binary_a)))}).\n"
    for bit in range(num_bits):
        output += f"bit(a, {num_bits - 1 - bit}, {binary_a[bit]}).\n"
    
    output += f"binary_b({','.join(list(map(str, binary_b)))}).\n"
    for bit in range(num_bits):
        output += f"bit(b, {num_bits - 1 - bit}, {binary_b[bit]}).\n"

    return output

def binary_facts_to_decimal():
    # Output conversion from binary to decimal
    output = ''

    toks_last = None
    toks = None
    toks_next = input().split()

    while not (toks_next and toks_next[0].startswith("OPT") or toks_next[0].startswith("SAT") or toks_next[0].startswith("UNSAT")):
        toks_last = toks
        toks = toks_next
        toks_next = input().split()
    
    if toks_next[0].startswith("OPT") or toks_next[0].startswith("SAT"):
        if toks_next[0].startswith("OPT"):
            toks = toks_last
        
        binary_input_a = []
        binary_input_b = []
        binary_output = []
        decimal_input_a = 0
        decimal_input_b = 0
        decimal_output = 0

        for t in toks:
            if t.startswith("binary_sum"):
                line = t[11:-1]
                print(line)
                binary_output = list(map(int, line.split(',')))
                decimal_output = binary_to_decimal(binary_output)

            elif t.startswith("binary_a"):
                line = t[9:-1]
                binary_input_a = list(map(int, line.split(',')))
                decimal_input_a = binary_to_decimal(binary_input_a)

            elif t.startswith("binary_b"):
                line = t[9:-1]
                binary_input_b = list(map(int, line.split(',')))
                decimal_input_b = binary_to_decimal(binary_input_b)

        output += f"Decimal: {decimal_input_a} + {decimal_input_b} = {decimal_output}\n"
        output += f"Decimal: {binary_input_a} + {binary_input_b} = {binary_output}\n"

    # In case of unsatisfiability
    elif toks_next[0].startswith("UNSAT"):
        print("No solution found.")

    return output


if __name__ == "__main__":
    '''This handles use from the Clingo MCPN'''
    parser = argparse.ArgumentParser()

    parser.add_argument('-f', default = 0, type = int, required=True,
                        help = "flag indicating which script to run. 0 for decimal to binary, " \
                        "1 for binary to decimal using clingo output.")

    parser.add_argument('-a', default = 5, type = int,
                        help = "x value to be added. 0-127 for 8 bits. (Default = 5)")

    parser.add_argument('-b', default = 35, type = int,
                        help = "y value to be added, 0-127 for 8 bits. (Default = 35)")

    parser.add_argument('-s', default=8, type = int,
                        help = "Number of bits for the adder. (Default = 8)")

    args = parser.parse_args()

    flag = int(args.f)
    arg_a = int(args.a)
    arg_b = int(args.b)
    arg_bits = int(args.s)

    if flag == 0:
        output = decimal_to_binary_facts(arg_a, arg_b, arg_bits)

    else:
        output = binary_facts_to_decimal()

    print(output)
