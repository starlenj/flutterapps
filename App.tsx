import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import AccountOverviewScreen from './src/screens/AccountOverviewScreen';
import TransactionListScreen from './src/screens/TransactionListScreen';
import { Provider } from 'react-redux';
import store from './src/store/store';

const Stack = createNativeStackNavigator();

const App = () => {
  return (
    <Provider store={store}>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen name="AccountOverview" component={AccountOverviewScreen} />
          <Stack.Screen name="TransactionList" component={TransactionListScreen} />
        </Stack.Navigator>
      </NavigationContainer>
    </Provider>
  );
};

export default App;