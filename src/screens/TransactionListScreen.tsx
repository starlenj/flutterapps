import React, { useEffect, useState } from 'react';
import { View, Text, FlatList, Button } from 'react-native';
import { useAppDispatch, useAppSelector } from '../store/hooks';
import { fetchTransactions } from '../store/slices/transactionSlice';
import { Paper } from 'react-native-paper';

interface TransactionItemProps {
  transaction: { transactionId: string; date: string; amount: number; description: string };
}

const TransactionItem = ({ transaction }: TransactionItemProps) => {
  return (
    <Paper.Card style={{ margin: 5, padding: 10 }}>
      <Text>Date: {transaction.date}</Text>
      <Text>Amount: ${transaction.amount}</Text>
      <Text>Description: {transaction.description}</Text>
    </Paper.Card>
  );
};

const TransactionListScreen = ({ route, navigation }) => {
  const dispatch = useAppDispatch();
  const transactions = useAppSelector((state) => state.transaction.transactions);
  const loading = useAppSelector((state) => state.transaction.loading);
  const error = useAppSelector((state) => state.transaction.error);
  const accountId = route.params.accountId;
  const [offset, setOffset] = useState(0);
  const limit = 20;

  useEffect(() => {
    dispatch(fetchTransactions(accountId, limit, offset));
  }, [dispatch, accountId, offset]);

  const loadMore = () => {
    setOffset(prevOffset => prevOffset + 20);
  };

  if (loading) {
    return <Text>Loading transactions...</Text>;
  }

  if (error) {
    return <Text>Error loading transactions: {error}</Text>;
  }

  return (
    <View>
      <Text>Transaction List for Account: {accountId}</Text>
      <FlatList
        data={transactions}
        renderItem={({ item }) => <TransactionItem transaction={item} />}
        keyExtractor={(item) => item.transactionId}
      />
      <Button title="Load More" onPress={loadMore} />
    </View>
  );
};

export default TransactionListScreen;