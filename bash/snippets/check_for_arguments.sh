#! /bin/bash

# $# is the number of arguments.
# The following will return an exit code of 0 if no arguments are sent

if [ $# -eq 0 ]
then
  usage
  exit 0
fi
