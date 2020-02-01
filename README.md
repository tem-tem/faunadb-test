# About

This is a dummy project that shows how to run local instance of faunadb for development environment.

If setted up correctly, the project will use production instance of fauna on production environment, and local instance on development environment.

It is assumed that you already have docker installed.

## How-to

### Set up

> TODO: add error handling to scripts

> TODO: separate db-setup and seed

Run these two commands to set up a local faunadb.

1. `yarn run-fauna`. Then don't close the terminal instance. Note that everytime a local instance of FaunaDB is shut down, all of its databases will be deleted.

2. `yarn setupdb <database-name>`. This will delete (if already exists), create and seed database, and then create configured `.env`. If `database-name` is not passed, current dir name will be set as the name.

scripts are located in `/src/db/`

### Seed

Seeds are in `/src/db/seed.fql`.

[Examples](https://docs.fauna.com/fauna/current/start/cloud#shell) from doc
TODO: add guides to seeding

## How-to for Manual Setup

### Setting up a local instance

\*Download image: `docker pull fauna/faunadb`

Run Local Instance: `docker run --rm --name faunadb -p 8443:8443 fauna/faunadb`. Then leave it as it is, and continue in a new terminal instance.

\*Add Local Endpoint: `fauna add-endpoint "http:/localhost:8443”`
(You will be prompted to enter "Endpoint Key", enter **secret** — this is the default key for local instance)

\*See if endpoint has been added: `fauna list-endpoints`

\*Set local endpoint as a default one: `fauna default-endpoint localhost`

_\* - do it only on first setup._

[Full Instructions](https://gist.github.com/CaryBourgeois/ebe08f8819fc1904523e360746a94bae)

### Creating a database

Note that everytime a local instance of FaunaDB is shut down, all of its data will be wiped.

1. Create db w/ the same name as prod one: `fauna create-database my_db`

1. Start shell for this db: `fauna shell my_db`

1. Create test class:

```bash
my_app> CreateClass({ name: "posts" })
{ ref: Class("posts"),
  ts: 1532624109799742,
  history_days: 30,
  name: 'posts' }

```

Then exit shell, create key for this db: `fauna create-key my_db`. And put it in `.env` file.

### Setting up a project

Project uses [faunadb-js driver](https://github.com/fauna/faunadb-js) to connect, and manage database. It uses env variables listed below in `.env` file, to configure itself. To use `faunadb-js` in project, a `clinet` should be created. Study code for an example: [setting up fauna-client](https://github.com/tem-tem/faunadb-test/blob/master/src/helpers/faunaConfig.js), and [calling collections](https://github.com/tem-tem/faunadb-test/blob/5a7111151637b15e3b15ab5843a422d11791504e/pages/index.js#L10-L21)

Local `.env.development` file:

```.env
FAUNADB_SECRET=fnADjUPMlhACAA5VPaxP5r8tesZb0j3eMMJsaAug
FAUNA_DOMAIN=localhost
FAUNA_SCHEME=http
FAUNA_PORT=8443
FAUNA_ROOT_KEY=secret
```

_When deploying to production, you only need to set FAUNADB_SECRET variable, the rest of it are set by default_

Local env variables are configured using `dotenv-load`:

```js
// next.config.js
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
```
