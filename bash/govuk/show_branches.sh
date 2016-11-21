ANSI_GREEN="\033[32m"
ANSI_YELLOW="\033[33m"
ANSI_RESET="\033[0m"

DIR=/Users/$USER/Documents/repos/govuk

if [ $HOME == /home/vagrant ]
  then
    DIR=/var/govuk
fi

for i in `ls $DIR`
do
  if [ -d $DIR/$i/.git ]
    then 
      cd $DIR/$i
      echo -e $i: $ANSI_GREEN`git symbolic-ref HEAD | sed 's|^refs/heads/||'`$ANSI_RESET
      cd ../
  fi
done
