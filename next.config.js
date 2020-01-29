const dotenvLoad = require("dotenv-load");
dotenvLoad();

module.exports = {
  env: {
    FAUNADB_SECRET: process.env.FAUNADB_SECRET,
    FAUNA_DOMAIN: process.env.FAUNA_DOMAIN,
    FAUNA_SCHEME: process.env.FAUNA_SCHEME,
    FAUNA_PORT: process.env.FAUNA_PORT
  }
};
