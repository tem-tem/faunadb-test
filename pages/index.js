import Head from "next/head";
import { query as q } from "faunadb";
import { useState, useContext } from "react";
import { ConfigContext } from "../src/helpers/configContext";
import useSWR from "swr";

function App() {
  const { faunaClient } = useContext(ConfigContext);
  const [cols, setCols] = useState([]);

  const listCollections = () => {
    if (!faunaClient) return;
    setCols([]);
    faunaClient
      .paginate(q.Collections())
      .map(ref => {
        return q.Get(ref);
      })
      .each(page => {
        setCols(c => c.concat(page));
      });
  };
  const s = JSON.stringify(process.env.ENVS);

  const [shouldFetch, setShouldFetch] = useState(false);
  const { data } = useSWR(
    shouldFetch
      ? `{
      allUsers {
        data {
          username
        }
      }
    }`
      : null
  );
  console.log(process.env);

  const allUsers = data && data.allUsers.data;

  return (
    <div style={{ maxWidth: 600, padding: 16 }}>
      <Head>
        <title>FaunaDB ZEIT App</title>
      </Head>

      <div>{s}</div>

      <div>
        <h2>Fetch users with SWR and graphql-request</h2>
        <button onClick={() => setShouldFetch(true)}>Fetch</button>
        <div>
          {allUsers &&
            allUsers.map(u => <div key={u.username}>{u.username}</div>)}
        </div>
      </div>

      <br />

      <h2>Fetch Collections with faunadb-js driver: </h2>
      <button onClick={listCollections}>Fetch</button>
      <>
        {cols.length > 0 ? (
          <ul>
            {cols.map(({ name }) => (
              <li key={name}>{name}</li>
            ))}
          </ul>
        ) : (
          <h5>No Collections</h5>
        )}
      </>
    </div>
  );
}

export default App;
