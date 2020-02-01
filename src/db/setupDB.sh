deleteDBIfExists() {
  if fauna list-databases | grep "$1";
  then
    fauna delete-database $1
  fi
}

createDB()
{
  if fauna create-database $1 | grep "created database '$1'";
  then
    echo "Created $1"
  else
    echo "Error: something went wrong creating db"
    exit 1
  fi
}

seed()
{
  if fauna eval $1 --file=./src/db/seed.fql;
  then
    echo 'Seeded Succesfuly'
  else
    echo "Error: something went wrong seeding db"
    exit 1
  fi
}

getDBKey()
{
  key=$(fauna create-key $1 | grep "secret: \w*$" | cut -f2- -d:)
  if [ -z "$key" ]; then
    getDBKey $1
  else
    echo "$key"
  fi
}

writeENV()
{
  localDBKey=$( getDBKey $1 )
  envVars="FAUNADB_SECRET=$localDBKey\nFAUNA_DOMAIN=localhost\nFAUNA_SCHEME=http\nFAUNA_PORT=8443\nFAUNA_ROOT_KEY=secret\nFAUNADB_NAME=$1"
  echo -e $envVars > ./.env.development
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

if curl http://localhost:8443/ping;
then
  dbName=$( returnDBName $1 )
  echo "Database name set to '$dbName'"
  deleteDBIfExists $dbName
  createDB $dbName
  seed $dbName
  writeENV $dbName
else
  echo "Error: Local instance of FaunaDB is not available. Run docker instance to continue (yarn run-fauna)."
fi