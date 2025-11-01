// db.js
import * as SQLite from 'expo-sqlite';

const db = SQLite.openDatabase('todolist.db');

export const initDB = () =>
  new Promise((resolve, reject) => {
    db.transaction(tx => {
      tx.executeSql(
        `CREATE TABLE IF NOT EXISTS tasks (
          id INTEGER PRIMARY KEY NOT NULL,
          name TEXT NOT NULL,
          completed INTEGER NOT NULL,
          createdAt TEXT NOT NULL
        );`,
        [],
        () => resolve(),
        (_, err) => { reject(err); return false; }
      );
    });
  });

export const getTasks = () =>
  new Promise((resolve, reject) => {
    db.transaction(tx => {
      tx.executeSql(
        `SELECT * FROM tasks ORDER BY id DESC;`,
        [],
        (_, result) => resolve(result.rows._array),
        (_, err) => { reject(err); return false; }
      );
    });
  });

export const insertTask = (name) =>
  new Promise((resolve, reject) => {
    const now = new Date().toISOString();
    db.transaction(tx => {
      tx.executeSql(
        `INSERT INTO tasks (name, completed, createdAt) VALUES (?, ?, ?);`,
        [name, 0, now],
        (_, result) => resolve(result.insertId),
        (_, err) => { reject(err); return false; }
      );
    });
  });

export const toggleTask = (id, currentCompleted) =>
  new Promise((resolve, reject) => {
    const newVal = currentCompleted ? 0 : 1;
    db.transaction(tx => {
      tx.executeSql(
        `UPDATE tasks SET completed = ? WHERE id = ?;`,
        [newVal, id],
        (_, result) => resolve(result),
        (_, err) => { reject(err); return false; }
      );
    });
  });

export const deleteTask = (id) =>
  new Promise((resolve, reject) => {
    db.transaction(tx => {
      tx.executeSql(
        `DELETE FROM tasks WHERE id = ?;`,
        [id],
        (_, result) => resolve(result),
        (_, err) => { reject(err); return false; }
      );
    });
  });
