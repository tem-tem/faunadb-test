# About

This is a dummy project setup for using a faunadb.

Project is connected to a staging database. Databse key is set in `.env.developemnt` file.

It is expected that each developer will create his own instance of database using `fauna setup-db` (read the instruction below)

## Instruction

### Prerequisites

[Create Fauna account](https://dashboard.fauna.com/accounts/register)

[Install fauna-shell and login](https://github.com/fauna/fauna-shell#fauna-shell)

### Setup

Run `yarn setup-seed-db` to create and seed your own development database.

#### Semi-Manual Setup

The `yarn setup-seed-db` just runs 2 commands: `yarn setup-db && yarn seed-db`. It is possible to run them separately.

##### `yarn setup-db`

What it does:

1. creates your own instance of database using your fauna account
1. creates `.env.development.local` with database-key, wich will be used over `.env.development`
1. uploads faunadb resolvers (Our schema has bulk-create-mutation. This mutation isn’t created by Fauna automatically (though it is ticketed feature request), so custom resolver has to be defined for it. [Blogpost](https://www.freecodecamp.org/news/how-to-use-faunadb/))
1. uploads graphQL schema

##### `yarn seed-db`

What it does:

1. reads database key from `.env.development.local`
1. runs `src/db/seed.js`
1. sends seed to your own database

## Details

> TODO: replace with graphQL

Project uses [faunadb-js driver](https://github.com/fauna/faunadb-js) to connect, and manage database. It uses env variables from dot-env files, to configure itself.

To use `faunadb-js` in a project, a `clinet` should be created. Study code for an example: [setting up fauna-client](https://github.com/tem-tem/faunadb-test/blob/master/src/helpers/faunaConfig.js), and [calling collections](https://github.com/tem-tem/faunadb-test/blob/5a7111151637b15e3b15ab5843a422d11791504e/pages/index.js#L10-L21)

Local env variables are configured using `dotenv-load`:

```js
// next.config.js
const dotenvLoad = require("dotenv-load");
dotenvLoad();

module.exports = {
  env: {
    FAUNADB_SECRET: process.env.FAUNADB_SECRET
  }
};
```
