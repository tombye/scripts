#! /bin/bash

# In the 'Usage:' line, $0 means the command
# The OPTIONS block should list all options possible

function usage {
  cat << EOF
  Usage: $0 <APP_NAME>

EOF
}

DIR=`pwd`
APP_NAME=$1
GEMS=( slimmer govuk_template govuk_frontend_toolkit )
GEMS_USED=""

function get_app_folder {
  local APP=$1
  cat development/Procfile | grep "^$APP" | grep -v '^#' | sed -E 's/[\ ]+/,/g' | cut -d ',' -f 5 | grep '^\.\.\/' | sed 's/^\.\.\///g'
}

function app_uses_gems {
  local APP=$1
  local APP_FOLDER=""
  local USES_GEM=1
  GEMS_USED=""
  for GEM in "${GEMS[@]}"
  do
    APP_FOLDER=`get_app_folder $APP`
    grep $GEM $APP_FOLDER/Gemfile &> /dev/null
    USES_GEM=$?
    if [ $USES_GEM -eq 0 ]
    then
      if [ ${#GEMS_USED} -eq 0 ]
      then
        GEMS_USED="$GEM"
      else
        GEMS_USED="$GEMS_USED & $GEM"
      fi
    fi
  done
}

if [ $# -eq 0 ]
then
  usage
  exit 0
fi

if [ -f $APP_NAME/Gemfile ]
then
  app_uses_gems $APP_NAME
  if [ ${#GEMS_USED} -gt 0 ]
  then
    echo ""
    echo "$APP_NAME uses $GEMS_USED"
  fi
fi

DEPENDANCIES=`cat development/Pinfile | grep "process\ :$APP_NAME" | grep '\[*\]'`
DEPENDANCY_FOLDER=""
HAS_DEPENDANCIES=$?

if [ $HAS_DEPENDANCIES -eq 0 ]
then
  DEPENDANCIES=`echo $DEPENDANCIES | cut -d '>' -f 2 | tr -d '[]: '`
  IFS="," read -a DEPENDANCIES<<<"${DEPENDANCIES}"

  echo ""
  echo "$APP_NAME has the following dependancies:"
  echo ""
  for DEPENDANCY in "${DEPENDANCIES[@]}"
  do
    DEPENDANCY_FOLDER=`get_app_folder $DEPENDANCY`
    if [ -f $DEPENDANCY_FOLDER/Gemfile ]
    then
      app_uses_gems $DEPENDANCY
      if [ ${#GEMS_USED} -gt 0 ]
      then
        echo "$DEPENDANCY (which uses $GEMS_USED)"
      fi
    else
      echo $DEPENDANCY
    fi
  done
  echo ""
fi
