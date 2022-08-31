git branch --merged main | grep -v 'main$' | xargs -I% git branch -D %
