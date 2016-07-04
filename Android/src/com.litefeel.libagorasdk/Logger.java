package com.litefeel.libagorasdk;

import android.util.Log;

import com.unity3d.player.UnityPlayer;

/**
 * Created by xiaoqing.zhang on 2016/7/2.
 */
public class Logger {
    public static void log(String tag, String message) {
        Log.d(tag, message);
        UnityPlayer.UnitySendMessage("AudioTest", "Log", tag + ": " +  message);
    }
}
