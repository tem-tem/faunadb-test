databaseKey=$1
if [ -z "$databaseKey" ];
then
  echo "FAUNADB_SECRET key not found. Can't seed."
  exit 1
fi

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