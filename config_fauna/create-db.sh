databaseName=$1
if [ -z "$databaseName" ];
then
  echo "Database name is not provided. Can't start db setup."
  exit 1
fi

databaseKey=$( bash ./config_fauna/setup.sh )
bash ./config_fauna/seed.sh $databaseKey
