#!/usr/bin/env python3

import os
import hashlib
import sys

if len(sys.argv) < 2:
    print('Please specify a file to derive a hash from')
    quit()

file_path = sys.argv[1]

if not os.path.exists(file_path):
    print('{} does not exist'.format(file_path))
    quit()

# read file contents
with open(file_path, 'rb') as file:
    file_contents = file.read()
    file_hash = hashlib.md5(file_contents).hexdigest()

    # produce hash from contents
    print('Hash of {}: {}'.format(file_path, file_hash))

