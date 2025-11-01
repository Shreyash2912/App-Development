import React, { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet, Alert } from 'react-native';
import auth from '@react-native-firebase/auth';

const App = () => {
  const [phoneNumber, setPhoneNumber] = useState('');
  const [confirm, setConfirm] = useState(null);
  const [code, setCode] = useState('');
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  // Step 1: Send verification code
  const sendCode = async () => {
    if (!phoneNumber) {
      Alert.alert('Error', 'Please enter your phone number.');
      return;
    }
    try {
      const confirmation = await auth().signInWithPhoneNumber(phoneNumber);
      setConfirm(confirmation);
      Alert.alert('Code Sent', 'Please check your SMS for the verification code.');
    } catch (error) {
      console.log(error);
      Alert.alert('Error', error.message);
    }
  };

  // Step 2: Confirm code
  const confirmCode = async () => {
    try {
      await confirm.confirm(code);
      setIsLoggedIn(true); // success → show welcome page
    } catch (error) {
      Alert.alert('Invalid Code', 'Please try again.');
    }
  };

  // ✅ Step 3: After successful verification → Welcome Page
  if (isLoggedIn) {
    return (
      <View style={styles.welcomeContainer}>
        <Text style={styles.welcomeText}>🎉 Welcome!</Text>
        <Text style={styles.subText}>
          You’ve successfully logged in with your phone number.
        </Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Phone Login</Text>

      {!confirm ? (
        <>
          <TextInput
            style={styles.input}
            placeholder="Enter phone number (e.g. +91 9876543210)"
            placeholderTextColor="#888"
            keyboardType="phone-pad"
            value={phoneNumber}
            onChangeText={setPhoneNumber}
          />
          <Button title="Send Code" onPress={sendCode} color="#000" />
        </>
      ) : (
        <>
          <TextInput
            style={styles.input}
            placeholder="Enter verification code"
            placeholderTextColor="#888"
            keyboardType="number-pad"
            value={code}
            onChangeText={setCode}
          />
          <Button title="Verify Code" onPress={confirmCode} color="#000" />
        </>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff', // minimalist white
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 26,
    marginBottom: 40,
    color: '#000',
    fontWeight: '700',
    letterSpacing: 0.5,
  },
  input: {
    width: '90%',
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 12,
    padding: 14,
    marginVertical: 10,
    fontSize: 16,
    backgroundColor: '#f9f9f9',
    color: '#000',
  },
  welcomeContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
    padding: 20,
  },
  welcomeText: {
    fontSize: 30,
    fontWeight: '700',
    color: '#000',
    marginBottom: 10,
  },
  subText: {
    fontSize: 16,
    color: '#444',
    textAlign: 'center',
    width: '80%',
  },
});

export default App;
