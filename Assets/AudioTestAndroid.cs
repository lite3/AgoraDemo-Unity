#if UNITY_ANDROID
using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
using System;

public class AudioTestAndroid : IAgoraPlugin {

    private AndroidJavaObject agoraSDK = null;

    public void InitPlugin()
    {
        AndroidJNIHelper.debug = true;
        using (AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
        {
            AndroidJavaObject curActivity = jc.GetStatic<AndroidJavaObject>("currentActivity");
            agoraSDK = new AndroidJavaObject("com.litefeel.libagorasdk.AgoraSDK", curActivity);
        }
    }

    public string GetSDKVersion()
    {
        return agoraSDK.Call<string>("getSDKVersion");
    }

    public void InitSDK(string vendorKey)
    {
        agoraSDK.Call("initSDK", new[] { vendorKey });
    }

    public void JoinChannel(string channelId)
    {
        agoraSDK.Call("joinChannel", new[] { channelId });
    }

    public void LeaveChannel()
    {
        agoraSDK.Call("leaveChannel");
    }

}
#endif