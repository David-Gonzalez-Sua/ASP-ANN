# Neural network implementation of an 8-bit adder using McCulloch-Pitts neurons
import argparse


from full_adder_network import FullAdderNetwork


# 8bit numbers: 0-255
def int_to_8bit_binary(n):
    return [int(x) for x in format(n, '08b')]

def binary_to_int(bin_list):
    return int("".join(str(x) for x in bin_list), 2)

parser = argparse.ArgumentParser()

parser.add_argument('-x1', default = 5, type = int,
                    help = "x value to be added, 0-127. (Default = 5)")

parser.add_argument('-x2', default = 25, type = int,
                    help = "y value to be added, 0-127. (Default = 25)")

args = parser.parse_args()

x1 = args.x1
x2 = args.x2

x1_bin = int_to_8bit_binary(x1)
x2_bin = int_to_8bit_binary(x2)

full_adder = FullAdderNetwork()
sum_result = [0, 0, 0, 0, 0, 0, 0, 0]
carry_out = 0

for i in range(7, -1, -1):
    a = x1_bin[i]
    b = x2_bin[i]
    sum_bit, carry_out = full_adder.compute(a, b, carry_out)
    sum_result[i] = sum_bit

sum_int = binary_to_int(sum_result)
print(f"{x1} + {x2} = {sum_int}")
print(f"Binary: {x1_bin} + {x2_bin} = {sum_result}")