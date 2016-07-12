using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class AudioTest : MonoBehaviour {

    private IAgoraPlugin plugin;

    public InputField vendorKeyInput;
    public InputField channelIdInput;
    public Text logText;
    
	void Start () {
#if UNITY_ANDROID
        plugin = new AudioTestAndroid();
#elif UNITY_IPHONE
        plugin = new AudioTestIOS();
#endif
		vendorKeyInput.text = "c45dc2ca378f495ca1168dd2bf2a5696";
    }

    public void InitSDK()
    {
        plugin.InitSDK(vendorKeyInput.text);
        Log("init sdk with vendor key:" + vendorKeyInput.text);
    }
    
	public void JoinChannel()
    {
        plugin.JoinChannel(channelIdInput.text);
        Log("joinChannel with channel id:" + channelIdInput.text);
    }

    public void LeaveChannel()
    {
        plugin.LeaveChannel();
        Log("leaveChanne");
    }

    public void Log(string message)
    {
        logText.text += message + "\n";
    }
}
