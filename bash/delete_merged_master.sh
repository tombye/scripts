git branch --merged master | grep -v 'master$' | xargs -I% git branch -D %
