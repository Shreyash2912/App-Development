package com.example.authenticateapp;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.firebase.FirebaseException;
import com.google.firebase.auth.PhoneAuthCredential;
import com.google.firebase.auth.PhoneAuthOptions;
import com.google.firebase.auth.PhoneAuthProvider;
import com.google.firebase.auth.FirebaseAuth;

import java.util.concurrent.TimeUnit;

public class MainActivity extends AppCompatActivity {

    EditText phoneNumber, code, name, email;
    Button sendCodeBtn, verifyBtn, saveDetailsBtn;
    FirebaseAuth mAuth;
    String verificationId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        phoneNumber = findViewById(R.id.phoneNumber);
        code = findViewById(R.id.code);
        sendCodeBtn = findViewById(R.id.sendCodeBtn);
        verifyBtn = findViewById(R.id.verifyBtn);
        name = findViewById(R.id.name);
        email = findViewById(R.id.email);
        saveDetailsBtn = findViewById(R.id.saveDetailsBtn);

        mAuth = FirebaseAuth.getInstance();

        sendCodeBtn.setOnClickListener(v -> sendVerificationCode());
        verifyBtn.setOnClickListener(v -> verifyCode());
        saveDetailsBtn.setOnClickListener(v -> openWelcomePage());
    }

    private void sendVerificationCode() {
        String number = phoneNumber.getText().toString().trim();

        if (number.isEmpty()) {
            Toast.makeText(this, "Enter phone number", Toast.LENGTH_SHORT).show();
            return;
        }

        PhoneAuthOptions options =
                PhoneAuthOptions.newBuilder(mAuth)
                        .setPhoneNumber(number)
                        .setTimeout(60L, TimeUnit.SECONDS)
                        .setActivity(this)
                        .setCallbacks(callbacks)
                        .build();
        PhoneAuthProvider.verifyPhoneNumber(options);
    }

    private final PhoneAuthProvider.OnVerificationStateChangedCallbacks callbacks =
            new PhoneAuthProvider.OnVerificationStateChangedCallbacks() {
                @Override
                public void onVerificationCompleted(@NonNull PhoneAuthCredential credential) {
                    signInWithCredential(credential);
                }

                @Override
                public void onVerificationFailed(@NonNull FirebaseException e) {
                    Toast.makeText(MainActivity.this, e.getMessage(), Toast.LENGTH_LONG).show();
                }

                @Override
                public void onCodeSent(@NonNull String s, @NonNull PhoneAuthProvider.ForceResendingToken token) {
                    super.onCodeSent(s, token);
                    verificationId = s;
                    phoneNumber.setVisibility(View.GONE);
                    sendCodeBtn.setVisibility(View.GONE);
                    code.setVisibility(View.VISIBLE);
                    verifyBtn.setVisibility(View.VISIBLE);
                    Toast.makeText(MainActivity.this, "Code sent!", Toast.LENGTH_SHORT).show();
                }
            };

    private void verifyCode() {
        String enteredCode = code.getText().toString().trim();

        if (enteredCode.isEmpty()) {
            Toast.makeText(this, "Enter the code", Toast.LENGTH_SHORT).show();
            return;
        }

        PhoneAuthCredential credential = PhoneAuthProvider.getCredential(verificationId, enteredCode);
        signInWithCredential(credential);
    }

    private void signInWithCredential(PhoneAuthCredential credential) {
        mAuth.signInWithCredential(credential)
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        Toast.makeText(MainActivity.this, "Phone Verified!", Toast.LENGTH_SHORT).show();

                        // Show name and email fields after verification
                        code.setVisibility(View.GONE);
                        verifyBtn.setVisibility(View.GONE);
                        name.setVisibility(View.VISIBLE);
                        email.setVisibility(View.VISIBLE);
                        saveDetailsBtn.setVisibility(View.VISIBLE);
                    } else {
                        Toast.makeText(MainActivity.this, "Verification Failed!", Toast.LENGTH_SHORT).show();
                    }
                });
    }

    private void openWelcomePage() {
        String userName = name.getText().toString().trim();
        String userEmail = email.getText().toString().trim();

        if (userName.isEmpty() || userEmail.isEmpty()) {
            Toast.makeText(this, "Enter name and email", Toast.LENGTH_SHORT).show();
            return;
        }

        Intent intent = new Intent(MainActivity.this, WelcomeActivity.class);
        intent.putExtra("USER_NAME", userName);
        intent.putExtra("USER_EMAIL", userEmail);
        startActivity(intent);
        finish();
    }
}
