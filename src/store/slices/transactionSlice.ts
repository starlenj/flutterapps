import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { getTransactions } from '../../api/api';

interface Transaction {
  transactionId: string;
  date: string;
  amount: number;
  description: string;
}

interface TransactionState {
  transactions: Transaction[];
  loading: boolean;
  error: string | null;
}

const initialState: TransactionState = {
  transactions: [],
  loading: false,
  error: null,
};

export const fetchTransactions = createAsyncThunk(
  'transaction/fetchTransactions',
  async (params: { accountId: string; limit: number; offset: number }) => {
    const { accountId, limit, offset } = params;
    const transactions = await getTransactions(accountId, limit, offset);
    return transactions;
  }
);

const transactionSlice = createSlice({
  name: 'transaction',
  initialState,
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchTransactions.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchTransactions.fulfilled, (state, action) => {
        state.loading = false;
        state.transactions = action.payload;
      })
      .addCase(fetchTransactions.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch transactions';
      });
  },
});

export default transactionSlice.reducer;
