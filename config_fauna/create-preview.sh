databaseName=$1
if [ -z "$databaseName" ];
then
  echo "Database name is not provided. Can't start db setup."
  exit 1
fi

echo "Setting up..."
databaseKey=$( bash ./config_fauna/setup.sh $databaseName )
echo -e "Finished.\n"

echo "Seeding..."
bash ./config_fauna/seed.sh $databaseKey
echo -e "Finished.\n"

FAUNADB_SECRET_CURRENT=$databaseKey yarn next build