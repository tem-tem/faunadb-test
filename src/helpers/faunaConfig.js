import faunadb from "faunadb";

const faunaOptions = {
  secret: process.env.FAUNADB_SECRET
};
if (process.env.FAUNA_DOMAIN) {
  faunaOptions.domain = process.env.FAUNA_DOMAIN;
}
if (process.env.FAUNA_SCHEME) {
  faunaOptions.scheme = process.env.FAUNA_SCHEME;
}
if (process.env.FAUNA_PORT) {
  faunaOptions.port = process.env.FAUNA_PORT;
}

export const genFaunaClient = () => {
  console.log(faunaOptions);
  const faunaClient = new faunadb.Client(faunaOptions);
  return faunaClient;
};
