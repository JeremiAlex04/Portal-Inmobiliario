import { createContext, useContext, useState } from 'react';

const CompareContext = createContext(null);

export function CompareProvider({ children }) {
  const [compareList, setCompareList] = useState([]);

  const toggleCompare = (id) => {
    setCompareList(prev => {
      if (prev.includes(id)) {
        return prev.filter(x => x !== id);
      }
      if (prev.length >= 3) {
        return prev; // Máximo 3
      }
      return [...prev, id];
    });
  };

  const removeCompare = (id) => setCompareList(prev => prev.filter(x => x !== id));
  const clearCompare = () => setCompareList([]);

  return (
    <CompareContext.Provider value={{ compareList, toggleCompare, removeCompare, clearCompare }}>
      {children}
    </CompareContext.Provider>
  );
}

export const useCompare = () => useContext(CompareContext);
