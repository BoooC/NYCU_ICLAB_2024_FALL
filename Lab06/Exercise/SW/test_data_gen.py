import numpy as np


def hamming_encode(input_bits):
    # Step 1: Insert the input bits into positions while leaving space for parity bits at positions 1, 2, 4, 8.
    extended_bits = ['x'] * 15  # 15 bits for the 11-bit input (including 4 parity bits)
    input_index = 0

    # Fill in the non-parity bit positions (3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15)
    for i in range(1, 16):
        if i not in [1, 2, 4, 8]:
            extended_bits[i - 1] = input_bits[input_index]
            input_index += 1

    # Step 2: Find the positions of '1's in the extended bit array
    positions = [i + 1 for i, bit in enumerate(extended_bits) if bit == '1' and i + 1 not in [1, 2, 4, 8]]

    # Step 3: XOR the positions where '1' occurs
    xor_result = 0
    for pos in positions:
        xor_result ^= pos

    # Step 4: Convert the XOR result to binary, reverse it, and fill the parity bits
    xor_bin = list(f"{xor_result:04b}"[::-1])  # Reverse the XOR result to fill in parity bits

    # Fill parity bits at positions 1, 2, 4, 8
    extended_bits[0] = xor_bin[0]  # position 1
    extended_bits[1] = xor_bin[1]  # position 2
    extended_bits[3] = xor_bin[2]  # position 4
    extended_bits[7] = xor_bin[3]  # position 8

    return ''.join(extended_bits)


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

# Convert a number to 11-bit binary (two's complement for negative numbers)
def number_to_11bit_binary(num):
    if num < 0:
        return format((1 << 11) + num, '011b')  # Two's complement for negative numbers
    else:
        return format(num, '011b')

# Function to encode the matrix, convert to binary, and save to file
def matrix_to_encoded_binary_file(matrix, filename):
    with open(filename, 'w') as f:
        # Flatten the matrix in raster scan order (row-major order)
        flat_matrix = matrix.flatten()

        # Iterate through each element, encode, and convert to binary
        for num in flat_matrix:
            # Convert number to 11-bit binary
            bin_rep = number_to_11bit_binary(num)
            
            # Perform Hamming encoding on the 11-bit binary number
            encoded_bits = hamming_encode(bin_rep)
            
            # Write the encoded 15-bit binary to the file
            f.write(encoded_bits + '\n')


def determinant_custom(matrix):
    return round(np.linalg.det(matrix))

def raster_scan(matrix, window_size):
    """Generates all submatrices of a given size using raster scan order."""
    submatrices = []
    for i in range(4 - window_size + 1):
        for j in range(4 - window_size + 1):
            submatrix = matrix[i:i+window_size, j:j+window_size]
            submatrices.append(submatrix)
    return submatrices

def write_determinant_to_output(output_file, determinant_value):
    """Converts a determinant to 207-bit binary and writes to output file."""
    if determinant_value < 0:
        det_bin_rep = format((1 << 207) + determinant_value, '0207b')  # Two's complement for negative numbers
    else:
        det_bin_rep = format(determinant_value, '0207b')
    output_file.write(det_bin_rep + '\n')



def hamming_encode(input_bits):
    # Step 1: Insert the input bits into positions while leaving space for parity bits at positions 1, 2, 4, 8.
    extended_bits = ['x'] * 15  # 15 bits for the 11-bit input (including 4 parity bits)
    input_index = 0

    # Fill in the non-parity bit positions (3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15)
    for i in range(1, 16):
        if i not in [1, 2, 4, 8]:
            extended_bits[i - 1] = input_bits[input_index]
            input_index += 1

    # Step 2: Find the positions of '1's in the extended bit array
    positions = [i + 1 for i, bit in enumerate(extended_bits) if bit == '1' and i + 1 not in [1, 2, 4, 8]]

    # Step 3: XOR the positions where '1' occurs
    xor_result = 0
    for pos in positions:
        xor_result ^= pos

    # Step 4: Convert the XOR result to binary, reverse it, and fill the parity bits
    xor_bin = list(f"{xor_result:04b}"[::-1])  # Reverse the XOR result to fill in parity bits

    # Fill parity bits at positions 1, 2, 4, 8
    extended_bits[0] = xor_bin[0]  # position 1
    extended_bits[1] = xor_bin[1]  # position 2
    extended_bits[3] = xor_bin[2]  # position 4
    extended_bits[7] = xor_bin[3]  # position 8

    return ''.join(extended_bits)

def number_to_11bit_binary(num):
    if num < 0:
        return format((1 << 11) + num, '011b')  # Two's complement for negative numbers
    else:
        return format(num, '011b')

def determinant_custom(matrix):
    return round(np.linalg.det(matrix))

def raster_scan(matrix, window_size):
    """Generates all submatrices of a given size using raster scan order."""
    submatrices = []
    for i in range(4 - window_size + 1):
        for j in range(4 - window_size + 1):
            submatrix = matrix[i:i+window_size, j:j+window_size]
            submatrices.append(submatrix)
    return submatrices

def format_determinant(determinant_value, bit_width):
    """Converts a determinant to a signed binary string with the given bit width."""
    if determinant_value < 0:
        return format((1 << bit_width) + determinant_value, f'0{bit_width}b')  # Two's complement for negative numbers
    else:
        return format(determinant_value, f'0{bit_width}b')

def write_determinant_to_output(output_file, determinant_value, bit_width):
    """Converts a determinant to a signed binary with a given bit width and writes to output."""
    det_bin_rep = format_determinant(determinant_value, bit_width)
    output_file.write(det_bin_rep + '\n')



def handle_4x4_mode_with_separator(matrix, output_file, is_first):
    """Handles the mode where a 4x4 determinant is calculated and extended to 207-bit, with separator."""
    determinant_value = determinant_custom(matrix[:4, :4])
    write_determinant_to_output_with_separator(output_file, determinant_value, bit_width=207, is_first=is_first)

def handle_3x3_mode_with_separator(matrix, output_file, is_first):
    """Handles the mode where four 3x3 determinants are calculated, each extended to 51-bit, with separator."""
    determinants = [determinant_custom(submatrix) for submatrix in raster_scan(matrix, 3)]
    
    # Convert each determinant to 51-bit signed binary
    extended_results = [format_determinant(det, 51) for det in determinants]
    
    # Concatenate the results and add 3-bit '0' padding at the beginning
    result_string = '000' + ''.join(extended_results)
    
    # Write the result and append a separator '0', add leading '0' only for the first entry
    write_result_with_separator(output_file, result_string, is_first)

def handle_2x2_mode_with_separator(matrix, output_file, is_first):
    """Handles the mode where nine 2x2 determinants are calculated, each extended to 23-bit, with separator."""
    determinants = [determinant_custom(submatrix) for submatrix in raster_scan(matrix, 2)]
    
    # Convert each determinant to 23-bit signed binary
    extended_results = [format_determinant(det, 23) for det in determinants]
    
    # Concatenate the results to form a 207-bit string
    result_string = ''.join(extended_results)
    
    # Write the result and append a separator '0', add leading '0' only for the first entry
    write_result_with_separator(output_file, result_string, is_first)

def write_determinant_to_output_with_separator(output_file, determinant_value, bit_width, is_first):
    """Converts a determinant to a signed binary with a given bit width and writes to output with separator."""
    det_bin_rep = format_determinant(determinant_value, bit_width)
    write_result_with_separator(output_file, det_bin_rep, is_first)

def write_result_with_separator(output_file, result_string, is_first):
    """Writes the result to the output file with a '0' separator, and adds leading '0' only for the first entry."""
    if is_first:
        output_file.write('0\n')  # Leading '0' before the first entry
    output_file.write(result_string + '\n0\n')  # Append separator after each entry

# Update the generate_test_data_with_mode function to ensure only one separator between entries
def generate_test_data_with_mode_with_separator(matrix, num_matrices, mode, input_filename, output_filename):
    with open(input_filename, 'w') as input_file, open(output_filename, 'w') as output_file:
        # Process the specific matrix first
        input_file.write("0\n")  # Always add index 0 for the first test case
        flat_matrix = matrix.flatten()
        for num in flat_matrix:
            # Convert number to 11-bit binary and encode
            bin_rep = number_to_11bit_binary(num)
            encoded_bits = hamming_encode(bin_rep)

            # Write the encoded 15-bit binary to input.txt
            input_file.write(encoded_bits + '\n')

        # Perform determinant calculation based on the mode, set is_first = True
        is_first = True
        if mode == '011001100':  # 4x4 determinant
            handle_4x4_mode_with_separator(matrix, output_file, is_first)

        elif mode == '100001100':  # 3x3 determinants with a raster scan window
            handle_3x3_mode_with_separator(matrix, output_file, is_first)

        elif mode == '010101000':  # 2x2 determinants with a raster scan window
            handle_2x2_mode_with_separator(matrix, output_file, is_first)

        # Generate additional random matrices
        is_first = False  # No leading '0' for subsequent entries
        for _ in range(1, num_matrices):
            random_matrix = np.random.randint(-1024, 1024, (4, 4))

            # Always add index 0 for each test case
            input_file.write("0\n")

            # Flatten the matrix and write to input.txt
            flat_matrix = random_matrix.flatten()
            for num in flat_matrix:
                bin_rep = number_to_11bit_binary(num)
                encoded_bits = hamming_encode(bin_rep)
                input_file.write(encoded_bits + '\n')

            # Perform determinant calculation based on the mode
            if mode == '011001100':  # 4x4 determinant
                handle_4x4_mode_with_separator(random_matrix, output_file, is_first)

            elif mode == '100001100':  # 3x3 determinants with a raster scan window
                handle_3x3_mode_with_separator(random_matrix, output_file, is_first)

            elif mode == '010101000':  # 2x2 determinants with a raster scan window
                handle_2x2_mode_with_separator(random_matrix, output_file, is_first)

matrix = np.array([
    [ 1023,        1023,      -1024],
    [-1024,       -1024,      -1024],
    [ 1023,       -1024,       1023]
])


matrix = np.array([
    [-1024,    -1024,   -1024, -1024],
    [-1024,    -1024,    1023,  1023],
    [-1024,     1023,   -1024,  1023],
    [-1024,     1023,    1023, -1024]
])


a = np.linalg.det(matrix)

a11, a12, a13, a14 = matrix[0]
a21, a22, a23, a24 = matrix[1]
a31, a32, a33, a34 = matrix[2]
a41, a42, a43, a44 = matrix[3]
'''
result = {
    'a12*a21': a12 * a21,
    'a13*a21': a13 * a21,
    'a14*a21': a14 * a21,
    'a11*a22': a11 * a22,
    'a13*a22': a13 * a22,
    'a14*a22': a14 * a22,
    'a11*a23': a11 * a23,
    'a12*a23': a12 * a23,
    'a14*a23': a14 * a23,
    'a11*a24': a11 * a24,
    'a12*a24': a12 * a24,
    'a13*a24': a13 * a24,
    'a11*a22 - a12*a21': a11 * a22 - a12 * a21,
    'a11*a23 - a13*a21': a11 * a23 - a13 * a21,
    'a12*a23 - a13*a22': a12 * a23 - a13 * a22,
    'a11*a24 - a14*a21': a11 * a24 - a14 * a21,
    'a12*a24 - a14*a22': a12 * a24 - a14 * a22,
    'a13*a24 - a14*a23': a13 * a24 - a14 * a23,
    'a31*(a13*a24 - a14*a23)': a31 * (a13 * a24 - a14 * a23),
    'a31*(a12*a24 - a14*a22)': a31 * (a12 * a24 - a14 * a22),
    'a31*(a12*a23 - a13*a22)': a31 * (a12 * a23 - a13 * a22),
    'a32*(a13*a24 - a14*a23)': a32 * (a13 * a24 - a14 * a23),
    'a32*(a11*a24 - a14*a21)': a32 * (a11 * a24 - a14 * a21),
    'a32*(a11*a23 - a13*a21)': a32 * (a11 * a23 - a13 * a21),
    'a33*(a12*a24 - a14*a22)': a33 * (a12 * a24 - a14 * a22),
    'a33*(a11*a24 - a14*a21)': a33 * (a11 * a24 - a14 * a21),
    'a33*(a11*a22 - a12*a21)': a33 * (a11 * a22 - a12 * a21),
    'a34*(a12*a23 - a13*a22)': a34 * (a12 * a23 - a13 * a22),
    'a34*(a11*a23 - a13*a21)': a34 * (a11 * a23 - a13 * a21),
    'a34*(a11*a22 - a12*a21)': a34 * (a11 * a22 - a12 * a21),
    'a32*(a13*a24 - a14*a23) - a33*(a12*a24 - a14*a22) + a34*(a12*a23 - a13*a22)': a32 * (a13 * a24 - a14 * a23) - a33 * (a12 * a24 - a14 * a22) + a34 * (a12 * a23 - a13 * a22),
    'a31*(a13*a24 - a14*a23) - a33*(a11*a24 - a14*a21) + a34*(a11*a23 - a13*a21)': a31 * (a13 * a24 - a14 * a23) - a33 * (a11 * a24 - a14 * a21) + a34 * (a11 * a23 - a13 * a21),
    'a31*(a12*a24 - a14*a22) - a32*(a11*a24 - a14*a21) + a34*(a11*a22 - a12*a21)': a31 * (a12 * a24 - a14 * a22) - a32 * (a11 * a24 - a14 * a21) + a34 * (a11 * a22 - a12 * a21),
    'a31*(a12*a23 - a13*a22) - a32*(a11*a23 - a13*a21) + a33*(a11*a22 - a12*a21)': a31 * (a12 * a23 - a13 * a22) - a32 * (a11 * a23 - a13 * a21) + a33 * (a11 * a22 - a12 * a21),
    'a41 * [a32*(a13*a24 - a14*a23) - a33*(a12*a24 - a14*a22) + a34*(a12*a23 - a13*a22)]': a41 * (a32 * (a13 * a24 - a14 * a23) - a33 * (a12 * a24 - a14 * a22) + a34 * (a12 * a23 - a13 * a22)),
    'a42 * [a31*(a13*a24 - a14*a23) - a33*(a11*a24 - a14*a21) + a34*(a11*a23 - a13*a21)]': a42 * (a31 * (a13 * a24 - a14 * a23) - a33 * (a11 * a24 - a14 * a21) + a34 * (a11 * a23 - a13 * a21)),
    'a43 * [a31*(a12*a24 - a14*a22) - a32*(a11*a24 - a14*a21) + a34*(a11*a22 - a12*a21)]': a43 * (a31 * (a12 * a24 - a14 * a22) - a32 * (a11 * a24 - a14 * a21) + a34 * (a11 * a22 - a12 * a21)),
    'a44 * [a31*(a12*a23 - a13*a22) - a32*(a11*a23 - a13*a21) + a33*(a11*a22 - a12*a21)]': a44 * (a31 * (a12 * a23 - a13 * a22) - a32 * (a11 * a23 - a13 * a21) + a33 * (a11 * a22 - a12 * a21))
}
'''

result = {
    'a12*a21': a12 * a21,
    'a13*a21': a13 * a21,
    'a14*a21': a14 * a21,
    'a11*a22': a11 * a22,
    'a13*a22': a13 * a22,
    'a14*a22': a14 * a22,
    'a11*a23': a11 * a23,
    'a12*a23': a12 * a23,
    'a14*a23': a14 * a23,
    'a11*a24': a11 * a24,
    'a12*a24': a12 * a24,
    'a13*a24': a13 * a24,
    'a11*a22 - a12*a21': a11 * a22 - a12 * a21,
    'a11*a23 - a13*a21': a11 * a23 - a13 * a21,
    'a12*a23 - a13*a22': a12 * a23 - a13 * a22,
    'a11*a24 - a14*a21': a11 * a24 - a14 * a21,
    'a12*a24 - a14*a22': a12 * a24 - a14 * a22,
    'a13*a24 - a14*a23': a13 * a24 - a14 * a23,
    'a31*(a13*a24 - a14*a23)': a31 * (a13 * a24 - a14 * a23),
    'a31*(a12*a24 - a14*a22)': a31 * (a12 * a24 - a14 * a22),
    'a31*(a12*a23 - a13*a22)': a31 * (a12 * a23 - a13 * a22),
    'a32*(a13*a24 - a14*a23)': a32 * (a13 * a24 - a14 * a23),
    'a32*(a11*a24 - a14*a21)': a32 * (a11 * a24 - a14 * a21),
    'a32*(a11*a23 - a13*a21)': a32 * (a11 * a23 - a13 * a21),
    'a33*(a12*a24 - a14*a22)': a33 * (a12 * a24 - a14 * a22),
    'a33*(a11*a24 - a14*a21)': a33 * (a11 * a24 - a14 * a21),
    'a33*(a11*a22 - a12*a21)': a33 * (a11 * a22 - a12 * a21),
    'a34*(a12*a23 - a13*a22)': a34 * (a12 * a23 - a13 * a22),
    'a34*(a11*a23 - a13*a21)': a34 * (a11 * a23 - a13 * a21),
    'a34*(a11*a22 - a12*a21)': a34 * (a11 * a22 - a12 * a21),
    'a32*(a13*a24 - a14*a23) - a33*(a12*a24 - a14*a22) + a34*(a12*a23 - a13*a22)': a32 * (a13 * a24 - a14 * a23) - a33 * (a12 * a24 - a14 * a22) + a34 * (a12 * a23 - a13 * a22),
    'a31*(a13*a24 - a14*a23) - a33*(a11*a24 - a14*a21) + a34*(a11*a23 - a13*a21)': a31 * (a13 * a24 - a14 * a23) - a33 * (a11 * a24 - a14 * a21) + a34 * (a11 * a23 - a13 * a21),
    'a31*(a12*a24 - a14*a22) - a32*(a11*a24 - a14*a21) + a34*(a11*a22 - a12*a21)': a31 * (a12 * a24 - a14 * a22) - a32 * (a11 * a24 - a14 * a21) + a34 * (a11 * a22 - a12 * a21),
    'a31*(a12*a23 - a13*a22) - a32*(a11*a23 - a13*a21) + a33*(a11*a22 - a12*a21)': a31 * (a12 * a23 - a13 * a22) - a32 * (a11 * a23 - a13 * a21) + a33 * (a11 * a22 - a12 * a21),
    'a41 * [a32*(a13*a24 - a14*a23) - a33*(a12*a24 - a14*a22) + a34*(a12*a23 - a13*a22)]': a41 * (a32 * (a13 * a24 - a14 * a23) - a33 * (a12 * a24 - a14 * a22) + a34 * (a12 * a23 - a13 * a22)),
    'a42 * [a31*(a13*a24 - a14*a23) - a33*(a11*a24 - a14*a21) + a34*(a11*a23 - a13*a21)]': a42 * (a31 * (a13 * a24 - a14 * a23) - a33 * (a11 * a24 - a14 * a21) + a34 * (a11 * a23 - a13 * a21)),
    'a43 * [a31*(a12*a24 - a14*a22) - a32*(a11*a24 - a14*a21) + a34*(a11*a22 - a12*a21)]': a43 * (a31 * (a12 * a24 - a14 * a22) - a32 * (a11 * a24 - a14 * a21) + a34 * (a11 * a22 - a12 * a21)),
    'a44 * [a31*(a12*a23 - a13*a22) - a32*(a11*a23 - a13*a21) + a33*(a11*a22 - a12*a21)]': a44 * (a31 * (a12 * a23 - a13 * a22) - a32 * (a11 * a23 - a13 * a21) + a33 * (a11 * a22 - a12 * a21))
}


result = {
    'a12*a21': a12 * a21,
    'a13*a21': a13 * a21,
    'a11*a22': a11 * a22,
    'a13*a22': a13 * a22,
    'a14*a22': a14 * a22,
    'a11*a23': a11 * a23,
    'a12*a23': a12 * a23,
    'a14*a23': a14 * a23,
    'a12*a24': a12 * a24,
    'a13*a24': a13 * a24,

    'a11*a22 - a12*a21': a11 * a22 - a12 * a21,
    'a11*a23 - a13*a21': a11 * a23 - a13 * a21,
    'a12*a23 - a13*a22': a12 * a23 - a13 * a22,
    'a12*a24 - a14*a22': a12 * a24 - a14 * a22,
    'a13*a24 - a14*a23': a13 * a24 - a14 * a23,

    'a21*a32 - a22*a31': a21 * a32 - a22 * a31,
    'a21*a33 - a23*a31': a21 * a33 - a23 * a31,
    'a22*a33 - a23*a32': a22 * a33 - a23 * a32,
    'a22*a34 - a24*a32': a22 * a34 - a24 * a32,
    'a23*a34 - a24*a33': a23 * a34 - a24 * a33,
    
    'a31*(a12*a23 - a13*a22) - a32*(a11*a23 - a13*a21) + a33*(a11*a22 - a12*a21)': a31 * (a12 * a23 - a13 * a22) - a32 * (a11 * a23 - a13 * a21) + a33 * (a11 * a22 - a12 * a21),
    'a32*(a13*a24 - a14*a23) - a33*(a12*a24 - a14*a22) + a34*(a12*a23 - a13*a22)': a32 * (a13 * a24 - a14 * a23) - a33 * (a12 * a24 - a14 * a22) + a34 * (a12 * a23 - a13 * a22),
    'a41*(a22*a33 - a23*a32) - a42*(a21*a33 - a23*a31) + a43*(a21*a32 - a22*a31)': a41 * (a22 * a33 - a23 * a32) - a42 * (a21 * a33 - a23 * a31) + a43 * (a21 * a32 - a22 * a31),
    'a42*(a23*a34 - a24*a33) - a43*(a22*a34 - a24*a32) + a44*(a22*a33 - a23*a32)': a42 * (a23 * a34 - a24 * a33) - a43 * (a22 * a34 - a24 * a32) + a44 * (a22 * a33 - a23 * a32)
}



result = {
    'a11*a22': a11 * a22,
    'a12*a21': a12 * a21,
    'a12*a23': a12 * a23,
    'a13*a22': a13 * a22,
    'a13*a24': a13 * a24,
    'a14*a23': a14 * a23,
    'a21*a32': a21 * a32,
    'a22*a31': a22 * a31,
    'a22*a33': a22 * a33,
    'a23*a32': a23 * a32,
    'a23*a34': a23 * a34,
    'a24*a33': a24 * a33,
    'a31*a42': a31 * a42,
    'a32*a41': a32 * a41,
    'a32*a43': a32 * a43,
    'a33*a42': a33 * a42,
    'a33*a44': a33 * a44,
    'a34*a43': a34 * a43,

    'a11*a22 - a12*a21': a11 * a22 - a12 * a21,
    'a12*a23 - a13*a22': a12 * a23 - a13 * a22,
    'a13*a24 - a14*a23': a13 * a24 - a14 * a23,

    'a21*a32 - a22*a31': a21 * a32 - a22 * a31,
    'a22*a33 - a23*a32': a22 * a33 - a23 * a32,
    'a23*a34 - a24*a33': a23 * a34 - a24 * a33,
    
    'a31*a42 - a32*a41': a31 * a42 - a32 * a41,
    'a32*a43 - a33*a42': a32 * a43 - a33 * a42,
    'a33*a44 - a34*a43': a33 * a44 - a34 * a43
}


specific_matrix = np.array([
    [1, 2, -3, -4],
    [-5, -6, 7, 8],
    [-9, 10, -11, 12],
    [13, -14, 15, -16]
])

mode_4x4 = '011001100'
mode_3x3 = '100001100'
mode_2x2 = '010101000'


# Running for the 3x3 mode with separators
#generate_test_data_with_mode_with_separator(specific_matrix, 100, mode_2x2, 'input_2x2.txt', 'output_2x2.txt')



import random
def generate_test_data_with_fixed_and_random_mode(matrix, num_matrices, input_filename, output_filename, mode_filename):
    modes = ['011001100', '100001100', '010101000']
    
    with open(input_filename, 'w') as input_file, open(output_filename, 'w') as output_file, open(mode_filename, 'w') as mode_file:
        # Process the specific matrix first with all 3 modes
        for idx, mode in enumerate(modes):
            input_file.write("0\n")  # Add index for each test case
            mode_file.write(f"0\n{mode}\n")  # Write the chosen mode to mode.txt
            
            flat_matrix = matrix.flatten()
            for num in flat_matrix:
                # Convert number to 11-bit binary and encode
                bin_rep = number_to_11bit_binary(num)
                encoded_bits = hamming_encode(bin_rep)

                # Write the encoded 15-bit binary to input.txt
                input_file.write(encoded_bits + '\n')

            # Perform determinant calculation based on the fixed mode
            is_first = (idx == 0)  # First entry gets a leading '0'
            if mode == '011001100':  # 4x4 determinant
                handle_4x4_mode_with_separator(matrix, output_file, is_first)

            elif mode == '100001100':  # 3x3 determinants with a raster scan window
                handle_3x3_mode_with_separator(matrix, output_file, is_first)

            elif mode == '010101000':  # 2x2 determinants with a raster scan window
                handle_2x2_mode_with_separator(matrix, output_file, is_first)

        # Generate additional random matrices
        is_first = False  # No leading '0' for subsequent entries
        for idx in range(3, num_matrices + 3):  # Start from the 4th test case
            random_matrix = np.random.randint(-1024, 1024, (4, 4))

            # Always add index 0 for each test case
            input_file.write("0\n")
            mode_file.write(f"0\n")  # Write index to mode.txt

            # Randomly choose a mode for this matrix
            mode = random.choice(modes)
            mode_file.write(f"{mode}\n")  # Write the chosen mode to mode.txt

            # Flatten the matrix and write to input.txt
            flat_matrix = random_matrix.flatten()
            for num in flat_matrix:
                bin_rep = number_to_11bit_binary(num)
                encoded_bits = hamming_encode(bin_rep)
                input_file.write(encoded_bits + '\n')

            # Perform determinant calculation based on the randomly chosen mode
            if mode == '011001100':  # 4x4 determinant
                handle_4x4_mode_with_separator(random_matrix, output_file, is_first)

            elif mode == '100001100':  # 3x3 determinants with a raster scan window
                handle_3x3_mode_with_separator(random_matrix, output_file, is_first)

            elif mode == '010101000':  # 2x2 determinants with a raster scan window
                handle_2x2_mode_with_separator(random_matrix, output_file, is_first)

# Test run with fixed matrix and random mode generation
specific_matrix = np.array( 
    [[-1024, -1024, -1024,  1023],
     [-1024, -1024,  1023, -1024],
     [ 1023, -1024, -1024, -1024],
     [-1024,  1023, -1024, -1024]]
)

generate_test_data_with_fixed_and_random_mode(specific_matrix, 100000, 'input.txt', 'output.txt', 'input_mode.txt')

                

