read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

getDBKey()
{
  key=$(fauna create-key $1 | grep "secret: \w*$" | cut -f2- -d:)
  if [ -z "$key" ]; then
    getDBKey $1
  else
    echo $key
  fi
}

writeENV()
{
  envVars="FAUNADB_SECRET=$1"
  echo -e $envVars > ./.env.development
}

getKeyAndUploadSchema()
{
  databaseName="$1"
  echo "Getting a new secret key..."
  databaseKey=$( getDBKey $databaseName )
  echo "New secret key: $databaseKey"
  echo -e 'Done.\n'

  echo "Setting Resolvers..."
  fauna eval $databaseName --file=./src/db/resolvers.fql
  writeENV $databaseKey

  curl -H "Authorization: Bearer $databaseKey" 'https://graphql.fauna.com/import?mode=override' --data-binary "@./src/db/schema.gql"

  echo -e '\nSetup Complete.\n'
}

key=$(read_var FAUNADB_SECRET ./.env.development)

echo "Authenticating with key: $key..."
echo "$key" | fauna cloud-login
echo "$key"
echo "\n\n"

databaseName=$( echo "$1" | tr / _)
fauna create-database $databaseName
getKeyAndUploadSchema $databaseName

# seeds

seedFile=./src/db/seed.js
if [ ! -f "$seedFile" ]; then
  echo "Error: Seed file '$seedFile' not found"
  exit
fi

seeds=$( node $seedFile )
if [ -z "$seeds" ]
then
  echo "Error: Seed file not returning seeds. It should return graphql readable string query"
  exit
fi

key=$(read_var FAUNADB_SECRET ./.env.development)

echo "Seeding from file './src/db/seed.js'..."
curl -d "$seeds" -H "Authorization: Bearer $key" -H "Content-Type: application/json" -X POST https://graphql.fauna.com/graphql
echo -e '\n\nSeeding Complete.'