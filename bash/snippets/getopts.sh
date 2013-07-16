#! /bin/bash

# Loops through the options sent, as defined in quotes.
# The options in quotes: 
# - have a colon (:) after them if they are required.
# - have a leading colon (:) if errors should be suppressed
# OPTION is just a variable to store the current option.
# OPTARG is the argument sent to the current option.
# OPTIND is the current index. We shift it to make $* the remaining arguments

while getopts "p:g" OPTION; do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    p )
      PATTERN=$OPTARG
      ;;
    g )
      SHOWGREP=1
      ;;
  esac
done
shift $(($OPTIND-1))
