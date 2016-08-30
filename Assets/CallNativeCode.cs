using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class CallNativeCode {

#if UNITY_ANDROID 
	[DllImport("native")]
	private static extern float add(float x, float y);

    [DllImport("native")]
    private static extern int unisdkAgoraInit();

    [DllImport("native")]
    private static extern void unisdkAgoraSetData(short[] data, int length, int fs, int channels, int volume);

    public static bool isOk = false;
#endif

	public static void Init()
    {
#if UNITY_ANDROID
        int result = unisdkAgoraInit();
        Debug.LogError("unisdkAgoraInit: " + result);
        isOk = result == 0;
#endif
    }

    public static void SetData(short[] data, int length, int fs, int channels, int volume)
    {
#if UNITY_ANDROID
        if (isOk)
        {
            unisdkAgoraSetData(data, length, fs, channels, volume);
        }
#endif
    }
}
