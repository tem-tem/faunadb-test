import faunadb from "faunadb";

const faunaOptions = {
  secret: process.env.FAUNADB_SECRET
};

export const genFaunaClient = () => {
  const faunaClient = new faunadb.Client(faunaOptions);
  return faunaClient;
};
