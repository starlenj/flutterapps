import React, { useEffect } from 'react';
import { SafeAreaView, StyleSheet, Text } from 'react-native';
import { openDatabase, createTables, closeDatabase } from './db';
import HabitListScreen from './screens/HabitListScreen';

const App = () => {
  useEffect(() => {
    const db = openDatabase();
    createTables(db);

    return () => {
      closeDatabase(db);
    };
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <HabitListScreen />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default App;
