//
//  XDMicrophoneControl.h
//  XDCommonLib
//
//  Created by suxinde on 2016/11/7.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AudioUnit;

@class XDMicrophoneControl;
@protocol XDMicrophoneControlDelegate <NSObject>
@optional
- (void)microphoneControl:(XDMicrophoneControl *)micControl
    didReceiveAudioBuffer:(AudioBuffer *)audioBuffer;

@end

@interface XDMicrophoneControl : NSObject

- (instancetype)initWithSampleRate:(NSUInteger)sampleRate
                        channelNum:(NSUInteger)channelNum;

@property (nonatomic, weak) id<XDMicrophoneControlDelegate> bufferDelegate;

- (void)startRecording;

- (void)stopRecording;

@end
