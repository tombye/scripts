for k in `git branch | sed s/^..//`
do
  echo -e `git log -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" "$k"`\\t"$k"
done | sort
