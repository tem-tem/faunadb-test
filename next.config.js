const dotenvLoad = require("dotenv-load");
dotenvLoad();

module.exports = {
  env: {
    FAUNADB_SECRET: process.env.FAUNADB_SECRET,
    FAUNADB_SECRET_PREVIEW: process.env.FAUNADB_SECRET_PREVIEW,
    all: process.env
  },
  publicRuntimeConfig: {
    all: process.env
  }
};
