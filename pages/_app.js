import { ConfigProvider } from "../src/helpers/configContext";
import { genFaunaClient } from "../src/helpers/faunaConfig";
import { SWRConfig } from "swr";
import { GraphQLClient } from "graphql-request";

const endpoint = "https://graphql.fauna.com/graphql";
console.log(process);
const dbKey = process.env.FAUNADB_SECRET_CURRENT || process.env.FAUNADB_SECRET;
const graphQLClient = new GraphQLClient(endpoint, {
  headers: {
    authorization: `Bearer ${dbKey}`
  }
});

const fetcher = query => graphQLClient.request(query);

function MyApp({ Component, pageProps }) {
  const faunaClient = genFaunaClient();
  return (
    <ConfigProvider faunaClient={faunaClient}>
      <SWRConfig value={{ fetcher }}>
        <Component {...pageProps} />
      </SWRConfig>
    </ConfigProvider>
  );
}

export default MyApp;
