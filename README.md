# About

This is a dummy project setup for using a faunadb.

Project is connected to a staging database. Databse key is set in `.env.development` file.

It is expected that each developer will create his own instance of database using `yarn create-db <db name>`

## Details

### Local Development

Run `yarn create-db <db name>`, this will create a db for you on fauna servers. Database is created based on the schema `src/db/schema.gql`, and seeded using `src/db/seed.js`.

A secret key to access your new db will be written to `.env.development.local`, which will be used instead of `.env.development`.

### Deployment

Each deploy will create a preview-db. Commit's sha will be set as db's name.

### handling .env files

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
