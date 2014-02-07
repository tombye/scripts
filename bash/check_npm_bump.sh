#! /bin/bash

function usage {
  cat << EOF
  Usage: $0 <version>

  Check version in the commit message matches the npm package

EOF
}

if [ $# -eq 0 ]
then
  usage
  exit 0
fi

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
grep "\"version\": \"$INTENDED_VERSION\"" package.json >/dev/null
NPM_MATCH=$?

if [ $NPM_MATCH -eq 0 ]
then
  echo "Version in package.json matches"
else
  echo "Version in package.json does not match"
fi
