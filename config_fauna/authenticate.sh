read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

key=$(read_var FAUNADB_SECRET .env.development)

echo "$key" | fauna cloud-login

