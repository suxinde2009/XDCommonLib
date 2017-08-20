//
//  NSMutableDictionary+ImageMetadata.m
//  XDCommonLib
//
//  Created by SuXinDe on 2017/8/20.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import "NSMutableDictionary+ImageMetadata.h"
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

/* Add this before each category implementation, so we don't have to use -all_load or -force_load
 * to load object files from static libraries that only contain categories and no classes.
 *
 * See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.
 */

@interface FIX_CATEGORY_BUG_ImageMetadataCategory:NSObject @end
@implementation FIX_CATEGORY_BUG_ImageMetadataCategory @end


@implementation NSMutableDictionary (ImageMetadataCategory)
@dynamic trueHeading;
#pragma mark init
- (instancetype)initWithImageSampleBuffer:(CMSampleBufferRef) imageDataSampleBuffer {
    
    // Dictionary of metadata is here
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
    
    // Just init with it....
    self = [self initWithDictionary:(__bridge NSDictionary*)metadataDict];
    
    // Release it
    if (metadataDict) {
        CFRelease(metadataDict);
    }
    return self;
}

- (instancetype)initWithInfoFromImagePicker:(NSDictionary *)info withDelgate:(id)delegate
{
    if ((self = [self init]))
    {
        // Key UIImagePickerControllerReferenceURL only exists in iOS 4.1
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.1f) {
            
            NSURL* assetURL = nil;
            if ((assetURL = [info objectForKey:UIImagePickerControllerReferenceURL])) {
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library assetForURL:assetURL
                         resultBlock:^(ALAsset *asset)  {
                             NSDictionary *metadata = asset.defaultRepresentation.metadata;
                             [self addEntriesFromDictionary:metadata];
                             if ([delegate respondsToSelector:@selector(refreshExifInfoDic:)]) {
                                 [delegate performSelectorOnMainThread:@selector(refreshExifInfoDic:) withObject:self waitUntilDone:NO];
                             }
                         }
                        failureBlock:^(NSError *error) {
                            if ([delegate respondsToSelector:@selector(refreshExifInfoDic:)]) {
                                [delegate performSelectorOnMainThread:@selector(refreshExifInfoDic:) withObject:self waitUntilDone:NO];
                            }
                        }];
            }
            else
            {
                NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
                if (metadata)
                {
                    [self addEntriesFromDictionary:metadata];
                    if ([delegate respondsToSelector:@selector(refreshExifInfoDic:)]) {
                        [delegate performSelectorOnMainThread:@selector(refreshExifInfoDic:) withObject:self waitUntilDone:NO];
                    }
                }
                
            }
        }
    }
    NSLog(@"照片信息:%@",self);
    return self;
}

//从JPEG文件获取EXIF信息
- (id) initWithFilePath:(NSString*) strFilePath
{
    NSURL *myURL = [NSURL fileURLWithPath:strFilePath];
    CGImageSourceRef mySourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)myURL, NULL);
    NSDictionary *myMetadata = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(mySourceRef,0,NULL));
    
    self = [self initWithDictionary:myMetadata];
    //    CFRelease((__bridge CFTypeRef)(myMetadata));
    CFRelease(mySourceRef);
    return self;
}
- (instancetype)initFromAssetURL:(NSURL*)assetURL {
    
    if ((self = [self init])) {
        NSURL* assetURL = nil;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:assetURL
                 resultBlock:^(ALAsset *asset)  {
                     NSDictionary *metadata = asset.defaultRepresentation.metadata;
                     [self addEntriesFromDictionary:metadata];
                 }
                failureBlock:^(NSError *error) {
                }];
    }
    
    return self;
}
#pragma mark
#pragma mark set












// Mostly from here: http://stackoverflow.com/questions/3884060/need-help-in-saving-geotag-info-with-photo-on-ios4-1
- (void)setLocation:(CLLocation *)location {
    
    if (location) {
        
        CLLocationDegrees exifLatitude  = location.coordinate.latitude;
        CLLocationDegrees exifLongitude = location.coordinate.longitude;
        
        NSString *latRef;
        NSString *lngRef;
        if (exifLatitude < 0.0) {
            exifLatitude = exifLatitude * -1.0f;
            latRef = @"S";
        } else {
            latRef = @"N";
        }
        
        if (exifLongitude < 0.0) {
            exifLongitude = exifLongitude * -1.0f;
            lngRef = @"W";
        } else {
            lngRef = @"E";
        }
        
        NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
        if ([self objectForKey:(NSString*)kCGImagePropertyGPSDictionary]) {
            [locDict addEntriesFromDictionary:[self objectForKey:(NSString*)kCGImagePropertyGPSDictionary]];
        }
        [locDict setObject:location.timestamp forKey:(NSString*)kCGImagePropertyGPSTimeStamp];
        [locDict setObject:latRef forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
        [locDict setObject:[NSNumber numberWithFloat:exifLatitude] forKey:(NSString*)kCGImagePropertyGPSLatitude];
        [locDict setObject:lngRef forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
        [locDict setObject:[NSNumber numberWithFloat:exifLongitude] forKey:(NSString*)kCGImagePropertyGPSLongitude];
        [locDict setObject:[NSNumber numberWithFloat:location.horizontalAccuracy] forKey:(NSString*)kCGImagePropertyGPSDOP];
        [locDict setObject:[NSNumber numberWithFloat:location.altitude] forKey:(NSString*)kCGImagePropertyGPSAltitude];
        
        [self setObject:locDict forKey:(NSString*)kCGImagePropertyGPSDictionary];
    }
}

// Set heading while preserving location metadata, if it exists.
- (void)setHeading:(CLHeading *)locatioHeading {
    
    if (locatioHeading) {
        
        CLLocationDirection trueDirection = locatioHeading.trueHeading;
        NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
        if ([self objectForKey:(NSString*)kCGImagePropertyGPSDictionary]) {
            [locDict addEntriesFromDictionary:[self objectForKey:(NSString*)kCGImagePropertyGPSDictionary]];
        }
        [locDict setObject:@"T" forKey:(NSString*)kCGImagePropertyGPSImgDirectionRef];
        [locDict setObject:[NSNumber numberWithFloat:trueDirection] forKey:(NSString*)kCGImagePropertyGPSImgDirection];
        
        [self setObject:locDict forKey:(NSString*)kCGImagePropertyGPSDictionary];
    }
}

- (CLLocation*)location {
    NSDictionary *locDict = [self objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
    if (locDict) {
        
        CLLocationDegrees lat = [[locDict objectForKey:(NSString*)kCGImagePropertyGPSLatitude] floatValue];
        CLLocationDegrees lng = [[locDict objectForKey:(NSString*)kCGImagePropertyGPSLongitude] floatValue];
        NSString *latRef = [locDict objectForKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
        NSString *lngRef = [locDict objectForKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
        
        if ([@"S" isEqualToString:latRef])
            lat *= -1.0f;
        if ([@"W" isEqualToString:lngRef])
            lng *= -1.0f;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        return location;
    }
    
    return nil;
}

- (CLLocationDirection)trueHeading {
    NSDictionary *locDict = [self objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
    CLLocationDirection heading = 0;
    if (locDict) {
        heading = [[locDict objectForKey:(NSString*)kCGImagePropertyGPSImgDirection] doubleValue];
    }
    
    return heading;
}

- (NSMutableDictionary *)dictionaryForKey:(CFStringRef)key {
    NSDictionary *dict = [self objectForKey:(__bridge NSString*)key];
    NSMutableDictionary *mutableDict;
    
    if (dict == nil) {
        mutableDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [self setObject:mutableDict forKey:(__bridge NSString*)key];
    } else {
        if ([dict isMemberOfClass:[NSMutableDictionary class]])
        {
            mutableDict = (NSMutableDictionary*)dict;
        } else {
            mutableDict = [dict mutableCopy];
            [self setObject:mutableDict forKey:(__bridge NSString*)key];
        }
    }
    
    return mutableDict;
}


#define EXIF_DICT [self dictionaryForKey:kCGImagePropertyExifDictionary]
#define TIFF_DICT [self dictionaryForKey:kCGImagePropertyTIFFDictionary]
#define IPTC_DICT [self dictionaryForKey:kCGImagePropertyIPTCDictionary]

#pragma mark
#pragma mark set

- (void)setUserComment:(NSString*)comment {
    [EXIF_DICT setObject:comment forKey:(NSString*)kCGImagePropertyExifUserComment];
}

- (void)setDateOriginal:(NSString *)date {
    //    [EXIF_DICT setObject:date forKey:(NSString*)kCGImagePropertyExifDateTimeOriginal];
    //    [TIFF_DICT setObject:date forKey:(NSString*)kCGImagePropertyTIFFDateTime];
    
    //    NSMutableDictionary *exifDict = EXIF_DICT;
    //    [exifDict setObject:date forKey:(NSString*)kCGImagePropertyExifDateTimeOriginal];
    //    NSMutableDictionary *tiffDict = TIFF_DICT;
    //    [tiffDict setObject:date forKey:(NSString*)kCGImagePropertyTIFFDateTime];
    
    NSString *dateString = date;
    [EXIF_DICT setObject:dateString forKey:(NSString*)kCGImagePropertyExifDateTimeOriginal];
    [TIFF_DICT setObject:dateString forKey:(NSString*)kCGImagePropertyTIFFDateTime];
    
}

- (void)setDateDigitized:(NSString *)date {
    NSMutableDictionary *exifDict = EXIF_DICT;
    [exifDict setObject:date forKey:(NSString*)kCGImagePropertyExifDateTimeDigitized];
}
- (void) setOrientation:(NSString*) strOrientation
{
    NSMutableDictionary *tiffDict = TIFF_DICT;
    [tiffDict setObject:strOrientation forKey:(NSString*)kCGImagePropertyTIFFOrientation];
    
    [self setObject:strOrientation forKey:(NSString*)kCGImagePropertyOrientation];
}
-(void) checkUIImageInfo:(UIImage*)aImage
{
    if ([self count] ==0)
    {
        return ;
    }
    //方向
    NSNumber* numberOrientation = [NSNumber numberWithInt:1];
    [self setObject:numberOrientation
             forKey:(NSString*)kCGImagePropertyOrientation];
    [TIFF_DICT setObject:numberOrientation
                  forKey:(NSString*)kCGImagePropertyTIFFOrientation];
    //尺寸
    int nWidth = (int)(aImage.size.width);
    int nHeight = (int)(aImage.size.height);
    NSNumber* numberWidth = [NSNumber numberWithInt:nWidth];
    NSNumber* numberHeight = [NSNumber numberWithInt:nHeight];
    [self setObject:numberWidth
             forKey:(NSString*)kCGImagePropertyPixelWidth];
    [self setObject:numberHeight
             forKey:(NSString*)kCGImagePropertyPixelHeight];
    [EXIF_DICT setObject:numberWidth
                  forKey:(NSString*)kCGImagePropertyExifPixelXDimension];
    [EXIF_DICT setObject:numberHeight
                  forKey:(NSString*)kCGImagePropertyExifPixelYDimension];
}

- (void) setMake:(NSString*)make
{
    NSMutableDictionary *tiffDict = TIFF_DICT;
    [tiffDict setObject:make forKey:(NSString*)kCGImagePropertyTIFFMake];
}

- (void) setSoftware:(NSString*) software
{
    NSMutableDictionary *tiffDict = TIFF_DICT;
    [tiffDict setObject:software forKey:(NSString*)kCGImagePropertyTIFFSoftware];
}


- (void)setMake:(NSString*)make model:(NSString*)model software:(NSString*)software {
    NSMutableDictionary *tiffDict = TIFF_DICT;
    if (make)
    {
        [tiffDict setObject:make forKey:(NSString*)kCGImagePropertyTIFFMake];
    }
    if (model) {
        [tiffDict setObject:model forKey:(NSString*)kCGImagePropertyTIFFModel];
    }
    if (software) {
        [tiffDict setObject:software forKey:(NSString*)kCGImagePropertyTIFFSoftware];
    }
}

//设置感光度
- (void) setISOSpeedRatings:(int) ISOSpeedRatings
{
    
    [EXIF_DICT setObject:[NSArray arrayWithObject:[NSNumber numberWithInt:ISOSpeedRatings]] forKey:(NSString*)kCGImagePropertyExifISOSpeedRatings];
}

- (void) setExposureTime:(float) exposureTime
{
    [EXIF_DICT setObject:[NSNumber numberWithFloat:exposureTime] forKey:(NSString*)kCGImagePropertyExifExposureTime];
    
}
- (void) setExposureMode:(int)exposureMode
{
    [EXIF_DICT setObject:[NSNumber numberWithInt:exposureMode] forKey:(NSString*)kCGImagePropertyExifExposureMode];
}
- (void) setFocalLength:(float)focalLength
{
    [EXIF_DICT setObject:[NSNumber numberWithFloat:focalLength] forKey:(NSString*)kCGImagePropertyExifFocalLength];
}


- (void) setApertureValue:(int) apertureValue
{
    [EXIF_DICT setObject:[NSNumber numberWithInt:apertureValue] forKey:(NSString*)kCGImagePropertyExifApertureValue];
}

- (void) setFlash:(int)flash
{
    [EXIF_DICT setObject:[NSNumber numberWithInt:flash] forKey:(NSString*)kCGImagePropertyExifFlash];
}

- (void) setFNumber:(float) fNumber
{
    [EXIF_DICT setObject:[NSNumber numberWithFloat:fNumber] forKey:(NSString*)kCGImagePropertyExifFNumber];
}

//0     Not defined
//1     Manual
//2     Normal program
- (void) setExposureProgram:(int) exposureProgram
{
    [EXIF_DICT setObject:[NSNumber numberWithInt:exposureProgram] forKey:(NSString*)kCGImagePropertyExifExposureProgram];
}

- (void)setDescription:(NSString*)description {
    [TIFF_DICT setObject:description forKey:(NSString*)kCGImagePropertyTIFFImageDescription];
}

- (void)setKeywords:(NSString*)keywords {
    [IPTC_DICT setObject:keywords forKey:(NSString*)kCGImagePropertyIPTCKeywords];
}

- (void)setDigitalZoom:(CGFloat)zoom {
    [EXIF_DICT setObject:[NSNumber numberWithFloat:zoom] forKey:(NSString*)kCGImagePropertyExifDigitalZoomRatio];
}


/* The intended display orientation of the image. If present, the value
 * of this key is a CFNumberRef with the same value as defined by the
 * TIFF and Exif specifications.  That is:
 *   1  =  0th row is at the top, and 0th column is on the left.
 *   2  =  0th row is at the top, and 0th column is on the right.
 *   3  =  0th row is at the bottom, and 0th column is on the right.
 *   4  =  0th row is at the bottom, and 0th column is on the left.
 *   5  =  0th row is on the left, and 0th column is the top.
 *   6  =  0th row is on the right, and 0th column is the top.
 *   7  =  0th row is on the right, and 0th column is the bottom.
 *   8  =  0th row is on the left, and 0th column is the bottom.
 * If not present, a value of 1 is assumed. */

// Reference: http://sylvana.net/jpegcrop/exif_orientation.html
- (void)setImageOrientarion:(UIImageOrientation)orientation {
    int o = 1;
    switch (orientation) {
        case UIImageOrientationUp:
            o = 1;
            break;
            
        case UIImageOrientationDown:
            o = 3;
            break;
            
        case UIImageOrientationLeft:
            o = 8;
            break;
            
        case UIImageOrientationRight:
            o = 6;
            break;
            
        case UIImageOrientationUpMirrored:
            o = 2;
            break;
            
        case UIImageOrientationDownMirrored:
            o = 4;
            break;
            
        case UIImageOrientationLeftMirrored:
            o = 5;
            break;
            
        case UIImageOrientationRightMirrored:
            o = 7;
            break;
    }
    NSMutableDictionary *tiffDict = TIFF_DICT;
    [tiffDict setObject:[NSNumber numberWithInt:o] forKey:(NSString*)kCGImagePropertyTIFFOrientation];
    [self setObject:[NSNumber numberWithInt:o] forKey:(NSString*)kCGImagePropertyOrientation];
}

#pragma mark
#pragma mark get
//-(NSString *)getImageSize
//{
//    return [self valueForKey:@"imageSizeInfo"];
//}
//
//
////获取大小
//-(NSString *)getMemorySize
//{
//    return [self objectForKey:(NSString*)kCGImagePropertyFileSize];
//}
//获取日期
- (NSString *) getDateOriginal
{
    NSString* strDate = [TIFF_DICT objectForKey:(NSString*)kCGImagePropertyTIFFDateTime];
    if (strDate == nil || [strDate compare:@""] == 0)
    {
        return [EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifDateTimeOriginal];
    }
    return strDate;
}
- (NSString *) getDateDigitized
{
    return [EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifDateTimeDigitized];
}

//获取公司、型号、软件
- (NSString*)getMake
{
    return [TIFF_DICT objectForKey:(NSString*)kCGImagePropertyTIFFMake];
}
- (NSString*) getModel
{
    return [TIFF_DICT objectForKey:(NSString*)kCGImagePropertyTIFFModel];
}
- (NSString*) getSoftware
{
    return [TIFF_DICT objectForKey:(NSString*)kCGImagePropertyTIFFSoftware];
}
//获取测光模式
- (int) getMeteringMode
{
    return [[EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifMeteringMode] intValue];
}
//获取光圈值
- (int) getApertureValue
{
    return [[EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifApertureValue] intValue];
}
//获取闪光灯
- (int) getFlash
{
    return [[EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifFlash] intValue];
}

//获取曝光时间
- (float) getExposureTime
{
    return [[EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifExposureTime] floatValue];
}
//获取曝光程序
- (int) getExposureProgram
{
    return [[EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifExposureProgram] intValue];
}
//获取曝光模式
- (int) getExposureMode
{
    return [[EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifExposureMode] intValue];
}
//获取镜头焦距
- (float) getFocalLength
{
    return [[EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifFocalLength] floatValue];
}

//感光值
- (int) getISOSpeedRatings
{
    NSNumber* numberTemp = [[EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifISOSpeedRatings] objectAtIndex:0];
    
    return [numberTemp intValue];
}

- (float)getFNumber {
    return [[EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifFNumber] floatValue];
}

- (NSDictionary *)getExif {
    return EXIF_DICT;
}

- (void)setExif:(NSDictionary *)newExif {
    [self setObject:newExif forKey:(NSString*)kCGImagePropertyExifDictionary];
}

@end
