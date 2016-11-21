#! /bin/bash

usage {
  cat << EOF
  Usage: $0 <branch-name>

  Show repos with the specified branch

EOF
}

if [ $# -eq 0 ]
then
  usage
  exit 0
fi

for repo in `ls -d */`
do 
  if [ -d $repo/.git ]
  then 
    cd $repo
    { git branch | grep $1 > /dev/null; } && echo $repo;
    cd ../ 
  fi
done
