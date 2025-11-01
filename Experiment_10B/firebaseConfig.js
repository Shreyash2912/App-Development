// firebaseConfig.js
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyCikNEl_X1NUN4arpJ58EAisM3y0FSa1lM",
  authDomain: "todolist-2388f.firebaseapp.com",
  projectId: "todolist-2388f",
  storageBucket: "todolist-2388f.firebasestorage.app",
  messagingSenderId: "430462226301",
  appId: "1:430462226301:web:faa3ce4b5fd3eeebb64614",
  measurementId: "G-BR35BNSG79",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
export { db };
