# Converts decimal numbers to binary and vice versa
import sys

# 8bit numbers: 0-255
def decimal_to_binary(n, bits=8):
    """Convert a decimal number to its binary representation with a fixed number of bits."""
    return [int(x) for x in format(n, f'0{bits}b')]

def binary_to_decimal(bit_list):
    """Convert a binary representation (list of bits) to its decimal number."""
    return int("".join(str(bit) for bit in bit_list), 2)