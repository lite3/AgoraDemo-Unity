package com.litefeel.libagorasdk;

import android.app.Activity;

import io.agora.rtc.RtcEngine;

public class AgoraSDK {
	
	private static final String TAG = AgoraSDK.class.getSimpleName();

	private Activity context;
	private RtcEngine rtcEngine = null;
	private boolean localAudioEnable = false;
	private boolean remoteAudioEnable = true;
	
	public AgoraSDK(Activity context) {
		this.context = context;

	}
	
	private void initSDK(String vendorKey)
	{
		if (rtcEngine != null)
		{
			rtcEngine.destroy();
		}
		rtcEngine = RtcEngine.create(context.getApplicationContext(), vendorKey, new AgoraEventHandler());
        rtcEngine.monitorHeadsetEvent(true);
        rtcEngine.monitorConnectionEvent(true);
        rtcEngine.monitorBluetoothHeadsetEvent(true);
        rtcEngine.enableHighPerfWifiMode(true);
        rtcEngine.disableVideo();
        rtcEngine.setPreferHeadset(true);
        rtcEngine.setEnableSpeakerphone(true);
        rtcEngine.setSpeakerphoneVolume(255);
        
        localAudioEnable = true;
        remoteAudioEnable = true;
        rtcEngine.muteLocalAudioStream(!localAudioEnable);
        rtcEngine.muteAllRemoteAudioStreams(!remoteAudioEnable);
	}

	public void joinChannel(final String channelId) {
		context.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				int rusult = rtcEngine.leaveChannel();
				Logger.log(TAG, "leaveChannel result=" + rusult);
				rusult = rtcEngine.joinChannel("", channelId, "", 0);
                Logger.log(TAG, "joinChannel result=" + rusult);
			}
		});
	}

	public void leaveChannel() {
		context.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				int rusult = rtcEngine.leaveChannel();
                Logger.log(TAG, "leaveChannel result=" + rusult);
			}
		});
	}

    public boolean isEnableLocalAudio() {
        return localAudioEnable;
    }

    public boolean isEnableRemoteAudio() {
    	return remoteAudioEnable;
    }

    public void setEnableLocalAudio (final boolean enable)
    {
        context.runOnUiThread(new Runnable() {
            @Override
            public void run() {
            	localAudioEnable = enable;
            	int rusult = rtcEngine.muteLocalAudioStream(!enable);
                Logger.log(TAG, String.format("muteLocalAudioStream enable=%b result=%d", !enable, rusult));
            }
        });
    }

    public void setEnableRemoteAudio (final boolean enable)
    {
        context.runOnUiThread(new Runnable() {
            @Override
            public void run() {
            	remoteAudioEnable = enable;
            	int rusult = rtcEngine.muteAllRemoteAudioStreams(!enable);
                Logger.log(TAG, String.format("muteAllRemoteAudioStreams enable=%b result=%d", !enable, rusult));
            }
        });
    }

}
