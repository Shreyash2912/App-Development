# Language of the Day App – Flutter + Firebase  


---

## 📌 Overview
A modern and lightweight **language-learning mobile application** created using **Flutter** and **Firebase**.  
The app displays a **Language of the Day**, daily challenges, practice questions, and a complete **Premium (VIP)** unlock system controlled via **Firestore feature flags**.

---

## 🚀 Features

### ✅ Authentication
- Email/Password login  
- Signup creates Firestore user document  
- User roles:
  - `user`
  - `admin` (professor / student admin)

### ✅ Premium (VIP) System
Firestore default user fields:
```json
role: "user",
premium: false
```

- Unlock VIP by setting `premium: true`
- Shows Upsell page for non-premium users
- VIP removes ads and unlocks unlimited practice

### ✅ Feature Flags (Firestore Controlled)
Stored under:
```
features/newUI  → true/false
features/premiumContent → true/false
```
Allows enabling/disabling features **without updating the app**.

### ✅ Daily Challenge & Practice
- Auto-generated questions  
- Smooth animations  
- VIP-only enhanced challenges  

### ✅ Admin Panel
Visible only when:
```
role == "admin"
```

Admin can:
- Toggle premium  
- Update feature flags  
- Manage user roles  

---

## 🔧 Setup Instructions

### **1️⃣ Install dependencies**
```
flutter pub get
```

### **2️⃣ Add Firebase configuration files**
```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

### **3️⃣ Initialize Firebase**
```
flutterfire configure
```

### **4️⃣ Run the app**
```
flutter run
```

---

## 🔐 Test Admin Accounts

### **Professor Admin**
```
Email: vpg@gmail.com
Password: 987654
```

### **Student Admin**
```
Email: shreyashkerkar@gmail.com
Password: shreyash
```

### **Test User (Non-Admin)**
```
Email: shreyashkerkar1655@gmail.com
Password: 123456
```

Use this for:
- VIP gating  
- Upsell flow  
- Feature flags testing  

---

## ⭐ VIP Upsell Flow

1. Login with non-premium account  
2. Navigate:
```
Home → Practice → Premium Questions
```
3. App detects:
```
premium == false
```
4. Displays VIP Upsell Screen  
5. To grant VIP:
```
Firestore → users/{uid}
premium: true
```
Restart the app → VIP unlocked

---

## 👑 VIP-Only Features

| Feature               | Free | VIP |
|----------------------|:----:|:---:|
| Daily Challenge      |  ✔   | ⭐ Enhanced |
| Practice Questions   |  Limited | Unlimited |
| New UI (feature flag) |  ❌  | ✔ |
| Premium Content      |  ❌  | ✔ |
| Ads                  |  ❌  | Removed |

---

## 🧪 Testing (Flutter Tests)

### Run All Tests
```
flutter test
```

### Test Files Included

| Test File | Description |
|-----------|-------------|
| **signup_firestore_test.dart** | User doc saved with role:user & premium:false |
| **admin_panel_test.dart** | Admin Panel hidden for normal users |
| **premium_gating_test.dart** | Ensures Premium UI is hidden for VIP |
| **auth_test.dar** | Ensures if the authentication is working for users |

---

## 🖼 Screenshots


-[Home Page](outputs/Home.jpeg)
-[Practice Page](outputs/Practice.jpeg)
-[Premium Page](outputs/Premium.jpeg)
-[Admin Page](outputs/Admin.jpeg)




## 📦 APK Download

[Language-of-the-day-app (Google Drive)](https://drive.google.com/file/d/1rPR3AjPWB3kbD5_Qcx2eWcn3G2GnWxIy/view?usp=sharing)

---

## 🎥 Output Videos

- [Output Video 1](https://drive.google.com/file/d/1PMb3aJ_ZZ0ouzyj3JygCfKMHQtpPQXDc/view?usp=sharing)  
- [Output Video 2](https://drive.google.com/file/d/1gI8H3BzIUbAt9se5VXeog-RW3gtgtD7y/view?usp=drive_link)

---

## 📘 Mini Project Details

### **App Title**  
```
Language of the Day Learning App
```

### **Technologies Used**
- Flutter (Dart)  
- Firebase Authentication  
- Cloud Firestore  
- Provider Architecture  
- REST API (LibreTranslate / Custom)  
- Flutter Widget Testing  

### **Short Description**
Lingo is a modern language-learning app that displays a **Language of the Day**, daily challenges, and practice sessions.  
It includes a VIP system, admin panel, and feature flags fully managed through Firebase.

### **Test Credentials**
```
Admin:
Professor → vpg@gmail.com / 1234
Student Admin → shreyashkerkar@gmail.com

User:
shreyashkerkar1655@gmail.com / 123456
```

---

## 🏁 Result
Successfully developed a **Flutter + Firebase** app with:
- User Authentication  
- Premium (VIP) Unlock System  
- Feature Flag Control  
- Admin Panel  
- Daily Challenge & Practice  
- Mocked tests running without Firebase  

The application is **secure, scalable, and production-ready**.

---

