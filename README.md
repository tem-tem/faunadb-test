# About

This is a dummy project setup for using a faunadb.

Project is connected to a staging database. Databse key is set in `.env.developemnt` file.

It is expected that each developer will create his own instance of database using `fauna setup-db` (read the instruction below)

## Instruction

### Prerequisites

[Create Fauna account](https://dashboard.fauna.com/accounts/register)

[Install fauna-shell and login](https://github.com/fauna/fauna-shell#fauna-shell)

### Setup

Run `yarn setup-seed-db` to create and seed your own development database, and that's it.

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
