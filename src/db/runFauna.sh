if command -v docker; then
  if docker image ls | grep 'fauna/faunadb';
  then
    docker run --rm --name faunadb -p 8443:8443 fauna/faunadb
  else
    echo 'fauna/faunadb image not found. (To install run: docker pull fauna/faunadb)'
    exit 1
  fi
else
  echo "Docker Not Found. Try again after installing it."
  exit 1
fi