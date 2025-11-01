import React, { useEffect } from "react";
import { Button, View } from "react-native";
import * as WebBrowser from "expo-web-browser";
import * as Google from "expo-auth-session/providers/google";
import { GoogleAuthProvider, signInWithCredential } from "firebase/auth";
import { auth } from "../firebaseConfig";

WebBrowser.maybeCompleteAuthSession();

export default function GoogleSignInScreen({ navigation }) {
  const [request, response, promptAsync] = Google.useAuthRequest({
    androidClientId: "959877425117-hj7br2bva6ktkcpjjshmgj8fmptgrkgc.apps.googleusercontent.com",
    webClientId: "959877425117-hj7br2bva6ktkcpjjshmgj8fmptgrkgc.apps.googleusercontent.com",
  });

  useEffect(() => {
    if (response?.type === "success") {
      const { id_token } = response.params;
      const credential = GoogleAuthProvider.credential(id_token);
      signInWithCredential(auth, credential)
        .then(() => navigation.replace("Home"))
        .catch((err) => alert(err.message));
    }
  }, [response]);

  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Button disabled={!request} title="Sign in with Google" onPress={() => promptAsync()} />
    </View>
  );
}