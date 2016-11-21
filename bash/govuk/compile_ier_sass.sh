function usage {
  cat << EOF
  Usage: $0 [options]

  Compile SCSS to CSS for the IER project

  OPTIONS:
    -w  watch the files for changes and compile then

EOF
}

IER=/Users/tombyers/Documents/repos/govuk/ier-frontend
INPUT=$IER/app/assets/stylesheets
OUTPUT=$IER/target/scala-2.10/resource_managed/main/public/stylesheets
SHEETS=( mainstream application )
WORKED=1
WATCH=1

while getopts "hw" OPTION; do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    w )
      WATCH=0
      ;;
  esac
done
shift $(($OPTIND-1))

for SHEET in "${SHEETS[@]}"
do
  if [ $WATCH -eq 0 ]
  then
    sass --style expanded --line-numbers --load-path $IER/app/assets/govuk_frontend_toolkit/stylesheets --watch $INPUT/$SHEET.scss:$OUTPUT/$SHEET.css
  else
    sass --style expanded --line-numbers --load-path $IER/app/assets/govuk_frontend_toolkit/stylesheets $INPUT/$SHEET.scss $OUTPUT/$SHEET.css
    WORKED=$?
    if [ $WORKED -eq 0 ]
    then
      echo "sass $SHEET.scss compiled to $SHEET.css"
    fi
    echo "at" `date`
  fi
done
