read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

key=$(read_var FAUNADB_SECRET .env.development.local)
if $1 == "CI"; then key=$(read_var FAUNADB_SECRET .env.development); fi

if [ -z "$key" ]
then
  echo "Error: Couldn't find database key. Try running 'yarn setup-db' or set database key manually to '.env.development.local' in this format:"
  echo "FAUNADB_SECRET=<database-key>"
  exit
fi

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