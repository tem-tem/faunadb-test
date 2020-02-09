const dotenvLoad = require("dotenv-load");
dotenvLoad("staging");

module.exports = {
  env: {
    FAUNADB_SECRET: process.env.FAUNADB_SECRET,
    FAUNADB_SECRET_CURRENT: process.env.FAUNADB_SECRET_CURRENT
  }
};
