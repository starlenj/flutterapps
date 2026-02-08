import axios from 'axios';

const BASE_URL = 'http://your-api-url.com/api/v1'; // Replace with your actual API URL

const api = axios.create({
  baseURL: BASE_URL,
  headers: {
    'Authorization': 'Bearer ' + 'your_jwt_token', // Replace with dynamic JWT
    'Content-Type': 'application/json',
  },
});

export const getAccounts = async () => {
  try {
    const response = await api.get('/accounts');
    return response.data;
  } catch (error: any) {
    throw new Error(`Failed to fetch accounts: ${error.message}`);
  }
};

export const getTransactions = async (accountId: string, limit: number, offset: number) => {
  try {
    const response = await api.get(`/transactions?accountId=${accountId}&limit=${limit}&offset=${offset}`);
    return response.data;
  } catch (error: any) {
    throw new Error(`Failed to fetch transactions: ${error.message}`);
  }
};
