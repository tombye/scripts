#! /bin/bash

function usage {
  cat << EOF
  Usage: $0 -p <gem-pattern> [options]

  Show repos with the specified gem

  OPTIONS:
    -p  pattern to match
    -g  show the grep output

EOF
}

if [ $# -eq 0 ]
then
  usage
  exit 0
fi

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

if [ -z "$PATTERN" ]; then
  usage
  exit 1
fi

for repo in `ls -d */`
do 
  if [ -f ${repo}Gemfile ]; then 
    grep_output=`grep $PATTERN $repo/Gemfile`
    found=$?
    if [ $found -eq 0 ]; then
      echo $repo | sed 's/\///g'
      if [ -n "$SHOWGREP" ]; then
        echo "grep output $grep_output"
      fi
    fi
  fi
done
