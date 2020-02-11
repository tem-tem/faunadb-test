# About

This is a dummy project setup for using a faunadb.

Project is connected to a staging database. Databse key is set in `.env.development` file.

It is expected that each developer will create his own instance of database using `yarn create-db <db name>`

## Details

Running `yarn create-db <db name>`, creates and seed a db, and writes key to a `.env.development.local`, which will be used instead of `.env.development`.

Schema is in `src/db/schema.gql`

Seeds are in `src/db/seed.js`.

Local env variables are configured using `dotenv-load`:

```js
// next.config.js
const dotenvLoad = require("dotenv-load");
dotenvLoad();

module.exports = {
  env: {
    FAUNADB_SECRET: process.env.FAUNADB_SECRET,
    FAUNADB_SECRET_PREVIEW: process.env.FAUNADB_SECRET_PREVIEW
  }
};
```
