import React, { useState } from "react";
import { View, Text, TextInput, TouchableOpacity, StyleSheet } from "react-native";
import { signInWithEmailAndPassword } from "firebase/auth";
import { auth } from "../firebaseConfig";
import { COLORS } from "../theme";
import { useNavigation } from "@react-navigation/native";

export default function SignInScreen() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigation = useNavigation();

  const handleLogin = async () => {
    try {
      await signInWithEmailAndPassword(auth, email, password);
      navigation.replace("Home");
    } catch (error) {
      alert(error.message);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Welcome Back 👋</Text>
      <TextInput
        placeholder="Email"
        value={email}
        onChangeText={setEmail}
        style={styles.input}
        autoCapitalize="none"
      />
      <TextInput
        placeholder="Password"
        secureTextEntry
        value={password}
        onChangeText={setPassword}
        style={styles.input}
      />

      <TouchableOpacity style={styles.button} onPress={handleLogin}>
        <Text style={styles.buttonText}>Login</Text>
      </TouchableOpacity>

      <TouchableOpacity onPress={() => navigation.navigate("ForgotPassword")}>
        <Text style={styles.link}>Forgot Password?</Text>
      </TouchableOpacity>

      <TouchableOpacity onPress={() => navigation.navigate("SignUp")}>
        <Text style={styles.link}>New user? Sign Up</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.altButton}
        onPress={() => navigation.navigate("PhoneSignIn")}
      >
        <Text>📞 Sign in with Phone</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.altButton}
        onPress={() => navigation.navigate("GoogleSignIn")}
      >
        <Text>🔵 Sign in with Google</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: COLORS.background },
  title: { fontSize: 26, fontWeight: "bold", color: COLORS.primary, marginBottom: 20 },
  input: { width: "80%", borderWidth: 1, borderColor: COLORS.gray, padding: 12, borderRadius: 8, marginBottom: 10 },
  button: { backgroundColor: COLORS.primary, padding: 12, borderRadius: 8, width: "80%", alignItems: "center" },
  buttonText: { color: COLORS.white, fontWeight: "bold" },
  link: { color: COLORS.primary, marginTop: 10 },
  altButton: { marginTop: 15, padding: 10, borderWidth: 1, borderRadius: 8, borderColor: COLORS.secondary },
});