import random

def hamming_decode(input_bits, bit_length):
    # Step 1: Identify the positions of bits that are '1'
    positions = [i + 1 for i, bit in enumerate(input_bits) if bit == '1']

    # Step 2: Convert the positions to binary and XOR them
    xor_result = 0
    for pos in positions:
        xor_result ^= pos

    # Step 3: If xor_result is non-zero, we need to flip the bit at that position
    if xor_result > 0 and xor_result <= bit_length:  # Ensure the xor_result is within the input length
        # Convert the xor_result (1-based position) to a 0-based index for the bit flip
        xor_position = xor_result - 1
        # Flip the bit at the xor_position
        input_bits = list(input_bits)
        input_bits[xor_position] = '0' if input_bits[xor_position] == '1' else '1'
        input_bits = ''.join(input_bits)

    # Step 4: Remove the parity check bits (positions 1, 2, 4, 8)
    # The number of parity bits depends on the input bit length.
    # Positions of parity bits: 2^(n-1) where n is the position of the bit.
    parity_positions = [2**i for i in range(bit_length) if 2**i <= bit_length]
    
    # Step 5: Extract the data bits by removing parity bits
    decoded_bits = [bit for i, bit in enumerate(input_bits) if i + 1 not in parity_positions]

    return ''.join(decoded_bits)



def generate_random_hamming_data(num_samples, bit_width):
    input_data = []
    output_data = []

    for _ in range(num_samples):
        # Generate a random 15-bit binary number
        input_bits = ''.join(random.choice('01') for _ in range(bit_width))

        # Decode the input using the Hamming code logic
        decoded_bits = hamming_decode(input_bits, bit_width)

        # Store the input and output as binary strings
        input_data.append(input_bits)
        output_data.append(decoded_bits)

    return input_data, output_data

'''
sample_data = 1000 
bit_width = 10
input_data, output_data = generate_random_hamming_data(sample_data, bit_width)

with open('input_IP_10.txt', 'w') as infile, open('output_IP_10.txt', 'w') as outfile:
    for inp, outp in zip(input_data, output_data):
        infile.write(f"{inp}\n")
        outfile.write(f"{outp}\n")
'''

'''
test_input = '10110110011011'
decoded_output = hamming_decode(test_input, bit_width)

print(decoded_output)
'''




