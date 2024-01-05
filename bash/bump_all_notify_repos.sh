#! /bin/bash

repos=(
  "$HOME/Projects/notify/notifications-admin"
  "$HOME/Projects/notify/notifications-api"
  "$HOME/Projects/notify/document-download-api"
  "$HOME/Projects/notify/document-download-frontend"
  "$HOME/Projects/notify/notifications-antivirus"
  "$HOME/Projects/notify/notifications-template-preview"
)

pull_repos=true
for key in "${!repos[@]}"
do
  current_branch=$(git symbolic-ref --short HEAD)
  current_repo="${repos[$key]}"
  if [ "$current_branch" != "main" ]; then
    #echo "$current_repo is on $current_branch"
    echo "nope"
    pull_repos=false
  fi
done

if [ $pull_repos == false ]; then
  echo "Some repos are not on main branch, stopping"
  exit 0
fi

for key in "${!repos[@]}"
do
  current_repo="${repos[$key]}"
  cd $current_repo
  echo "Pulling main branch from $current_repo"
  git pull origin main
done
