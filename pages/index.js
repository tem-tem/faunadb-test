import Head from "next/head";
import { query as q } from "faunadb";
import { useState, useContext } from "react";
import { ConfigContext } from "../src/helpers/configContext";

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
  const s = String(process.env.FAUNADB_SECRET);

  return (
    <div style={{ maxWidth: 600, padding: 16 }}>
      <Head>
        <title>FaunaDB ZEIT App</title>
      </Head>

      <div>
        secret:
        {s}
      </div>
      <button onClick={listCollections}>List Collections</button>
      <h1>FaunaDB ZEIT Integration</h1>
      <>
        <h2>Collections</h2>
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
