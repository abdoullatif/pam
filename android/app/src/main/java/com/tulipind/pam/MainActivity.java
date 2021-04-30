package com.tulipind.pam;

import android.os.Build;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Locale;

import static android.content.Context.BATTERY_SERVICE;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter.native/helper";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("encryptPassword")) {
                                String batteryLevel = encryptPassword();

                                if (!batteryLevel.equals("-1")) {
                                    result.success(batteryLevel);
                                } else {
                                    result.error("UNAVAILABLE", "Battery level not available.", null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    /**
     *
     * @param passwordUser
     * @return
     */

    private String encryptPassword(String passwordUser) {
        String pass = passwordUser+Math.random();

        String passwordCrypt = null;

        try {
            MessageDigest AlphaNumeric = MessageDigest.getInstance("SHA");
            byte[] resultat = AlphaNumeric.digest(pass.getBytes());
            StringBuilder valeur = new StringBuilder();
            for(byte b : resultat){
                valeur.append(Integer.toString((b & 0xff) + 0x100, 16));
            }
            passwordCrypt = valeur.toString().toUpperCase(Locale.ITALY).substring(0, 9);
            return passwordCrypt;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }


        //return pass;
    }


}
