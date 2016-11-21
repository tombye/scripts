#! /bin/bash
#
# Load the tariff database from a .sql file
#

usage()
{
cat << EOF
Usage: $0 SQL_file

Load the tariff database from a .sql file

EXAMPLES:
  setup_tariff.sh -f tariff_development_data.sql
EOF
}

while getopts "f:" OPTION
do
  case $OPTION in
    f ) 
      file=$OPTARG
      ;;  
  esac
done
shift $(($OPTIND-1))

if [ -z "$file" ] 
  then
    echo "No sql file specified please add one using the -f flag";
fi
echo "Loading $file into tariff_development database"
# cat $file | sed s/\([A-Za-z0-9_]\{1,\}\)_production/\1_development/g | mysql -u root tariff_development --debug-info
echo "Data loaded, indexing the database for search"
govuk
cd trade-tariff-frontend
bundle exec tariff:reindex
printf "\nDone!"
