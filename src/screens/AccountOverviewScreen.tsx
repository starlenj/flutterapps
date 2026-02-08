import React, { useEffect } from 'react';
import { View, Text, FlatList, TouchableOpacity } from 'react-native';
import { useAppDispatch, useAppSelector } from '../store/hooks';
import { fetchAccounts } from '../store/slices/accountSlice';
import { Paper } from 'react-native-paper';

interface AccountItemProps {
  account: { accountId: string; accountType: string; balance: number };
  navigation: any;
}

const AccountItem = ({ account, navigation }: AccountItemProps) => {
  return (
    <TouchableOpacity
      onPress={() => navigation.navigate('TransactionList', { accountId: account.accountId })}>
      <Paper.Card style={{ margin: 5, padding: 10 }}>
        <Text>{account.accountType}</Text>
        <Text>Balance: ${account.balance}</Text>
      </Paper.Card>
    </TouchableOpacity>
  );
};

const AccountOverviewScreen = () => {
  const dispatch = useAppDispatch();
  const accounts = useAppSelector((state) => state.account.accounts);
  const loading = useAppSelector((state) => state.account.loading);
  const error = useAppSelector((state) => state.account.error);

  useEffect(() => {
    dispatch(fetchAccounts());
  }, [dispatch]);

  if (loading) {
    return <Text>Loading accounts...</Text>;
  }

  if (error) {
    return <Text>Error loading accounts: {error}</Text>;
  }

  return (
    <View>
      <Text>Account Overview</Text>
      <FlatList
        data={accounts}
        renderItem={({ item }) => <AccountItem account={item} navigation={navigation} />}
        keyExtractor={(item) => item.accountId}
      />
    </View>
  );
};

export default AccountOverviewScreen;