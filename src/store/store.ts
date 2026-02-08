import { configureStore } from '@reduxjs/toolkit';
import accountReducer from './slices/accountSlice';
import transactionReducer from './slices/transactionSlice';

const store = configureStore({
  reducer: {
    account: accountReducer,
    transaction: transactionReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

export default store;