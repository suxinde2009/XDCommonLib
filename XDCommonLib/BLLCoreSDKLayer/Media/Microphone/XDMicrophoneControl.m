//
//  XDMicrophoneControl.m
//  XDCommonLib
//
//  Created by suxinde on 2016/11/7.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import "XDMicrophoneControl.h"

@import AVFoundation;
@import AudioUnit;

@interface XDMicrophoneControl ()

@property (nonatomic, assign) BOOL notDetermined;
@property (nonatomic, assign, getter=isValid) BOOL valid;
@property (nonatomic, assign) BOOL stopped;

@property (nonatomic, assign) NSUInteger sampleRate;
@property (nonatomic, assign) NSUInteger channelNum;

@property (nonatomic, assign) AudioComponentInstance recordingUnit;

@end


static OSStatus audioBufferHandler(void *inRefCon,
                                   AudioUnitRenderActionFlags *ioActionFlags,
                                   const AudioTimeStamp *inTimeStamp,
                                   UInt32 inBusNumber,
                                   UInt32 inNumberFrames,
                                   AudioBufferList *ioData) {
    @autoreleasepool {
        XDMicrophoneControl *micControl = (__bridge XDMicrophoneControl *)inRefCon;
        
        // 初始化AudioBufferList来存储采集到的数据
        AudioBuffer buffer;
        buffer.mData = NULL;
        buffer.mDataByteSize = 0;
        buffer.mNumberChannels = (int)micControl.channelNum;
        
        AudioBufferList buffers;
        buffers.mNumberBuffers = 1;
        buffers.mBuffers[0] = buffer;
        
        // render一次，将AudioComponentInstance采集到的数据传入到audioBuffer中，然后输入给音频编码器编码
        OSStatus status = AudioUnitRender(micControl.recordingUnit,
                                          ioActionFlags,
                                          inTimeStamp,
                                          inBusNumber,
                                          inNumberFrames,
                                          &buffers);
        if(status == noErr) {
            AudioBuffer audioBuffer = buffers.mBuffers[0];
            [micControl.bufferDelegate microphoneControl:micControl
                                   didReceiveAudioBuffer:&audioBuffer];
        }
        return status;
    }
}

@implementation XDMicrophoneControl

/**
 *  音频采集类初始化方法
 *
 *  @param sampleRate 采样率（设备真实采样率）
 *  @param channelNum 声道数=必须等于音频编码的声道数
 *
 *  @return 音频采集类
 */
- (instancetype)initWithSampleRate:(NSUInteger)sampleRate channelNum:(NSUInteger)channelNum {
    self = [super init];
    if (self) {
        _sampleRate = sampleRate;
        _channelNum = channelNum;
        
        _stopped = YES;
        [self requestAuthorization];
        [self initNotifications];
        
    }
    return self;
}


- (void)SessionInterruptionListener: (NSNotification *)notification
{
    int notify = [[[notification userInfo] valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    if (notify == AVAudioSessionInterruptionTypeBegan)
    {
        NSLog(@"MTPlayerAudioQueue SessionInterruptionListener, interruption began");
        [self setActive:NO];
    }
    else if (notify == AVAudioSessionInterruptionTypeEnded)
    {
        NSLog(@"MTPlayerAudioQueue SessionInterruptionListener, interruption ended");
        [self setActive:YES];
    }
}
- (BOOL)setActive:(BOOL)active
{
    if (active != NO)
    {
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    else
    {
        @try
        {
            [[AVAudioSession sharedInstance] setActive:NO error:nil];
        }
        @catch (NSException *exception)
        {
            NSLog(@"MTPlayerAudioQueue setActive, failed to inactive AVAudioSession");
        }
    }
}

- (void)initNotifications {
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SessionInterruptionListener:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
    
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestAuthorization {
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (audioStatus) {
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            return;
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.valid = granted;
                    if (granted) {
                        [self setupAudioIOUnits];
                    }
                    
                    if (!self.stopped) {
                        [self startRecording];
                    }
                });
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
            self.valid = YES;
            [self setupAudioIOUnits];
            break;
    }
}

// 初始化audio session及相关音频数据获取逻辑
- (void)setupAudioIOUnits {
    // config session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker |
     AVAudioSessionCategoryOptionMixWithOthers
                   error:NULL];
    // the real sample rate may not be input(like 44100bps on iphone 6s)
    [session setPreferredSampleRate:_sampleRate error:NULL];
    
    BOOL success = [session setActive:YES error:&error];
    if (!success) {
        NSLog(@"error when configuring session");
        return;
    }
    
    // AudioComponentDescription、AudioComponent、AudioComponentInstance
    // get a i/o audio unit
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    AudioComponent component = AudioComponentFindNext(NULL, &acd);
    OSStatus status = AudioComponentInstanceNew(component, &_recordingUnit);
    if (status != noErr) {
        NSLog(@"error when finding audio unit");
        _recordingUnit = nil;
        return;
    }
    
    // AudioComponentInstance赋值 1、enable componentInstance；2、AudioStreamBasicDescription（包含声道数、采样率、其余的都是默认配置）；3、设置一个callBack来获取采集到的音频数据
    // set audio unit properties and callback
    // remenber that bus of microphone is element No.1,
    // and render callback is attached on input of element No.0
    UInt32 enabled = 1;
    AudioUnitSetProperty(_recordingUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &enabled, sizeof(enabled));
    
    AudioStreamBasicDescription asbd = {0};
    asbd.mSampleRate = _sampleRate;  // set to real sample to avoid distortion
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    asbd.mChannelsPerFrame =(int) _channelNum;
    asbd.mFramesPerPacket = 1;
    asbd.mBitsPerChannel = 16;
    asbd.mBytesPerFrame = asbd.mBitsPerChannel / 8 * asbd.mChannelsPerFrame;
    asbd.mBytesPerPacket = asbd.mBytesPerFrame * asbd.mFramesPerPacket;
    AudioUnitSetProperty(_recordingUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &asbd, sizeof(asbd));
    
    AURenderCallbackStruct callback;
    callback.inputProcRefCon = (__bridge void *)(self);
    callback.inputProc = audioBufferHandler;
    AudioUnitSetProperty(_recordingUnit, kAudioOutputUnitProperty_SetInputCallback, kAudioUnitScope_Global, 1, &callback, sizeof(callback));
    
    // at last we initialize it
    status = AudioUnitInitialize(_recordingUnit);
    if (noErr != status) {
        NSLog(@"error when initialize recoiding unit");
    }
}

- (void)dealloc {
    [self removeNotifications];
    
    if (_recordingUnit) {
        AudioComponentInstanceDispose(_recordingUnit);
    }
}
- (void)startRecording {
    
    if (!self.isValid) {
        return;
    }
    
    if (self.stopped) {
        self.stopped = NO;
        
        AudioOutputUnitStart(_recordingUnit);
    }
}

- (void)stopRecording {
    if (!self.stopped) {
        self.stopped = YES;
        
        AudioOutputUnitStop(_recordingUnit);
    }
}


@end
