package com.ruihuan.flutter.fluttercommon;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import com.ruihuan.flutter.fluttercommon.R;

public class TestActivity extends Activity {

    Button returnButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test);
        returnButton = findViewById(R.id.return_button);

        returnButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setResult(200);
                finish();
            }
        });
    }
}
