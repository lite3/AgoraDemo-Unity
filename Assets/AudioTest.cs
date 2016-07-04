using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class AudioTest : MonoBehaviour {
    
    private AndroidJavaObject agoraSDK = null;

    public InputField vendorKeyInput;
    public InputField channelIdInput;
    public Text logText;
    
	void Start () {
#if UNITY_ANDROID && !UNITY_EDITOR
        AndroidJNIHelper.debug = true;
        using (AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
        {
            AndroidJavaObject curActivity = jc.GetStatic<AndroidJavaObject>("currentActivity");
            agoraSDK = new AndroidJavaObject("io.agora.AgoraSDK", curActivity);
        }
#endif
        vendorKeyInput.text = "10cc99f99cfc40a5b7ab2c1de6c09e0c";
    }

    public void InitSDK()
    {
        agoraSDK.Call("initSDK", new[] { vendorKeyInput.text });
        Log("init sdk with vendor key:" + vendorKeyInput.text);
    }
    
	public void JoinChannel()
    {
        agoraSDK.Call("joinChannel", new[] { channelIdInput.text });
        Log("joinChannel with channel id:" + channelIdInput.text);
    }

    public void LeaveChannel()
    {
        agoraSDK.Call("leaveChannel");
        Log("leaveChanne");
    }

    public void Log(string message)
    {
        logText.text += message + "\n";
    }
}
