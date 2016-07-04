using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class AutoSizeText : MonoBehaviour {

    private Text textUI = null;
	// Use this for initialization
	void Start () {
        textUI = GetComponent<Text>();
	}
	
	// Update is called once per frame
	void Update () {
        RectTransform parentTransrom = gameObject.transform.parent as RectTransform;
        parentTransrom.sizeDelta = new Vector2(parentTransrom.sizeDelta.x, textUI.preferredHeight);
	}
}
