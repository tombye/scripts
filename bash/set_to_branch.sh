#! /bin/bash

usage {
  cat << EOF
  Usage: $0 <branch-name>

  Set repos to the specified branch

EOF
}

if [ $# -eq 0 ]
then
  usage
  exit 0
fi

branch=$1

for repo in `ls -d */`
do 
  if [ -d $repo/.git ]
  then 
    cd $repo
    git branch | grep $1 > /dev/null
    if [ $? -eq 0 ]
    then
      echo $repo
      git co $1
    fi
    cd ../ 
  fi
done
