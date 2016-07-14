using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class AudioTest : MonoBehaviour {

    private IAgoraPlugin plugin;

    public InputField vendorKeyInput;
    public InputField channelIdInput;
    public Text logText;
    public Text versionText;
    
	void Start () {
#if UNITY_ANDROID
        plugin = new AudioTestAndroid();
#elif UNITY_IPHONE
        plugin = new AudioTestIOS();
#endif
        string vendorKey = "c45dc2ca378f495ca1168dd2bf2a5696";
        if (PlayerPrefs.HasKey("vendorKey"))
        {
            vendorKey = PlayerPrefs.GetString("vendorKey");
        }
        vendorKeyInput.text = vendorKey;
        if (PlayerPrefs.HasKey("channelId"))
        {
            channelIdInput.text = PlayerPrefs.GetString("channelId");
        }
    }

    public void InitSDK()
    {
        PlayerPrefs.SetString("vendorKey", vendorKeyInput.text);
        plugin.InitSDK(vendorKeyInput.text);
        Log("init sdk with vendor key:" + vendorKeyInput.text);

        versionText.text = plugin.GetSDKVersion();
    }
    
	public void JoinChannel()
    {
        PlayerPrefs.SetString("channelId", channelIdInput.text);
        plugin.JoinChannel(channelIdInput.text);
        Log("joinChannel with channel id:" + channelIdInput.text);
    }

    public void LeaveChannel()
    {
        plugin.LeaveChannel();
        Log("leaveChanne");
    }

    public void SetEnableLocalAudio(bool enable)
    {

    }

    public void SetEnableRemoteAudio(bool enable)
    {

    }

    public void Log(string message)
    {
        logText.text += message + "\n";
    }
}
