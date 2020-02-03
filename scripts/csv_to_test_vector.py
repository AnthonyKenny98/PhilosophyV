"""Converts a CSV in the correct format to binary test vector."""

# -*- coding: utf-8 -*-
# @Author: AnthonyKenny98
# @Date:   2020-02-03 11:35:59
# @Last Modified by:   AnthonyKenny98
# @Last Modified time: 2020-02-03 12:25:11


import csv
import sys

""" CSV MUST BE IN THE FOLLOWING FORMAT

            col_0       col_1       col_2       col_3       ...
---------------------------------------------------------------
row_0   |   NUM_BITS    NUM_BITS    NUM_BITS    NUM_BITS    ...
row_1   |   dec_val     dec_val     dec_val     dec_val     ...
row_2   |   dec_val     dec_val     dec_val     dec_val     ...
row_3   |   dec_val     dec_val     dec_val     dec_val     ...
...     |   ...         ...         ...         ...

In short, the first row is the number of bits for that value.
All other rows are the different values.
"""


def main():
    """Main Function."""
    help_msg = 'Usage: csv_to_test_vector.py <input>.csv <path/to/output>.tv'

    # Validate arguments
    if len(sys.argv) != 3:
        print(help_msg)

    # Validate input and output file names
    infile, outfile = sys.argv[1], sys.argv[2]
    if not infile.endswith('.csv') or not outfile.endswith('.tv'):
        print(help_msg)

    # Open output file
    out = open(outfile, 'w')

    # Open input file
    with open(infile, 'r') as f:

        # Open reader and read first row for bit widths
        reader = csv.reader(f)
        bit_widths = next(reader)

        # Loop through remaining rows
        for row in reader:

            # Write decimal values to bit width binary values
            for i in range(len(row)):
                placeholder = '{:0' + bit_widths[i] + 'b}'
                out.write(str((placeholder.format(int(row[i]) & 0xffffffff))))
            out.write('\n')

    out.close()

if __name__ == "__main__":
    main()
