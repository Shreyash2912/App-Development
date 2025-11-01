# Experiment 12: Implement User Authentication with Firebase in React Native

---

## Aim
To develop and implement **user authentication using Firebase** in a **React Native (Expo)** app.  
The app supports **Email/Password**, **Google Sign-In**, and **Phone Number Verification**, along with a **Forgot Password** option and **session management** using Firebase.

---

## Steps Followed

1. **Firebase Setup**
   - Created a new project in [Firebase Console](https://console.firebase.google.com/).  
   - Enabled the following sign-in methods under **Authentication → Sign-in method**:
     - **Email/Password**
     - **Google**
     - **Phone Number**
   - Registered the React Native app named **authentication** in Firebase and downloaded:
     - `google-services.json` → placed inside `android/app/`
     - `GoogleService-Info.plist` → placed inside `ios/`
   - Added **SHA-1 and SHA-256 keys** in Firebase for **Google Sign-In** authentication.
   - Added **test phone numbers** for testing **Phone OTP verification**.

---

2. **React Native Project Setup**
   - Created a new Expo project:
     ```bash
     npx create-expo-app authentication
     ```
   - Installed required dependencies:
     ```bash
     npm install firebase expo-auth-session expo-web-browser @react-navigation/native @react-navigation/native-stack
     ```
   - Installed navigation dependencies:
     ```bash
     npx expo install react-native-screens react-native-safe-area-context
     ```

---

3. **Firebase Configuration**
   - Created a `firebaseConfig.js` file and initialized Firebase:
     ```javascript
     import { initializeApp } from "firebase/app";
     import { getAuth } from "firebase/auth";

     const firebaseConfig = {
       apiKey: "YOUR_API_KEY",
       authDomain: "YOUR_AUTH_DOMAIN",
       projectId: "YOUR_PROJECT_ID",
       storageBucket: "YOUR_STORAGE_BUCKET",
       messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
       appId: "YOUR_APP_ID",
     };

     const app = initializeApp(firebaseConfig);
     export const auth = getAuth(app);
     ```
   - Enabled Firebase Authentication and Firestore from the Firebase Console.

---

4. **App Structure**
   - Created the following files inside the `screens/` folder:
     - `LoginScreen.js` → Handles Email/Password login and navigation  
     - `SignupScreen.js` → Allows new user registration  
     - `HomeScreen.js` → Protected screen after login  
     - `ForgotPasswordScreen.js` → Sends password reset email  
     - `GoogleSignIn.js` → Implements Google Sign-In using OAuth  
     - `PhoneSignInScreen.js` → Handles Phone OTP authentication  
   - Created `App.js` to handle navigation between all screens.

---

5. **Authentication Functionalities**
   - **Email/Password Authentication**
     - Used Firebase methods:
       ```javascript
       createUserWithEmailAndPassword(auth, email, password)
       signInWithEmailAndPassword(auth, email, password)
       ```
     - Added password reset using:
       ```javascript
       sendPasswordResetEmail(auth, email)
       ```
   - **Google Sign-In**
     - Integrated using Expo’s AuthSession:
       ```javascript
       import * as Google from "expo-auth-session/providers/google";
       import * as WebBrowser from "expo-web-browser";
       ```
     - Used `GoogleAuthProvider.credential()` for Firebase sign-in.
   - **Phone Number Authentication**
     - Implemented OTP verification using:
       ```javascript
       import { signInWithPhoneNumber, RecaptchaVerifier } from "firebase/auth";
       ```
     - Verified OTP to sign in securely.
   - **Logout**
     - Used:
       ```javascript
       signOut(auth)
       ```
   - **Session Management**
     - Managed using:
       ```javascript
       onAuthStateChanged(auth, user => { ... })
       ```
     - Automatically navigates between login and home screens based on authentication state.

---

6. **UI Design**
   - Used React Native components for a clean, user-friendly interface:
     - `TextInput`, `TouchableOpacity`, `Alert`, `View`, `Text`
   - Created simple screens for:
     - Login / Signup  
     - Google Sign-In  
     - Phone OTP Login  
     - Forgot Password  
     - Home Screen  
   - Used **Tailwind CSS (optional)** or **StyleSheet** for styling.

---

7. **Testing**
   - Ran the app using Expo:
     ```bash
     npx expo start
     ```
   - Tested on both **Android Emulator** and **Expo Go** app.
   - Verified the following:
     - User registration via Email/Password  
     - Login with Email/Password  
     - Google Sign-In flow  
     - Phone Number OTP verification  
     - Password reset email  
     - Logout and session auto-detection  
   - Checked **Firebase Console → Authentication → Users** to confirm user entries.

---

## Source Code
- [App.js](./App.js)  
- [firebaseConfig.js](./firebaseConfig.js)  
- [LoginScreen.js](./LoginScreen.js)  
- [SignupScreen.js](/.SignupScreen.js)  
- [HomeScreen.js](./HomeScreen.js)  
- [GoogleSignIn.js](./GoogleSignIn.js)  
- [PhoneSignInScreen.js](./PhoneSignInScreen.js)  
- [ForgotPasswordScreen.js](./ForgotPasswordScreen.js)

---

## Expected Output
- **Login Screen:** User can log in using Email/Password, Google, or Phone Number.  
- **Signup Screen:** New users can register using Email and Password.  
- **Phone OTP Screen:** Sends and verifies OTP for login.  
- **Forgot Password Screen:** Sends reset email for password recovery.  
- **Home Screen:** Displays upon successful login.  
- **Logout:** Signs user out and navigates back to Login page.  
- **Session Handling:** Automatically detects and maintains login state.

---

## Result
Successfully developed a **React Native app** named **Authentication** integrating **Firebase Authentication** with:
- **Email/Password Sign-In**
- **Google Sign-In**
- **Phone Number OTP Verification**
- **Forgot Password Feature**
- **Automatic Session Management**

The app provides a secure, efficient, and user-friendly authentication system using Firebase services.

---