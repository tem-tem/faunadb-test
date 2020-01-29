# FaunaDB setup

TODO: consider automating some steps

## Setting up a local instance

(\*)Download image: `docker pull fauna/faunadb`

Run Local Instance: `docker run --rm --name faunadb -p 8443:8443 fauna/faunadb`. Then leave it as it is, and open a new terminal tab.

(\*)Add Local Endpoint: `fauna add-endpoint "http:/localhost:8443”`
(You will be prompted to enter "Endpoint Key", enter **secret** — this is the default key for local instance)

See if endpoint has been added: `fauna list-endpoints`

(\*)Set local endpoint as a default one: `fauna default-endpoint localhost`

(\*) - do it only on first setup.

[Full Instructions](https://gist.github.com/CaryBourgeois/ebe08f8819fc1904523e360746a94bae)

## Creating a database

Note that everytime a local instance of FaunaDB is shut down, all of its data is going to be wiped. These steps are manual just for now, and they will be automated later.

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

## Setting up a project

Project uses [faunadb-js driver](https://github.com/fauna/faunadb-js) to connect, and manage database. It uses env variables listed below in `.env` file, to configure itself.

To use `faunadb-js` in project, a `clinet` should be created. Study code for an example: [setting up fauna-client](https://github.com/tem-tem/faunadb-test/blob/master/src/helpers/faunaConfig.js), and [calling collections](https://github.com/tem-tem/faunadb-test/blob/5a7111151637b15e3b15ab5843a422d11791504e/pages/index.js#L10-L21)

Local `.env.development` file:

```.env
FAUNADB_SECRET=fnADjUPMlhACAA5VPaxP5r8tesZb0j3eMMJsaAug
FAUNA_DOMAIN=localhost
FAUNA_SCHEME=http
FAUNA_PORT=8443
FAUNA_ROOT_KEY=secret
```

_In production, you only need FAUNADB_SECRET, the rest of it is set to work in production by default_

Env variables are handled by `dotenv-load`:

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
