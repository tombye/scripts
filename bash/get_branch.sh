git st | grep '# On branch' | sed 's/^\# On branch //' | tr -d '\n' | pbcopy
