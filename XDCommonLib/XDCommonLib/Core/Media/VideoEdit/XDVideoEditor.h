//
//  XDVideoEditor.h
//  XDCommonLib
//
//  Created by suxinde on 16/5/4.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^XDVideoEditProgressHandle)(CGFloat progress);

@interface XDVideoEditor : NSObject

+ (AVAsset *)assetByReversingAsset:(AVAsset *)asset
                  videoComposition:(AVMutableVideoComposition *)videoComposition
                          duration:(CMTime)duration
                         outputURL:(NSURL *)outputURL
                    progressHandle:(XDVideoEditProgressHandle)progressHandle
                            cancel:(BOOL *)cancel;

@end
