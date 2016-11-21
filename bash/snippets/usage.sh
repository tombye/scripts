#! /bin/bash

# In the 'Usage:' line, $0 means the command
# The OPTIONS block should list all options possible

usage() {
  cat << EOF
  Usage: $0 [options] <path>

  Show repos with the specified gem

  OPTIONS:
    -p  pattern to match
    -g  show the grep output

EOF
}
