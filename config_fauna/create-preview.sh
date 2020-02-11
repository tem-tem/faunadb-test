read_var() {
  if [ ! -f "$2" ]
  then
    eval "echo \${$1}"
    exit
  else
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
  fi
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

getKeyAndUploadSchema()
{
  echo "Setting Resolvers..."
  fauna eval $1 --file=./src/db/resolvers.fql

  curl -H "Authorization: Bearer $2" 'https://graphql.fauna.com/import?mode=override' --data-binary "@./src/db/schema.gql"

  echo -e '\nSetup Complete.\n'
}
printenv

key=$(read_var FAUNADB_SECRET ./.env.development)

echo "Authenticating with key: $key..."
echo $key | fauna cloud-login

databaseName=$( echo "$1" | tr / _)
if ! fauna list-databases; then exit 1; fi
if ! fauna create-database $databaseName; then exit 1; fi

echo "Getting a new secret key..."
databaseKey=$( getDBKey $databaseName )
echo "New secret key: $databaseKey"
echo -e 'Done.\n'

getKeyAndUploadSchema $databaseName $databaseKey

# seeds

seedFile=./src/db/seed.js
if [ ! -f "$seedFile" ]; then
  echo "Error: Seed file '$seedFile' not found"
  exit
fi

seeds=$( node $seedFile $NOW_GITHUB_COMMIT_SHA )
if [ -z "$seeds" ]
then
  echo "Error: Seed file not returning seeds. It should return graphql readable string query"
  exit
fi

echo "Seeding from file './src/db/seed.js'..."
curl -d "$seeds" -H "Authorization: Bearer $databaseKey" -H "Content-Type: application/json" -X POST https://graphql.fauna.com/graphql
echo -e '\n\nSeeding Complete.'
FAUNADB_SECRET_CURRENT="$databaseKey" yarn next build
