//
//  NSMutableDictionary+ImageMetadata.h
//  XDCommonLib
//
//  Created by SuXinDe on 2017/8/20.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface NSMutableDictionary (ImageMetadataCategory)
#pragma mark init
- (instancetype)initWithImageSampleBuffer:(CMSampleBufferRef) imageDataSampleBuffer;

/*
 Be careful with this method: because it uses blocks, there's no guarantee that your
 imageMetadata dictionary will be populated when this code runs. In some testing I've
 done it sometimes runs the code inside the block even before the [library autorelease]
 is executed. But the first time you run this, the code inside the block will only run
 on another cycle of the apps main loop. So, if you need to use this info right away,
 it's better to schedule a method on the run queue for later with:
 
 [self performSelectorOnMainThread: withObject: waitUntilDone:NO];
 */
- (instancetype)initWithInfoFromImagePicker:(NSDictionary *)info withDelgate:(id)delegate;

/*
 Be careful with this method: because it uses blocks, there's no guarantee that your
 imageMetadata dictionary will be populated when this code runs. In some testing I've
 done it sometimes runs the code inside the block even before the [library autorelease]
 is executed. But the first time you run this, the code inside the block will only run
 on another cycle of the apps main loop. So, if you need to use this info right away,
 it's better to schedule a method on the run queue for later with:
 
 [self performSelectorOnMainThread: withObject: waitUntilDone:NO];
 */

- (instancetype)initFromAssetURL:(NSURL*)assetURL;

//从JPEG文件获取EXIF信息
- (instancetype) initWithFilePath:(NSString*) strFilePath;


#pragma mark
#pragma mark 必做
/**
 *  保存图像和EXIF信息之前必须校验尺寸和方向
 *
 *  @param aImage 图像对象
 */
-(void) checkUIImageInfo:(UIImage*)aImage;
#pragma mark
#pragma mark set










- (void)setUserComment:(NSString*)comment;


- (void)setDescription:(NSString*)description;
- (void)setKeywords:(NSString*)keywords;
- (void)setImageOrientarion:(UIImageOrientation)orientation;
- (void)setDigitalZoom:(CGFloat)zoom;
- (void)setHeading:(CLHeading*)heading;

#pragma mark
#pragma mark set
//设置日期
- (void)setDateOriginal:(NSString *)date;
- (void)setDateDigitized:(NSString *)date;
//设置光圈值
- (void) setApertureValue:(int) apertureValue;
//设置闪光灯
- (void) setFlash:(int)flash;
//设置曝光时间
- (void) setExposureTime:(float) exposureTime;
//设置曝光程序
- (void) setExposureProgram:(int) exposureProgram;
//设置曝光模式
- (void) setExposureMode:(int) exposureMode;
//设置镜头焦距
- (void) setFocalLength:(float) focalLength;
//设置F Number
- (void) setFNumber:(float) fNumber;
//设置图片的方向
- (void) setOrientation:(NSString*) strOrientation;
//设置公司、型号、软件    参数为nil时，不修改
- (void) setMake:(NSString*)make model:(NSString*)model software:(NSString*)software;
- (void) setMake:(NSString*)make;
- (void) setSoftware:(NSString*) software;
//设置感光度
- (void) setISOSpeedRatings:(int) ISOSpeedRatings;
- (void)setExif:(NSDictionary *)newExif;

#pragma mark
#pragma mark get
//获取尺寸
//-(NSString *)getImageSize;
////获取大小
//-(NSString *)getMemorySize;

//获取日期 日期字符串格式为：“2011:02:26 13:27:17”
- (NSString *) getDateOriginal;
- (NSString *) getDateDigitized;
//获取公司、型号、软件
- (NSString*) getMake;
- (NSString*) getModel;
- (NSString*) getSoftware;
- (NSDictionary *)getExif;

//获取测光模式
- (int) getMeteringMode;
//获取光圈值
- (int) getApertureValue;
//获取闪光灯
- (int) getFlash;
//获取曝光时间
- (float) getExposureTime;
//获取曝光程序
- (int) getExposureProgram;
//获取曝光模式
- (int) getExposureMode;
//获取镜头焦距
- (float) getFocalLength;
//获取感光值
- (int) getISOSpeedRatings;
//获取F Number
- (float)getFNumber;

@property (nonatomic, assign) CLLocation *location;
@property (nonatomic, assign) CLLocationDirection trueHeading;

@end

@protocol ImageMetadataCategoryProtocol <NSObject>

-(void)refreshExifInfoDic:(NSMutableDictionary *)exifInfoDic;

@end
