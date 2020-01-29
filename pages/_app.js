import { ConfigProvider } from "../src/helpers/configContext";
import { genFaunaClient } from "../src/helpers/faunaConfig";

function MyApp({ Component, pageProps }) {
  const faunaClient = genFaunaClient();
  return (
    <ConfigProvider faunaClient={faunaClient}>
      <Component {...pageProps} />
    </ConfigProvider>
  );
}

export default MyApp;
