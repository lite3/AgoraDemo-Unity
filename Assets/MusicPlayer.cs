using UnityEngine;
using System.Collections;
using System;
using UnityEngine.UI;

public class MusicPlayer : MonoBehaviour {

    public Toggle musicBtn;
    public Toggle echoCanncellationBtn;

    private int simplesPerS;

    private float[] bytes = new float[30];
    private short[] datas = new short[30];

    private AudioClip audioClip;
    private AudioSource audioSource;
    private bool musicEnable = true;
    private bool echoCanncellationEnable;

    // Use this for initialization
    void Start () {
        musicEnable = musicBtn.isOn;
        echoCanncellationEnable = echoCanncellationBtn.isOn;
        
        audioSource = GetComponent<AudioSource>();
        if (audioSource != null)
        {
            audioSource.loop = true;
            audioSource.mute = !musicEnable;
            audioClip = audioSource.clip;
            simplesPerS = (int)(audioClip.samples / audioClip.length);
            bytes = new float[simplesPerS];
            datas = new short[simplesPerS];
        } else
        {
            StartCoroutine(LoadMusic());
        }

        CallNativeCode.Init();
	}

    IEnumerator LoadMusic()
    {
        print(Application.streamingAssetsPath);
        string url = null;
        switch(Application.platform)
        {
            case RuntimePlatform.Android:
                url = Application.streamingAssetsPath + "/Android/music.assetbundle";
                break;
            case RuntimePlatform.WindowsEditor:
            case RuntimePlatform.WindowsPlayer:
                url = "file://" + Application.streamingAssetsPath + "/Windows/music.assetbundle";
                break;
			case RuntimePlatform.IPhonePlayer:
				url = "file://" + Application.streamingAssetsPath + "/iOS/music.assetbundle";
				break;
        }
		print ("url:" + url);
        WWW www = new WWW(url);
        yield return www;
		if (www.error != null) {
			print (www.error);
		}else {
	        AssetBundle ab = www.assetBundle;
	        string[] names = ab.GetAllAssetNames();
	        foreach (var name in names)
	        {
	            print(name);
	        }
	        audioClip = ab.LoadAsset<AudioClip>(names[0]);
            simplesPerS = (int)(audioClip.samples / audioClip.length);
            bytes = new float[simplesPerS];
            datas = new short[simplesPerS];
	        GameObject go = new GameObject();
	        audioSource = go.AddComponent<AudioSource>();
	        audioSource.clip = audioClip;
	        audioSource.loop = true;
            audioSource.mute = !musicEnable;
	        audioSource.Play();
			ab.Unload (false);
			GameObject.Destroy (ab);
	    }
		www.Dispose ();
	}

	public void TryLoadMusic(string message)
	{
		StartCoroutine (LoadMusic ());
	}

    
    public void CheckMusice()
    {
        musicEnable = musicBtn.isOn;
        if (audioSource != null)
        {
            audioSource.mute = !musicEnable;
        }
    }

    public void CheckeEhoCanncellation()
    {
        echoCanncellationEnable = echoCanncellationBtn.isOn;
    }

    // Update is called once per frame
    void Update () {
        //audioClip.GetData(bytes, 0);
        if (audioSource != null && audioClip != null && !audioSource.mute && echoCanncellationEnable)
        {
//             Debug.Log("audioSource.timeSamples " + audioSource.timeSamples);
//             Debug.Log("audioClip.samples " + audioClip.samples);
//             Debug.Log("audioClip.channels " + audioClip.channels);
            audioClip.GetData(bytes, audioSource.timeSamples);
            for(int i = bytes.Length-1; i >= 0; i--)
            {
                datas[i] = (short)(bytes[i] * short.MaxValue);
            }
            CallNativeCode.SetData(datas, bytes.Length, audioClip.frequency, audioClip.channels, 10);
            //Debug.Log("bytes:" + bytes[0] + " " + bytes[1] + " " + bytes[2] + " " + bytes[3]);
        }
	}
}
