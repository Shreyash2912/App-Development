package com.example.counter;

import android.view.View;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {
    private TextView Textview;
    private Button increaseBTN;
    private Button decreaseBTN;
    private Button resetBTN;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        setUI();

        // Increase
        increaseBTN.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String newText = Integer.toString(
                        Integer.parseInt(Textview.getText().toString()) + 1
                );
                Textview.setText(newText);
            }
        });

        // Decrease
        decreaseBTN.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int current = Integer.parseInt(Textview.getText().toString());
                if (current != 0) {
                    String newText = Integer.toString(current - 1);
                    Textview.setText(newText);
                }
            }
        });

        // Reset
        resetBTN.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Textview.setText("0");
            }



        });
    }


    private void setUI() {
        Textview = findViewById(R.id.textView2);
        increaseBTN = findViewById(R.id.button);
        decreaseBTN = findViewById(R.id.button2);
        resetBTN = findViewById(R.id.button3);
    }
}