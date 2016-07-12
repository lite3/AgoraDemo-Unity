using UnityEngine;
using System.Collections;
using System;

public class MusicPlayer : MonoBehaviour {

	// Use this for initialization
	void Start () {
        StartCoroutine(LoadMusic());
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
                url = "file://" + Application.streamingAssetsPath + "Windows/music.assetbundle";
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
	        AudioClip audioClip = ab.LoadAsset<AudioClip>(names[0]);
	        GameObject go = new GameObject();
	        AudioSource audioSource = go.AddComponent<AudioSource>();
	        audioSource.clip = audioClip;
	        audioSource.loop = true;
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
	
	// Update is called once per frame
	void Update () {
	
	}
}
