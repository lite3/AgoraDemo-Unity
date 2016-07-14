package com.litefeel.libagorasdk;

import android.util.Log;

import io.agora.rtc.IRtcEngineEventHandler;

public class AgoraEventHandler extends IRtcEngineEventHandler {
	
	public static final String TAG = AgoraEventHandler.class.getSimpleName();

	private int networkQuality = 0;

	@Override
	public void onError(int err) {
		Log.e(TAG, "Agora Voice SDK report error: " + err);
	}

	@Override
	public void onJoinChannelSuccess(String channelName, int uid, int elapsed) {
		Logger.log(TAG, "Channel joined: channel " + channelName + " uid " + (uid&0xFFFFFFFFL) + " elapsed "+ elapsed + " ms");
	}

    @Override
    public void onRejoinChannelSuccess(String channelName, int uid, int elapsed) {
		Logger.log(TAG, "Channel rejoined: channel " + channelName + " uid " + (uid&0xFFFFFFFFL) + " elapsed "+ elapsed + " ms");
    }

	@Override
	public void onLeaveChannel(RtcStats stats) {
		Logger.log(TAG, "end of call: duration " + stats.totalDuration + " secs, total " + (stats.txBytes+stats.rxBytes) + " bytes");
	}

	@Override
	public void onRtcStats(RtcStats stats) {
		onNetworkQuality(stats.lastmileQuality);
	}
	static String getQualityDesc(int quality) {
		switch (quality) {
		case Quality.EXCELLENT:
			return "5";
		case Quality.GOOD:
			return "4";
		case Quality.POOR:
			return "3";
		case Quality.BAD:
			return "2";
		case Quality.VBAD:
			return "1";
		case Quality.DOWN:
			return "0";
		case Quality.UNKNOWN:
		default:
			return "unknown";
		}
	}

	@Override
    public void onAudioQuality(int uid, int quality, short delay, short lost) {
        String msg = String.format("user %d quality %s delay %d lost %d", (uid&0xFFFFFFFFL), getQualityDesc(quality), delay, lost);
		//Logger.log(TAG,  msg);
	}

	@Override
	public void onUserJoined(int uid, int elapsed) {
		Logger.log(TAG, "user " + (uid&0xFFFFFFFFL) + " is joined");
	}
	
	@Override
	public void onUserOffline(int uid, int reason) {
		Logger.log(TAG, "user " + (uid&0xFFFFFFFFL) + " is offline");
	}

	@Override
	public void onUserMuteAudio(int uid, boolean muted) {

	}
	
	@Override
    public void onUserMuteVideo(int uid, boolean muted) {
		String msg = String.format("user %d onUserMuteVideo fired", (uid&0xFFFFFFFFL));
		Logger.log(TAG, msg);
	}

	@Override
	public void onNetworkQuality(int quality) {
        String msg = String.format("network quality %s", getQualityDesc(quality));
		if (quality != networkQuality) {
            networkQuality = quality;
            Logger.log(TAG, msg);
		}
	}

    @Override
    public void onLocalVideoStat(int sentBytes, int sentFrames) {

    }

	@Override
	public void onConnectionLost() {
		String msg = String.format("connection lost");
		Logger.log(TAG, msg);
	}
}
