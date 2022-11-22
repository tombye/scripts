#! /bin/bash

usage() {
  cat << EOF
  Usage: $0 <path to tests>

  OPTIONS:
    All options are sent to the `jest` command

EOF
}

# $# is the number of arguments.
# The following will return an exit code of 0 if no arguments are sent

if [ $# -eq 0 ]
then
  usage
  exit 0
fi

TEST_PATH=$1

echo $TEST_PATH

node --inspect-brk node_modules/.bin/jest --runInBand --config tests/javascripts/jest.config.js $TEST_PATH
