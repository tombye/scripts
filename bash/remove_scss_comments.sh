#!/bin/bash

# Mostly borrowed from: https://github.com/duckinator/duckinator.net/blob/master/_minify-css.sh

usage {
  cat << EOF
  Usage: $0 [options]

  Strip CSS comments from all files in the directory

  OPTIONS:
    -f format of file (lowercase, no period) to search, defaults to scss

EOF
}

FORMAT='scss'

while getopts "f" OPTION; do
  case $OPTION in
    f )
      FORMAT=$OPTION
      ;;
  esac
done

shift $(($OPTIND-1))

for file in `find . -name *.$FORMAT`
do
  # remove single-line starred comments 
  sed -i '' 's|/\*.*\*/||g' $file
  # remove multi-line comments
  sed -i '' '/\/\*/,/\*\//d' $file
  # remove single-line non-starred comments 
  sed -i '' 's|//.*||g' $file
  # remove left-over blank lines
  sed -i '' '/^$/d' $file
done;
