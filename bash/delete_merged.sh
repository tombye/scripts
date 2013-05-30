git branch --merged master | sed 's/ *origin\///' | grep -v 'master$' | xargs -I% git branch -D %
