import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, Button } from 'react-native';
import { useDispatch, useSelector } from 'react-redux';
import { fetchTransactions } from '../store/slices/transactionSlice';
import { RootState } from '../store/store';

interface Transaction {
  transactionId: string;
  date: string;
  amount: number;
  description: string;
}

const TransactionListScreen = ({ route }) => {
  const { accountId } = route.params;
  const dispatch = useDispatch();
  const transactions = useSelector((state: RootState) => state.transaction.transactions);
  const loading = useSelector((state: RootState) => state.transaction.loading);
  const error = useSelector((state: RootState) => state.transaction.error);
  const [offset, setOffset] = useState(0);
  const limit = 20;

  useEffect(() => {
    dispatch(fetchTransactions({ accountId, limit, offset }));
  }, [accountId, dispatch, offset, limit]);

  const loadMore = () => {
    setOffset(prevOffset => prevOffset + 20);
  };

  if (loading) {
    return <Text>Loading transactions...</Text>;
  }

  if (error) {
    return <Text>Error: {error}</Text>;
  }

  return (
    <View>
      <Text>Transaction List for Account: {accountId}</Text>
      <FlatList
        data={transactions}
        keyExtractor={(item) => item.transactionId}
        renderItem={({ item }) => (
          <View>
            <Text>Date: {item.date}</Text>
            <Text>Amount: {item.amount}</Text>
            <Text>Description: {item.description}</Text>
          </View>
        )}
      />
      <Button title="Load More" onPress={loadMore} />
    </View>
  );
};

export default TransactionListScreen;
