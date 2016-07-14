#if UNITY_IPHONE
using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
using System;

public class AudioTestIOS : IAgoraPlugin {

    [DllImport("__Internal")]
    private static extern void initSDK(string vendorKey);
    [DllImport("__Internal")]
    private static extern void joinChannel(string channelId);
    [DllImport("__Internal")]
    private static extern void leaveChannel();

    // Use this for initialization
    void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    public void InitSDK(string vendorKey)
    {
        initSDK(vendorKey);
    }
    
	public void JoinChannel(string channelId)
    {
        joinChannel(channelId);
    }

    public void LeaveChannel()
    {
        leaveChannel();
    }
}
#endif