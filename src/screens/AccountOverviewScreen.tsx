import React, { useEffect } from 'react';
import { View, Text, FlatList, TouchableOpacity } from 'react-native';
import { useDispatch, useSelector } from 'react-redux';
import { fetchAccounts } from '../store/slices/accountSlice';
import { RootState } from '../store/store';

interface Account {
  accountId: string;
  accountType: string;
  balance: number;
}

const AccountOverviewScreen = () => {
  const dispatch = useDispatch();
  const accounts = useSelector((state: RootState) => state.account.accounts);
  const loading = useSelector((state: RootState) => state.account.loading);
  const error = useSelector((state: RootState) => state.account.error);

  useEffect(() => {
    dispatch(fetchAccounts());
  }, [dispatch]);

  if (loading) {
    return <Text>Loading accounts...</Text>;
  }

  if (error) {
    return <Text>Error: {error}</Text>;
  }

  return (
    <View>
      <Text>Account Overview</Text>
      <FlatList
        data={accounts}
        keyExtractor={(item) => item.accountId}
        renderItem={({ item }) => (
          <TouchableOpacity
            onPress={() => {
              // Navigate to TransactionListScreen with accountId
              console.log("Navigating to transaction list for account: ", item.accountId);
            }}
          >
            <View>
              <Text>{item.accountType}</Text>
              <Text>Balance: {item.balance}</Text>
            </View>
          </TouchableOpacity>
        )}
      />
    </View>
  );
};

export default AccountOverviewScreen;
