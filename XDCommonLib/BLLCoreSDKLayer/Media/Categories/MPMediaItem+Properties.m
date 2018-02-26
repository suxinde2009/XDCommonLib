//
//  MPMediaItem+Properties.m
//  XDCommonLib
//
//  Created by SuXinDe on 2018/1/22.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import "MPMediaItem+Properties.h"

/*
 NSString *const MPMediaItemPropertyPersistentID;      // filterable
 NSString *const MPMediaItemPropertyMediaType;         // filterable
 NSString *const MPMediaItemPropertyTitle;             // filterable
 NSString *const MPMediaItemPropertyAlbumTitle;        // filterable
 NSString *const MPMediaItemPropertyArtist;            // filterable
 NSString *const MPMediaItemPropertyAlbumArtist;       // filterable
 NSString *const MPMediaItemPropertyGenre;             // filterable
 NSString *const MPMediaItemPropertyComposer;          // filterable
 NSString *const MPMediaItemPropertyPlaybackDuration;
 NSString *const MPMediaItemPropertyAlbumTrackNumber;
 NSString *const MPMediaItemPropertyAlbumTrackCount;
 NSString *const MPMediaItemPropertyDiscNumber;
 NSString *const MPMediaItemPropertyDiscCount;
 NSString *const MPMediaItemPropertyArtwork;
 NSString *const MPMediaItemPropertyLyrics;
 NSString *const MPMediaItemPropertyIsCompilation;     // filterable
 
 NSString *const MPMediaItemPropertyPodcastTitle;     // filterable
 
 NSString *const MPMediaItemPropertyPlayCount;
 NSString *const MPMediaItemPropertySkipCount;
 NSString *const MPMediaItemPropertyRating;
 NSString *const MPMediaItemPropertyLastPlayedDate;
 */

@implementation MPMediaItem (Properties)

- (long long) persistentID {
    return [[self valueForProperty:MPMediaItemPropertyPersistentID] longLongValue];
}

- (NSInteger) mediaType {
    return [[self valueForProperty:MPMediaItemPropertyMediaType] intValue];
}

- (NSString *) title {
    return [self valueForProperty:MPMediaItemPropertyTitle];
}

- (NSString *) albumTitle {
    return [self valueForProperty:MPMediaItemPropertyAlbumTitle];
}

- (NSString *) artist {
    return [self valueForProperty:MPMediaItemPropertyArtist];
}

- (NSString *) albumArtist {
    return [self valueForProperty:MPMediaItemPropertyAlbumArtist];
}

- (NSString *) genre {
    return [self valueForProperty:MPMediaItemPropertyGenre];
}

- (NSString *) composer {
    return [self valueForProperty:MPMediaItemPropertyComposer];
}

- (double) playbackDuration {
    return [[self valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
}

- (NSInteger) albumTrackNumber {
    return [[self valueForProperty:MPMediaItemPropertyAlbumTrackNumber] intValue];
}

- (NSInteger) albumTrackCount {
    return [[self valueForProperty:MPMediaItemPropertyAlbumTrackCount] intValue];
}

- (NSInteger) discNumber {
    return [[self valueForProperty:MPMediaItemPropertyDiscNumber] intValue];
}

- (NSInteger) discCount {
    return [[self valueForProperty:MPMediaItemPropertyDiscCount] intValue];
}

- (UIImage *) artwork {
    MPMediaItemArtwork *artwork = [self valueForProperty: MPMediaItemPropertyArtwork];
    return [artwork imageWithSize:CGSizeMake(256.0f, 256.0f)];
}

- (NSString *) lyrics {
    return [self valueForProperty:MPMediaItemPropertyLyrics];
}

- (BOOL) isCompilation {
    return [[self valueForProperty:MPMediaItemPropertyIsCompilation] boolValue];
}

- (NSString *) podcastTitle {
    return [self valueForProperty:MPMediaItemPropertyPodcastTitle];
}

- (NSInteger) playCount {
    return [[self valueForProperty:MPMediaItemPropertyPlayCount] intValue];
}

- (NSInteger) skipCount {
    return [[self valueForProperty:MPMediaItemPropertySkipCount] intValue];
}

- (NSInteger) rating {
    return [[self valueForProperty:MPMediaItemPropertyRating] intValue];
}

- (NSDate *) lastPlayedDate {
    return [self valueForProperty:MPMediaItemPropertyLastPlayedDate];
}

/*
 TestCase:
- (void) action: (UIBarButtonItem *) bbi
{
    self.log = [NSMutableString string];
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    MPMediaPropertyPredicate *mpp = [MPMediaPropertyPredicate
                                     predicateWithValue:@"road"
                                     forProperty:MPMediaItemPropertyTitle
                                     comparisonType:MPMediaPredicateComparisonContains];
    [query addFilterPredicate:mpp];
    
    NSArray *collections = query.collections;
    [self doLog:@"You have %d matching tracks in your library\n", collections.count];
    
    for (MPMediaItemCollection *collection in collections)
    {
        for (MPMediaItem *item in [collection items])
            [self doLog:@"%@, %@", item.title, item.artist];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"artist contains[cd] %@", @"Joel"];
        NSArray *array = [[collection items] filteredArrayUsingPredicate:pred];
        for (MPMediaItem *item in array)
            [self doLog:@"Filtered: %@ %@", item.title, item.artist];
    }
}

 */
