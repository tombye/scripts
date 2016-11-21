#! /bin/bash

usage {
  cat << EOF
  Usage: $0 <version>

  Check version in the commit message matches the gem

EOF
}

if [ $# -eq 0 ]
then
  usage
  exit 0
fi

FOLDER=`basename "$PWD"`
INTENDED_VERSION=$1

# get the last commit message and extract the version
MESSAGED=`git log --oneline -1 | sed 's/.*\([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\)$/\1/'`

if [ "$MESSAGED" == "$INTENDED_VERSION" ]
then
  echo "Version in the commit matches"
else
  echo "Version in the commit is does not match"
fi

# check this version is in the version.rb file
grep "VERSION = \"$INTENDED_VERSION\"" lib/$FOLDER/version.rb >/dev/null
GEM_MATCH=$?

if [ $GEM_MATCH -eq 0 ]
then
  echo "Version in version.rb matches"
else
  echo "Version in version.rb does not match"
fi 
