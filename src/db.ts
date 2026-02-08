import SQLite from 'react-native-sqlite-storage';

const dbName = 'habits.db';

export const openDatabase = () => {
  return SQLite.openDatabase({
    name: dbName,
    location: 'default',
  });
};

export const createTables = (db: SQLite.Database) => {
  db.transaction((tx) => {
    tx.executeSql(
      'CREATE TABLE IF NOT EXISTS habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        frequency TEXT
      )'
    );

    tx.executeSql(
      'CREATE TABLE IF NOT EXISTS habit_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        completed INTEGER,
        FOREIGN KEY (habit_id) REFERENCES habits(id)
      )'
    );
  });
};

export const closeDatabase = (db: SQLite.Database) => {
  db.close();
};
