import axios from 'axios';

const BASE_URL = 'https://your-api-url.com/api/v1'; // Replace with your actual API URL

const api = axios.create({
  baseURL: BASE_URL,
});

api.interceptors.request.use(
  (config) => {
    // Get the token from storage (e.g., AsyncStorage)
    const token = 'your_jwt_token'; // Replace with your actual token retrieval logic

    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export const getAccounts = async () => {
  try {
    const response = await api.get('/accounts');
    return response.data;
  } catch (error) {
    throw new Error(`Failed to fetch accounts: ${error.message}`);
  }
};

export const getTransactions = async (accountId: string, limit: number, offset: number) => {
  try {
    const response = await api.get(`/transactions?accountId=${accountId}&limit=${limit}&offset=${offset}`);
    return response.data;
  } catch (error) {
    throw new Error(`Failed to fetch transactions: ${error.message}`);
  }
};
