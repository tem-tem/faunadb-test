#
# FUNCTIONS
#

read_var() {
  if [ ! -f "$2" ]
  then
    # file not found
    # returning env var with that name
    echo "$2 not found" >&2
    exit 1
  else
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
  fi
}

getDBKey()
{
  if [ "$1" == "prod" ]; then
    echo $FAUNADB_SECRET
    exit
  else
    echo $( read_var FAUNADB_SECRET ./.env.development )
    exit
  fi
}

authorizeFauna()
{
  if ! fauna list-databases;
  then
    echo "Authenticating with key: $key..."
    echo $key | fauna cloud-login
    exit
  fi
}

createKey()
{
  key=$(fauna create-key $1 | grep "secret: \w*$" | cut -f2- -d:)
  if [ -z "$key" ]; then
    # grep couldn't get a key
    createKey $1
  else
    echo $key
  fi
}

uploadSchema()
{
  echo "Setting Resolvers..."
  fauna eval $1 --file=./src/db/resolvers.fql

  curl -H "Authorization: Bearer $2" 'https://graphql.fauna.com/import?mode=override' --data-binary "@./src/db/schema.gql"
  echo -e '\n\nSetup Completed.\n'
}

seed()
{
  seedFile=./src/db/seed.js
  if [ ! -f "$seedFile" ]; then
    echo "Error: Seed file '$seedFile' not found"
    exit
  fi

  seeds=$( node $seedFile $2 )
  if [ -z "$seeds" ]
  then
    echo "Error: Seed file not returning seeds. It should return graphql readable string query"
    exit
  fi

  echo "Seeding with key $1..."
  curl -d "$seeds" -H "Authorization: Bearer $1" -H "Content-Type: application/json" -X POST https://graphql.fauna.com/graphql
  echo -e '\n\nSeeding Completed.\n'
}

writeENV()
{
  envVars="FAUNADB_SECRET=$1"
  echo -e $envVars > ./.env.development.local
}

#
# MAIN SCRIPT
#

env=$1
databaseName=$( echo "$2" | tr / _)
if [ -z "$databaseName" ];
then
  echo "Missing database name. Can't start db setup."
  exit 1
fi

key=$( getDBKey $env )
if [ -z "$key" ];
then
  echo "FAUNADB_SECRET key not found. Can't start db setup."
  exit 1
fi

authorizeFauna $key
if ! fauna create-database $databaseName; then exit 1; fi
previewDBKey=$( createKey $databaseName )
uploadSchema $databaseName $previewDBKey
seed $previewDBKey $databaseName

if [ "$env" == "prod" ]
then
  # app is deployed
  FAUNADB_SECRET_PREVIEW=$previewDBKey yarn next build
  exit
else
  # script run locally
  writeENV $previewDBKey
fi