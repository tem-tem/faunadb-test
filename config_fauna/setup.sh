if ! command -v fauna; then
  echo 'fauna-shell not found. Install it and log in first: https://github.com/fauna/fauna-shell#fauna-shell'
  exit 1
fi

createDB()
{
  if ! fauna create-database $1;
  then
    echo -e "Failed creating a database."
    exit 1
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

writeENV()
{
  envVars="FAUNADB_SECRET=$1"
  echo -e $envVars > ./.env.development.local
}

returnDBName()
{
  if [ $# -eq 0 ]
  then
    echo "${PWD##*/}"
  else
    echo $1
  fi
}

setResolvers()
{
  fauna eval $1 --file=./src/db/resolvers.fql
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


runSetup()
{
  if fauna list-databases | grep $1
  then
    echo -e "\nDatabase '$1' already exist. What you want to do?"
    select yn in "Retry with a different name." "Override"
    do
      case $yn in
          "Retry with a different name.")
            echo 'Enter a new name (no whitespaces):'
            read newDatabaseName
            runSetup $newDatabaseName
            exit
          ;;
          Override )
            fauna delete-database $1
            runSetup $1
            exit
          ;;
      esac
    done
  else
    fauna create-database $1
    getKeyAndUploadSchema $1
  fi
}

databaseName=$( returnDBName $1 )
runSetup $databaseName

