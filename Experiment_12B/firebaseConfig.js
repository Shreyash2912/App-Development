// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyA7CNcqY-AmP6__5ZbyYtSPEOI0wHbTGg4",
  authDomain: "authreact-d7e4a.firebaseapp.com",
  projectId: "authreact-d7e4a",
  storageBucket: "authreact-d7e4a.firebasestorage.app",
  messagingSenderId: "448435943803",
  appId: "1:448435943803:web:b85926840898215af265de",
  measurementId: "G-BTLRVSQC3L"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);