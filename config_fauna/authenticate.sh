read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

if ! command -v fauna;
then
  echo 'fauna-shell not found. Installing it...'
  npm install -g fauna-shell;
fi

key=$(read_var FAUNADB_SECRET .env.development)

echo "$key" | fauna cloud-login

