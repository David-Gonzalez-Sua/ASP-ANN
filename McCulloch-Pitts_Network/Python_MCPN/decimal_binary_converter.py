#!/usr/bin/env python3
#
# Converts decimal numbers to binary and vice versa
import sys

# 8bit numbers: 0-255
def decimal_to_binary(n, bits=8):
    """Convert a decimal number to its binary representation with a fixed number of bits."""
    return [int(x) for x in format(n, f'0{bits}b')]

def binary_to_decimal(bit_list):
    """Convert a binary representation (list of bits) to its decimal number."""
    return int("".join(str(bit) for bit in bit_list), 2)

if __name__ == "__main__":
    '''This handles use from the Clingo MCPN'''
    output = ''

    if len(sys.argv == 3):
        # Inputs conversion from decimal to binary
        num_bits = sys.argv[3]
        a = decimal_to_binary(sys.argv[1], sys.argv[3])
        b = decimal_to_binary(sys.argv[2], sys.argv[3])
        
        output += f"binary_a({','.join(a)}).\n"
        for bit in range(num_bits-1, -1, -1):
            output += f"bit(a, {bit}, {a[bit]}).\n"
        
        output += f"binary_b({','.join(b)}).\n"
        for bit in range(num_bits-1, -1, -1):
            output += f"bit(b, {bit}, {b[bit]}).\n"

    else:
        # Output conversion from binary to decimal
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
            
            for t in toks:
                if t.startswith("binary_sum"):
                    line = t[11:-1]
                    binary_output = line.split(',')
                    decimal_output = binary_to_decimal(binary_output)

                elif t.startswith("binary_a"):
                    line = t[9:-1]
                    binary_input_a = line.split(',')
                    decimal_input_a = binary_to_decimal(binary_input_a)

                elif t.startswith("binary_b"):
                    line = t[9:-1]
                    binary_input_b = line.split(',')
                    decimal_input_b = binary_to_decimal(decimal_input_b)

            output += f"Decimal: {decimal_input_a} + {decimal_input_b} = {decimal_output}\n"
            output += f"Decimal: {binary_input_a} + {binary_input_b} = {binary_output}\n"

        # In case of unsatisfiability
        elif toks_next[0].startswith("UNSAT"):
            print("No solution found.")
        
    print(output)
