#! /bin/bash

for repo in `ls`;
  do if [[ -d $repo && -f $repo/Gemfile ]]; then 
    cd $repo; 
    echo $repo; 
    git st; 
    cd ../; 
  fi; 
done
