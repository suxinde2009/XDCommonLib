//
//  MPMediaItem+Properties.h
//  XDCommonLib
//
//  Created by SuXinDe on 2018/1/22.
//  Copyright © 2018年 su xinde. All rights reserved.
//


#import <MediaPlayer/MediaPlayer.h>

@interface MPMediaItem (Properties)

@property (nonatomic, readonly) long long persistentID;
@property (nonatomic, readonly) NSInteger mediaType;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *albumTitle;
@property (nonatomic, readonly) NSString *artist;
@property (nonatomic, readonly) NSString *albumArtist;
@property (nonatomic, readonly) NSString *genre;
@property (nonatomic, readonly) NSString *composer;

@property (nonatomic, readonly) double playbackDuration;
@property (nonatomic, readonly) NSInteger albumTrackNumber;
@property (nonatomic, readonly) NSInteger albumTrackCount;
@property (nonatomic, readonly) NSInteger discNumber;
@property (nonatomic, readonly) NSInteger discCount;

@property (nonatomic, readonly) UIImage *artwork;
@property (nonatomic, readonly) NSString *lyrics;

@property (nonatomic, readonly) BOOL isCompilation;
@property (nonatomic, readonly) NSString *podcastTitle;

@property (nonatomic, readonly) NSInteger playCount;
@property (nonatomic, readonly) NSInteger skipCount;
@property (nonatomic, readonly) NSInteger rating;

@property (nonatomic, readonly) NSDate *lastPlayedDate;

@end
