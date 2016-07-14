using UnityEngine;
using System.Collections;
using System;
using UnityEngine.UI;

public class MusicPlayer : MonoBehaviour {

    public Toggle musicBtn;

    private float[] bytes = new float[20];

    private AudioClip audioClip;
    private AudioSource audioSource;
    private bool musicEnable = true;
    // Use this for initialization
    void Start () {
        musicEnable = musicBtn.isOn;
        StartCoroutine(LoadMusic());
//         audioSource = GetComponent<AudioSource>();
//         audioClip = audioSource.clip;
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
	
	// Update is called once per frame
	void Update () {
        //audioClip.GetData(bytes, 0);
//         if (audioSource != null && audioClip != null)
//         {
//             Debug.Log("audioSource.timeSamples " + audioSource.timeSamples);
//             Debug.Log("audioClip.samples " + audioClip.samples);
//             Debug.Log("audioClip.channels " + audioClip.channels);
//             audioClip.GetData(bytes, audioSource.timeSamples);
//             Debug.Log("bytes:" + bytes[0] + " " + bytes[1] + " " + bytes[2] + " " + bytes[3]);
//         }
	}
}
