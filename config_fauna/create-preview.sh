read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

getKeyAndUploadSchema()
{
  databaseName="$1"
  echo "Getting a new secret key..."
  databaseKey=$( getDBKey $databaseName )
  echo "New secret key: $databaseKey"
  echo -e 'Done.\n'

  echo "Setting Resolvers..."
  setResolvers $databaseName

  writeENV $databaseKey
  echo "Uploading schema to '$databaseName'..."
  curl -H "Authorization: Bearer $databaseKey" 'https://graphql.fauna.com/import?mode=override' --data-binary "@./src/db/schema.gql"

  echo -e '\nSetup Complete.\n'
}

key=$(read_var FAUNADB_SECRET .env.development)

echo "Authenticating..."
echo "$key" | fauna cloud-login

fauna create-database $1
getKeyAndUploadSchema $1

seedFile=./src/db/seed.js
if [ ! -f "$seedFile" ]; then
  echo "Error: Seed file '$seedFile' not found"
  exit
fi

mutations=$( node $seedFile )
if [ -z "$mutations" ]
then
  echo "Error: Seed file not returning seeds. It should return graphql readable string query"
  exit
fi

echo "Seeding from file './src/db/seed.js'..."
echo "$mutations"
curl -d "$mutations" -H "Authorization: Bearer $key" -H "Content-Type: application/json" -X POST https://graphql.fauna.com/graphql
echo -e '\n\nSeeding Complete.'