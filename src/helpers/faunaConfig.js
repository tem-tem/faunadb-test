import faunadb from "faunadb";

const env = {
  secret: process.env.FAUNADB_SECRET,
  domain: process.env.FAUNA_DOMAIN,
  scheme: process.env.FAUNA_SCHEME,
  port: process.env.FAUNA_PORT
};

export const genFaunaClient = () => {
  const { domain, scheme, port, secret } = env;
  const faunaClient = new faunadb.Client({
    secret,
    domain,
    scheme,
    port
  });
  return faunaClient;
};
