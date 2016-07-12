
//
//  UniSDK_AppStore.m
//  UniSDK_AppStore
//
//  Created by dayong on 15-1-22.
//  Copyright (c) 2015年 unisdk. All rights reserved.
//

#import <UIKit/UIApplication.h>
//#import <iAd/iAd.h>
//#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


#import "UniSDK_Agora.h"

static UniSDK_Agora *instance = nil;

@implementation UniSDK_Agora
{
    AgoraRtcEngineKit *agoraKit;
    BOOL enableLocalAudio;
    BOOL enableRemoteAudio;
}

+(id) sharedInstance
{
    if (!instance)
    {
        instance = [[UniSDK_Agora alloc] init];
    }
    return instance;
}

////////////////////////////////////////////////////////////////////

-(void)initSDK:(NSString *)vendorKey
{
    enableLocalAudio = NO;
    enableRemoteAudio = YES;
    if (agoraKit != nil)
    {
        [AgoraRtcEngineKit destroy];
    }
    agoraKit = [AgoraRtcEngineKit sharedEngineWithVendorKey:vendorKey delegate:self];
    
    [agoraKit disableVideo];
    [agoraKit setEnableSpeakerphone:YES];
    [agoraKit muteLocalAudioStream:!enableLocalAudio];
    [agoraKit muteAllRemoteAudioStreams:!enableRemoteAudio];
    
    [AVAudioSession sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [agoraKit muteLocalAudioStream:YES];
    [agoraKit muteAllRemoteAudioStreams:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [agoraKit muteLocalAudioStream:!enableLocalAudio];
    [agoraKit muteAllRemoteAudioStreams:!enableRemoteAudio];
}

//////////////////////////////////////////////////////////////

#pragma mark UniVoice

- (void)joinChannel:(NSString*)channelId roleId:(NSString*)roleId dynamicKey:(NSString*)dynamicKey
{
    [self leaveChannel];
    [agoraKit joinChannelByKey:dynamicKey channelName:channelId info:NULL uid:0 joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        
    }];
    if (![self isHeadsetPluggedIn])
    {
        [agoraKit setEnableSpeakerphone:YES];
    }
}
- (void)leaveChannel
{
    [agoraKit leaveChannel:^(AgoraRtcStats *stat) {
    }];
    //[agoraKit setEnableSpeakerphone:NO];
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error != nil)
    {
        NSLog(@"NS ERROR code %ld, domain %@", error.code, error.domain );
    }
}
- (BOOL)isEnableLocalAudio
{
    return enableLocalAudio;
}
- (BOOL)isEnableRemoteAudio
{
    return enableRemoteAudio;
}
- (void)setEnableLocalAudio:(BOOL)param
{
    enableLocalAudio = param;
    [agoraKit muteLocalAudioStream:!enableLocalAudio];
}
- (void)setEnableRemoteAudio:(BOOL)param
{
    enableRemoteAudio = param;
    [agoraKit muteAllRemoteAudioStreams:!enableRemoteAudio];
}

#pragma end mark


#pragma mark -
- (BOOL)isHeadsetPluggedIn
{
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            // NSLog(@"Headphone/Line plugged in");
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            // NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            // NSLog(@"Headphone/Line was pulled. Stopping player....");
            [agoraKit setEnableSpeakerphone:YES];
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            // NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma end


#pragma mark AgoraRtcEngineDelegate
/**
 *  The warning occurred in SDK. The APP could igonre the warning, and the SDK could try to resume automically.
 *
 *  @param engine      The engine kit
 *  @param warningCode The warning code
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurWarning:(AgoraRtcWarningCode)warningCode
{
    NSLog(@"Argora Warning %ld", warningCode);
}

/**
 *  The error occurred in SDK. The SDK couldn't resume to normal state, and the app need to handle it.
 *
 *  @param engine    The engine kit
 *  @param errorCode The error code
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode
{
    NSLog(@"Argora Error %ld", errorCode);
}

/**
 *  The sdk reports the volume of a speaker. The interface is disable by default, and it could be enable by API "enableAudioVolumeIndication"
 *
 *  @param engine      The engine kit
 *  @param speakers    The ids of speakers
 *  @param totalVolume The total volume of speakers
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportAudioVolumeIndicationOfSpeakers:(NSArray*)speakers totalVolume:(NSInteger)totalVolume
{
    
}

/**
 *  Event of the first local frame starts rendering on the screen.
 *
 *  @param engine  The engine kit
 *  @param size    The size of local video stream
 *  @param elapsed The elapsed time(ms) from the beginning of the session.
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed
{
    
}

/**
 *  Event of the first frame of remote user is decoded successfully.
 *
 *  @param engine  The engine kit
 *  @param uid     The remote user id
 *  @param size    The size of video stream
 *  @param elapsed The elapsed time(ms) from the beginning of the session.
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    
}

/**
 *  Event of the first frame of remote user is rendering on the screen.
 *
 *  @param engine  The engine kit
 *  @param uid     The remote user id
 *  @param size    The size of video stream
 *  @param elapsed The elapsed time(ms) from the beginning of the session.
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    
}

/**
 *  Event of remote user joined
 *
 *  @param engine  The engine kit
 *  @param uid     The remote user id
 *  @param elapsed The elapsed time(ms) from the beginning of the session.
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    
}

/**
 *  Event of remote user offlined
 *
 *  @param engine The engine kit
 *  @param uid    The remote user id
 *  @param reason Reason of user offline, quit or drop
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason
{
    
}

/**
 *  Event of remote user audio muted or unmuted
 *
 *  @param engine The engine kit
 *  @param muted  Mute or unmute
 *  @param uid    The remote user id
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    
}

/**
 *  Event of remote user video muted or unmuted
 *
 *  @param engine The engine kit
 *  @param muted  Muted or unmuted
 *  @param uid    The remote user id
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    
}

/**
 *  Event of remote user video muted or unmuted
 *
 *  @param engine The engine kit
 *  @param muted  Muted or unmuted
 *  @param uid    The remote user id
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoEnabled:(BOOL)enabled byUid:(NSUInteger)uid
{
    
}

/**
 *  The statistics of local video stream. Update every two seconds.
 *
 *  @param engine        The engine kit
 *  @param sentBitrate   The sent bit rate
 *  @param sentFrameRate The sent video frame rate
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine localVideoStats:(AgoraRtcLocalVideoStats*)stats
{
    
}

/**
 *  The statistics of remote video stream. Update every two seconds.
 *
 *  @param engine            The engine kit
 *  @param uid               The remote user id
 *  @param delay             The delay from remote user to local
 *  @param receivedBitrate   The received bit rate
 *  @param receivedFrameRate The received frame rate
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStats:(AgoraRtcRemoteVideoStats*)stats
{
    
}

/**
 *  Event of camera opened
 *
 *  @param engine The engine kit
 */
- (void)rtcEngineCameraDidReady:(AgoraRtcEngineKit *)engine
{
    
}

/**
 *  Event of camera stopped
 *
 *  @param engine The engine kit
 */
- (void)rtcEngineVideoDidStop:(AgoraRtcEngineKit *)engine
{
    
}

/**
 *  Event of disconnected with server. This event is reported at the moment SDK loses connection with server.
 *  In the mean time SDK automatically tries to reconnect with the server until APP calls leaveChannel.
 *
 *  @param engine The engine kit
 */
- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine
{
    
}

/**
 *  Event of loss connection with server. This event is reported after the connection is interrupted and exceed the retry period (10 seconds by default).
 *  In the mean time SDK automatically tries to reconnect with the server until APP calls leaveChannel.
 *
 *  @param engine The engine kit
 */
- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine
{
    
}

/**
 *  Event of the user joined the channel.
 *
 *  @param engine  The engine kit
 *  @param channel The channnel name
 *  @param uid     The remote user id
 *  @param elapsed The elapsed time (ms) from session beginning
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed
{
    NSLog(@"Agora Joined Channel!");
}

/**
 *  Event of the user rejoined the channel
 *
 *  @param engine  The engine kit
 *  @param channel The channel name
 *  @param uid     The user id
 *  @param elapsed The elapsed time (ms) from session beginning
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed
{
    NSLog(@"Agora Rejoined Channel!");
}

/**
 *  Statistics of rtc engine status. Updated every two seconds.
 *
 *  @param engine The engine kit
 *  @param stats  The statistics of rtc status, including duration, sent bytes and received bytes
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportRtcStats:(AgoraRtcStats*)stats
{
    
}

/**
 *  The statistics of the call when leave channel
 *
 *  @param engine The engine kit
 *  @param stats  The statistics of the call, including duration, sent bytes and received bytes
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didLeaveChannelWithStats:(AgoraRtcStats*)stats
{
    NSLog(@"Agora leaved Channel!");
}

/**
 *  The audio quality of the user. updated every two seconds.
 *
 *  @param engine  The engine kit
 *  @param uid     The id of user
 *  @param quality The audio quality
 *  @param delay   The delay from the remote user
 *  @param lost    The percentage of lost packets
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine audioQualityOfUid:(NSUInteger)uid quality:(AgoraRtcQuality)quality delay:(NSUInteger)delay lost:(NSUInteger)lost
{
    
}

/**
 *  The network quality of local user.
 *
 *  @param engine  The engine kit
 *  @param quality The network quality
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine networkQuality:(AgoraRtcQuality)quality
{
    
}

/**
 *  Event of API call executed
 *
 *  @param engine The engine kit
 *  @param api    The API description
 *  @param error  The error code
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didApiCallExecute:(NSString*)api error:(NSInteger)error
{
    NSLog(@"Agora API Call Error %ld %@", error, api);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRefreshRecordingServiceStatus:(NSInteger)status
{
    
}

#pragma end

@end

void initSDK(const char* vendorKey)
{
    NSString *nsvendorKey = [NSString stringWithUTF8String:vendorKey];
    [[UniSDK_Agora sharedInstance] initSDK:nsvendorKey];
}

void joinChannel(const char* channelId)
{
    NSString *nschannelId = [NSString stringWithUTF8String:channelId];
    [[UniSDK_Agora sharedInstance] joinChannel:nschannelId roleId:nil dynamicKey:nil];
}

void leaveChannel()
{
    [[UniSDK_Agora sharedInstance] leaveChannel];
    UnitySendMessage("AudioTest", "TryLoadMusic", "");
}

