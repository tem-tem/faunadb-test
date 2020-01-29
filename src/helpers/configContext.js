import React, { createContext } from "react";

export const ConfigContext = createContext({
  faunaClient: null
});

export const ConfigProvider = ({ faunaClient, children }) => {
  return (
    <ConfigContext.Provider value={{ faunaClient }}>
      {children}
    </ConfigContext.Provider>
  );
};
