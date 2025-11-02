# Experiment 12: Implement User Authentication with Firebase in Android Studio(Java)

---

## Aim
To develop and implement **user authentication using Firebase** in an **Android (Java)** app.  
The app supports **Email/Password**, **Google Sign-In**, and **Phone Number Verification (OTP)**, along with a **Logout** option and **session management** using Firebase Authentication.

---

## Steps Followed

1. **Firebase Setup**
   - Created a new project in [Firebase Console](https://console.firebase.google.com/).  
   - Enabled sign-in methods: **Email/Password**, **Google**, and **Phone Number**.  
   - Downloaded and added `google-services.json` inside the **app/** folder.  
   - Added **SHA-1 and SHA-256 keys** for Google Sign-In.  
   - Added **test phone numbers** for OTP verification under Firebase → Authentication → Sign-in method → Phone.

---

2. **Android Studio Project Setup**
   - Created a new project named **FirebaseAuthApp** in Android Studio.  
   - Configured Firebase using the Firebase Assistant (Tools → Firebase → Authentication → Connect to Firebase).  
   - Added required dependencies for Firebase Authentication and Google Sign-In in Gradle.  
   - Synced the project with Gradle files successfully.

---

3. **Firebase Configuration**
   - Confirmed the correct **package name** in `google-services.json`.  
   - Initialized Firebase Authentication in the app.  
   - Enabled authentication methods in the Firebase Console.

---

4. **App Structure**

   **Java Files**
   - `LoginActivity.java` – Handles Email/Password login.  
   - `RegisterActivity.java` – Allows user registration.  
   - `PhoneAuthActivity.java` – Handles phone number OTP verification.  
   - `GoogleSignInActivity.java` – Implements Google Sign-In using Firebase.  
   - `MainActivity.java` – Displays home screen after successful authentication and includes logout functionality.

   **XML Layouts** 
   - `activity_welcome.xml`  
   - `activity_main.xml`

---

5. **Authentication Functionalities**
   - **Email/Password Authentication:** Used Firebase methods for user sign-up and sign-in.  
   - **Google Sign-In:** Integrated using GoogleSignInClient and FirebaseAuth.  
   - **Phone Number Verification:** Used Firebase PhoneAuthProvider for sending and verifying OTP.  
   - **Logout:** User can sign out using Firebase signOut() method.  
   - **Session Management:** Automatically redirects based on authentication state using FirebaseAuth current user.

---

6. **UI Design**
   - Simple and minimal UI using Android XML layouts.  
   - Includes screens for Login, Registration, Google Sign-In, Phone OTP, and Main (Logout).  
   - User-friendly interface designed using LinearLayout and ConstraintLayout.

---

7. **Testing**
   - Tested the app on both Emulator and Physical Device.  
   - Verified all authentication methods:  
     - Email/Password Registration and Login  
     - Google Sign-In  
     - Phone Number OTP Verification  
     - Logout and Session Management  
   - Confirmed all user entries under Firebase Console → Authentication → Users.

---

## Expected Output
- **Login Screen:** Users can log in using Email/Password, Google, or Phone Number.  
- **Register Screen:** New users can register and create accounts.  
- **Phone OTP Screen:** Sends and verifies OTP for login.  
- **Home Screen:** Displays after successful login with Logout button.  
- **Logout:** Signs user out and navigates back to Login screen.  
- **Session Handling:** Automatically detects and maintains login state.

---

## Result
Successfully developed an **Android app** named **FirebaseAuthApp** integrating **Firebase Authentication** with:
- Email/Password Sign-In  
- Google Sign-In  
- Phone Number OTP Verification  
- Logout and Session Management  

The app provides a secure, efficient, and user-friendly authentication system using **Firebase services**.

---
