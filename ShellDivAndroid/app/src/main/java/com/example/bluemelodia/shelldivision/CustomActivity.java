package com.example.bluemelodia.shelldivision;
import android.support.v7.app.AppCompatActivity;
import android.app.Activity;
import android.content.res.Configuration;
import android.content.pm.ActivityInfo;
/**
 * Created by melaniehsu on 4/15/16.
 */
public class CustomActivity extends Activity {
    // prevent device rotation in all activities
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT) {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        } else {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        }
    }
}