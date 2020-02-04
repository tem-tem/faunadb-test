# About

This is a dummy project setup for using a faunadb.

Project is connected to a staging database. Databse key is set in `.env.developemnt` file.

It is expected that each developer will create his own instance of database using `fauna setup-db` (read the instruction below)

## Instruction

### Prerequisites

[Create Fauna account](https://dashboard.fauna.com/accounts/register)
[Install fauna-shell and login](https://github.com/fauna/fauna-shell#fauna-shell)

### Setup

Run `yarn setup-db <database-name>` to create your own instance of database. You can leave `<database-name>` empty, then directory name will be used as a database name.

Running this command will create and setup a database for you, it also will create a `.env.development.local` file with newly created secret-key. It will be used over `.env.development`. So, if you'd want to connect to a staging databse, just delete `.env.development.local`.

## Details

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
