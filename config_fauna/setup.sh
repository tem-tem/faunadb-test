#
# FUNCTIONS
#

read_var() {
  if [ ! -f "$2" ]
  then
    # file not found
    # returning env var with that name
    echo "$2 not found"
    exit 1
  else
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
  fi
}

getDBKey()
{
  if NODE_ENV=='production';
  then
    echo $FAUNADB_SECRET
    exit
  else
    echo read_var FAUNADB_SECRET ./.env.development
  fi
}

authorizeFauna()
{
  echo "Authenticating with key: $key..."
  echo $key | fauna cloud-login
  # check auth
  if ! fauna list-databases; then exit 1; fi
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

createDatabase()
{
  if ! fauna create-database $1; then exit 1; fi
  echo "Getting a new secret key..."
  databaseKey=$( createKey $1 )
  echo "New secret key: $databaseKey"

  echo $databaseKey
}

uploadSchema()
{
  echo "Setting Resolvers..."
  fauna eval $1 --file=./src/db/resolvers.fql

  curl -H "Authorization: Bearer $2" 'https://graphql.fauna.com/import?mode=override' --data-binary "@./src/db/schema.gql"
  echo -e '\nSetup Complete.\n'
}

#
# MAIN SCRIPT
#

databaseName=$( echo "$1" | tr / _)
key=$( getDBKey )
if [ -z "$key" ];
then
  echo "FAUNADB_SECRET key not found. Can't setup."
  exit 1
fi

authorizeFauna $key
databaseKey=$( createDatabase $databaseName )
uploadSchema $databaseName $databaseKey

echo $databaseKey