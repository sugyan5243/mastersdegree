package com.example.sugyan5243.silverphone;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.hardware.usb.UsbManager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import jp.ksksue.driver.serial.FTDriver;

public class MainActivity extends AppCompatActivity {

    // [FTDriver] Object
    FTDriver mSerial;

    // [FTDriver] Permission String
    private static final String ACTION_USB_PERMISSION =
            "jp.ksksue.tutorial.USB_PERMISSION";

    Button btnBegin,btnRead,btnWrite,btnEnd;
    TextView tvMonitor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //Viewをセットする
        LinearLayout l = new LinearLayout(this);
        setContentView(new MainView(this));
//        setContentView(l);
//        l.addView(new MainView(this));

        // [FTDriver] Create Instance
        mSerial = new FTDriver((UsbManager)getSystemService(Context.USB_SERVICE));

        // [FTDriver] setPermissionIntent() before begin()
        PendingIntent permissionIntent = PendingIntent.getBroadcast(this, 0, new Intent(
                ACTION_USB_PERMISSION), 0);
        mSerial.setPermissionIntent(permissionIntent);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        // [FTDriver] Close USB Serial
        mSerial.end();
    }

    public void onBeginClick(View view) {
        // [FTDriver] Open USB Serial
        if(mSerial.begin(FTDriver.BAUD9600)) {
            Toast.makeText(this, "connected", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "cannot connect", Toast.LENGTH_SHORT).show();
        }
    }

    public String onReadClick(View view) {
        int i,len;
        StringBuilder mText = new StringBuilder();;
        // [FTDriver] Create Read Buffer
        byte[] rbuf = new byte[4096]; // 1byte <--slow-- [Transfer Speed] --fast--> 4096 byte

        // [FTDriver] Read from USB Serial
        len = mSerial.read(rbuf);
/*
        for(i=0; i<len; i++) {
            if((char) rbuf[i] == ' '){
                i = 10000;
            }else {
                mText.append((char) rbuf[i]);
            }
        }
*/

        for(i = 0; (char)rbuf[i] != '.'; i++){
            mText.append((char) rbuf[i]);
        }
        return mText.toString();
    }

    public void onWriteClick(View view) {
        String wbuf = "FTDriver Test.";

        // [FTDriver] Wirte to USB Serial
        mSerial.write(wbuf.getBytes());

    }

    public void onEndClick(View view) {
        // [FTDriver] Close USB Serial
        mSerial.end();
        Toast.makeText(this, "disconnect", Toast.LENGTH_SHORT).show();
    }
}
