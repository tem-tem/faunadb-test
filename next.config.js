const dotenvLoad = require("dotenv-load");

module.exports = {
  env: {
    FAUNADB_SECRET: process.env.FAUNADB_SECRET,
    FAUNADB_SECRET_CURRENT: process.env.FAUNADB_SECRET_CURRENT
  }
};
