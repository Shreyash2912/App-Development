import React, { useState } from "react";
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from "react-native";
import { useNavigation } from "@react-navigation/native";
import { COLORS } from "../theme";

export default function PhoneSignInScreen() {
  const [phone, setPhone] = useState("");
  const [code, setCode] = useState("");
  const [step, setStep] = useState(1); // 1 = enter phone, 2 = enter code
  const navigation = useNavigation();

  const sendCode = () => {
    if (!phone) return Alert.alert("Enter phone number");
    Alert.alert("Code Sent", "A verification code was sent (demo mode).");
    setStep(2);
  };

  const verifyCode = () => {
    if (!code) return Alert.alert("Enter the verification code");
    Alert.alert("Success", "Phone verified successfully!");
    navigation.replace("Home"); // ✅ Go to home after fake verification
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>📞 Phone Sign In</Text>

      {step === 1 ? (
        <>
          <TextInput
            placeholder="Enter phone number"
            value={phone}
            onChangeText={setPhone}
            style={styles.input}
            keyboardType="default"
          />
          <TouchableOpacity style={styles.button} onPress={sendCode}>
            <Text style={styles.buttonText}>Send Code</Text>
          </TouchableOpacity>
        </>
      ) : (
        <>
          <TextInput
            placeholder="Enter received code"
            value={code}
            onChangeText={setCode}
            style={styles.input}
            keyboardType="number-pad"
          />
          <TouchableOpacity style={styles.button} onPress={verifyCode}>
            <Text style={styles.buttonText}>Verify & Continue</Text>
          </TouchableOpacity>
        </>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: COLORS.background },
  title: { fontSize: 24, fontWeight: "bold", marginBottom: 20, color: COLORS.primary },
  input: { width: "80%", borderWidth: 1, borderColor: COLORS.gray, padding: 12, borderRadius: 8, marginBottom: 10 },
  button: { backgroundColor: COLORS.primary, padding: 12, borderRadius: 8, width: "80%", alignItems: "center", marginTop: 10 },
  buttonText: { color: COLORS.white, fontWeight: "bold" },
});