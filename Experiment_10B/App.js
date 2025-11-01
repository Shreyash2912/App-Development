import React, { useState, useEffect } from "react";
import {
  StyleSheet,
  Text,
  View,
  TextInput,
  TouchableOpacity,
  FlatList,
  SafeAreaView,
  Keyboard,
  ActivityIndicator,
} from "react-native";
import { db } from "./firebaseConfig";
import {
  collection,
  addDoc,
  deleteDoc,
  doc,
  onSnapshot,
  updateDoc,
  serverTimestamp,
  query,
  orderBy,
} from "firebase/firestore";

export default function App() {
  const [task, setTask] = useState("");
  const [taskList, setTaskList] = useState([]);
  const [loading, setLoading] = useState(true);

  // 🔥 Real-time listener
  useEffect(() => {
    const q = query(collection(db, "tasks"), orderBy("createdAt", "desc"));
    const unsubscribe = onSnapshot(
      q,
      (snapshot) => {
        const tasks = snapshot.docs.map((doc) => ({
          id: doc.id,
          ...doc.data(),
        }));
        console.log("✅ Tasks loaded:", tasks);
        setTaskList(tasks);
        setLoading(false);
      },
      (error) => {
        console.error("❌ Firestore listen error:", error);
      }
    );

    return () => unsubscribe();
  }, []);

  // ➕ Add Task
  const handleAddTask = async () => {
    if (task.trim().length > 0) {
      try {
        await addDoc(collection(db, "tasks"), {
          name: task.trim(),
          completed: false,
          createdAt: serverTimestamp(), // ✅ Correct way
        });
        setTask("");
        Keyboard.dismiss();
      } catch (error) {
        console.error("❌ Error adding task:", error);
      }
    }
  };

  // ✅ Toggle complete
  const handleToggleTask = async (id, currentStatus) => {
    const taskRef = doc(db, "tasks", id);
    await updateDoc(taskRef, { completed: !currentStatus });
  };

  // 🗑️ Delete task
  const handleDeleteTask = async (id) => {
    const taskRef = doc(db, "tasks", id);
    await deleteDoc(taskRef);
  };

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>🔥 Firebase To-Do List</Text>

      <View style={styles.inputContainer}>
        <TextInput
          style={styles.input}
          placeholder="Enter a task..."
          value={task}
          onChangeText={setTask}
        />
        <TouchableOpacity style={styles.addButton} onPress={handleAddTask}>
          <Text style={styles.addButtonText}>Add</Text>
        </TouchableOpacity>
      </View>

      {loading ? (
        <ActivityIndicator size="large" color="#007bff" />
      ) : taskList.length === 0 ? (
        <Text style={styles.emptyText}>No tasks yet 🚀</Text>
      ) : (
        <FlatList
          data={taskList}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <View style={styles.taskItem}>
              <TouchableOpacity
                style={styles.checkbox}
                onPress={() => handleToggleTask(item.id, item.completed)}
              >
                {item.completed && <Text style={styles.checkmark}>✅</Text>}
              </TouchableOpacity>
              <Text
                style={[styles.taskText, item.completed && styles.completedTask]}
              >
                {item.name}
              </Text>
              <TouchableOpacity onPress={() => handleDeleteTask(item.id)}>
                <Text style={styles.deleteText}>❌</Text>
              </TouchableOpacity>
            </View>
          )}
        />
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
    paddingTop: 50,
    paddingHorizontal: 20,
  },
  title: {
    fontSize: 26,
    fontWeight: "bold",
    color: "#333",
    textAlign: "center",
    marginBottom: 20,
  },
  inputContainer: {
    flexDirection: "row",
    marginBottom: 20,
  },
  input: {
    flex: 1,
    borderWidth: 1,
    borderColor: "#ccc",
    padding: 12,
    borderRadius: 8,
    backgroundColor: "#fff",
    marginRight: 10,
    fontSize: 16,
  },
  addButton: {
    backgroundColor: "#007bff",
    paddingHorizontal: 20,
    borderRadius: 8,
    justifyContent: "center",
    alignItems: "center",
  },
  addButtonText: {
    color: "#fff",
    fontWeight: "bold",
    fontSize: 16,
  },
  taskItem: {
    backgroundColor: "#fff",
    padding: 15,
    borderRadius: 8,
    flexDirection: "row",
    alignItems: "center",
    marginBottom: 10,
    elevation: 2,
  },
  checkbox: {
    width: 24,
    height: 24,
    borderWidth: 2,
    borderColor: "#007bff",
    borderRadius: 4,
    justifyContent: "center",
    alignItems: "center",
    marginRight: 15,
  },
  checkmark: { fontSize: 16 },
  taskText: { flex: 1, fontSize: 18 },
  completedTask: { textDecorationLine: "line-through", color: "gray" },
  deleteText: { fontSize: 18, marginLeft: 10 },
  emptyText: {
    textAlign: "center",
    fontSize: 16,
    color: "gray",
    marginTop: 30,
  },
});
