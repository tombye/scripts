#! /bin/bash

usage() {
  cat << EOF
  Usage: $0 [options] $1

  Ack Notify's admin app code

  OPTIONS:
    -l only list the name of files with a match
    -t only search templates and components
    -v only search controllers

EOF
}

# $# is the number of arguments.
# The following will return an exit code of 0 if no arguments are sent

if [ $# -eq 0 ]
then
  usage
  exit 0
fi

ACK_OPTIONS=''
SEARCH_PATH='app'

# Loops through the options sent, as defined in quotes.
# The options in quotes: 
# - have a colon (:) after them if they are required to have an argument.
# - have a leading colon (:) if errors should be suppressed
# OPTION is just a variable to store the current option.
# OPTARG is the argument sent to the current option.
# OPTIND is the current index. We shift it to make $* the remaining arguments

OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts ":ltv" OPTION; do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    l )
      ACK_OPTIONS='-l'
      ;;
    t )
      SEARCH_PATH='app/templates'
      ;;
    v )
      SEARCH_PATH='app/main'
      ;;
  esac
done

shift $(($OPTIND-1))

ack --ignore-dir app/static $ACK_OPTIONS "$1" $SEARCH_PATH
