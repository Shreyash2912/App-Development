# Experiment 12: Implement User Authentication with Firebase in Flutter App

---

## Aim
To develop implement **user authentication using Firebase** in a flutter app.  
The app supports **Email/Password**, **Google Sign-In**, and **Phone Number Verification**, along with a **Forgot Password** option and **session management** using Firebase.

---

## Steps Followed

1. **Firebase Setup**
   - Created a new project in [Firebase Console](https://console.firebase.google.com/).  
   - Enabled the following sign-in methods under **Authentication → Sign-in method**:
     - **Email/Password**
     - **Google**
     - **Phone Number**
   - Registered the Flutter app named **authentication** in Firebase and downloaded:
     - `google-services.json` → placed inside `android/app/`
     - `GoogleService-Info.plist` → placed inside `ios/Runner/`
   - Added **SHA-1 and SHA-256 keys** for Google Sign-In authentication.
   - Added test phone numbers for testing **Phone OTP verification**.

2. **Flutter Project Setup**
   - Created a new Flutter project:
     ```bash
     flutter create authentication
     ```
   - Added Firebase dependencies in `pubspec.yaml`:
     ```yaml
     dependencies:
       firebase_core: ^3.3.0
       firebase_auth: ^5.3.0
       google_sign_in: ^6.2.1
     ```
   - Installed the dependencies using:
     ```bash
     flutter pub get
     ```

3. **Firebase Initialization**
   - Added `firebase_options.dart` for configuration using Firebase CLI:
     ```bash
     flutterfire configure
     ```
   - Initialized Firebase in the `main.dart` file using:
     ```dart
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     ```

4. **App Structure**
   - Created the following files inside `lib/`:
     - `main.dart` → App entry point  
     - `auth_page.dart` → Controls session state using `StreamBuilder`  
     - `login_page.dart` → Handles Email/Password login and navigation  
     - `signup_page.dart` → Allows user registration  
     - `home_page.dart` → Protected screen after login  
     - `google_signin.dart` → Implements Google Sign-In using OAuth  
     - `phone_login.dart` → Implements Phone Number OTP authentication  
     - `forgot_password_page.dart` → Sends password reset email  
     - `firebase_options.dart` → Stores Firebase configuration  

5. **Authentication Functionalities**
   - **Email/Password Authentication**
     - Used Firebase methods:
       - `createUserWithEmailAndPassword()`
       - `signInWithEmailAndPassword()`
     - Added password reset feature using `sendPasswordResetEmail()`.
   - **Google Sign-In**
     - Integrated Google login using `google_sign_in` package.
     - Used `GoogleAuthProvider.credential()` for authentication with Firebase.
   - **Phone Number Authentication**
     - Implemented OTP-based login using `FirebaseAuth.instance.verifyPhoneNumber()`.
     - Verified OTP to sign in the user securely.
   - **Logout**
     - Used `FirebaseAuth.instance.signOut()` and `GoogleSignIn().signOut()` for logout.
   - **Session Management**
     - Controlled using a `StreamBuilder` in `auth_page.dart` to auto-navigate between login and home pages.

6. **UI Design**
   - Designed simple and interactive screens for:
     - Login / Signup
     - Google Sign-In
     - Phone OTP Login
     - Forgot Password
     - Home screen after successful authentication  
   - Used buttons, text fields, and snack bars for better UX.

7. **Testing**
   - Ran the app on both emulator and real device.  
   - Tested:
     - New user registration  
     - Login with Email/Password  
     - Google Sign-In  
     - Phone OTP verification  
     - Forgot Password email reset  
     - Logout functionality  
   - Verified users in **Firebase Console → Authentication → Users**.

---

## Source Code
- [main.dart](./main.dart)  
- [firebase_options.dart](./firebase_options.dart)  
- [auth_page.dart](./auth_service.dart)  
- [login_page.dart](./login_page.dart)   
- [home_page.dart](./home_screen.dart)  
- [phone_login.dart](./login_screen.dart)  

---

## Expected Output
- **Login Screen:** User can log in using Email/Password, Google, or Phone Number.  
- **Signup Screen:** New users can register with Email and Password.  
- **Phone OTP Screen:** Sends OTP and verifies user login.  
- **Forgot Password Screen:** Sends password reset email.  
- **Home Screen:** Displays after successful authentication.  
- **Logout:** Signs the user out and returns to Login page.  
- **Session Handling:** Automatically detects login state and navigates accordingly.
- You can access the output over [here](https://drive.google.com/file/d/1avwPQzPH1OJ6DE_whH4RMZONw2Zm6bQ9/view?usp=drive_link).

---

## Result
Successfully developed a Flutter app named **Authentication** integrating **Firebase Authentication** with:
- **Email/Password Sign-In**
- **Google Sign-In**
- **Phone Number OTP Verification**
- **Forgot Password Feature**
- **Automatic Session Management**


The app provides a complete, secure, and user-friendly authentication system.
