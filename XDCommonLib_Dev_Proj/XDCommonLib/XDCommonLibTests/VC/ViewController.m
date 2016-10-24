//
//  ViewController.m
//  XDCommonLib
//
//  Created by su xinde on 15/5/5.
//  Copyright (c) 2015年 su xinde. All rights reserved.
//

#import "ViewController.h"

#import "MulticastDelegateDemoVC.h"
#import "XDVideoEditor.h"
#import "NSString+Tokenize.h"

#import "XDCameraViewController.h"
#import "XDCommandTestVC.h"
#import "XDImageBeautifyUtilDemoVC.h"
#import "LunarCore.h"

#import "UIViewController+IB.h"
#import "XDFluxDispatcherDemo.h"

#import "XDAESCryptUtils.h"
#import "NSString+XD_Encrypt_MD5.h"

#import "XDLogger.h"
#import "UIView+DebugUtils.h"

#import "BLEPrinterDemoVC.h"
#import "XDRuntimeInvokerTestVC.h"

#import "UIDevice+IPAddress.h"

#import "XDGCDThrottle.h"

static NSString *const SBTableLayoutTabVC = @"SBTableLayoutTabVC";

@interface ViewController ()
{
    NSMutableArray *mTestCases;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"IP Address: %@", [UIDevice getIPAddress:YES]);
    
    mTestCases = [@[] mutableCopy];
    [mTestCases addObject:@"多播委托-MulticastDelegateDemoVC"];
    [mTestCases addObject:@"测试非主线程刷新UI监测"];
    [mTestCases addObject:@"导出倒序播放的视频"];
    [mTestCases addObject:@"NSString+Tokenize"];
    [mTestCases addObject:@"自定义相机"];
    [mTestCases addObject:@"SBTableLayoutDemo"];
    [mTestCases addObject:@"CommandBus Demo"];
    [mTestCases addObject:@"农历测试"];
    [mTestCases addObject:@"简单的美化滤镜效果"];
    [mTestCases addObject:@"XDFluxDispatcherDemo"];
    [mTestCases addObject:@"testAES256"];
    [mTestCases addObject:@"XDLogger"];
    [mTestCases addObject:@"UIView+DebugUtils"];
    [mTestCases addObject:@"BLEPrinterDemoVC"];
    [mTestCases addObject:@"Paper Color"];
    [mTestCases addObject:@"XDRuntimeInvoker"];
}

- (void)testGCDThrottle
{
    dispatch_throttle(0.3, ^{
        NSLog(@"search: AAA");
    });
    
    dispatch_throttle_on_queue(0.3, THROTTLE_GLOBAL_QUEUE, ^{
        NSLog(@"search: BBB");
    });
    
    [XDGCDThrottle throttle:0.3 block:^{
        NSLog(@"search: CCC");
    }];
    
    [XDGCDThrottle throttle:0.3 queue:THROTTLE_GLOBAL_QUEUE block:^{
        NSLog(@"search: DDD");
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}


#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mTestCases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const identifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.text = mTestCases[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger idx = indexPath.row;
    
    switch (idx) {
        case 0:{
            MulticastDelegateDemoVC *controller = [[MulticastDelegateDemoVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        } break;
            
        case 1:{
            
            dispatch_async(dispatch_queue_create("com.bcg.queue", NULL), ^{
                [self.tableView reloadData];
            });
            
            
        } break;
            
        case 2:{
            
            BOOL *isCancel = NULL;
            
            NSString *sourceMoviePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
            NSURL *sourceMovieURL = [NSURL fileURLWithPath:sourceMoviePath];
            AVAsset *asset = [AVAsset assetWithURL:sourceMovieURL];
            [asset loadValuesAsynchronouslyForKeys:@[@"duration", @"tracks"] completionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }];
            
            NSString * temppath = NSTemporaryDirectory();
            temppath = [temppath stringByAppendingPathComponent:@"reversed.video"];
            BOOL exists =[[NSFileManager defaultManager] fileExistsAtPath:temppath isDirectory:NULL];
            if (!exists) {
                [[NSFileManager defaultManager] createDirectoryAtPath:temppath withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            NSString *filename = @"reversed.mp4";
            temppath = [temppath stringByAppendingPathComponent:filename];
            if ([[NSFileManager defaultManager] fileExistsAtPath:temppath isDirectory:NULL]) {
                [[NSFileManager defaultManager] removeItemAtPath:temppath error:NULL];
            }
            NSLog(@"%@",temppath);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [XDVideoEditor assetByReversingAsset:asset
                                    videoComposition:nil
                                            duration:asset.duration
                                           outputURL:[NSURL fileURLWithPath:temppath]
                                      progressHandle:^(CGFloat progress) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              NSLog(@"%@", [NSString stringWithFormat:@"%@ %%",@(progress*100)]);
                                          });
                                          NSLog(@"%@",@(progress*100));
                                      } cancel:isCancel];
            });
            

            
        } break;
            
        case 3:{
            
            //封装了CFStringTokenizer的NSString Category，可以方便的应用于Mac或者iOS APP， 其不但支持西方语言，更支持中文和日文这样没有空格分词的语言。
            
            NSString *inputString = @"Test / dsfasdfs";
            NSLog(@"TokensArray = %@", inputString.arrayWithWordTokenize);
            NSLog(@"%@", [inputString separatedStringWithSeparator:@"/"]);
            
        } break;
            
        case 4:{
            
            XDCameraViewController *cameraVC = [[XDCameraViewController alloc] init];
            [self.navigationController pushViewController:cameraVC animated:YES];
            
        } break;
            
        case 5:{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UITabBarController *tabController = [storyBoard instantiateViewControllerWithIdentifier:@"SBTableLayoutTabVC"];
            [self.navigationController pushViewController:tabController animated:YES];
            
        } break;
            
        case 6:{
            
            [self.navigationController pushViewController:[XDCommandTestVC new] animated:YES];
            
            
        } break;
            
        case 7:{
            
            NSDictionary *lunarCalendar = calendar(2016, 5);
            NSLog(@"%@", lunarCalendar);
            
        } break;
            
        case 8:{
            
            XDImageBeautifyUtilDemoVC *vc = [XDImageBeautifyUtilDemoVC instanceFromIB];
            [self.navigationController pushViewController:vc animated:YES];
            
        } break;
        case 9:{
            
            [XDFluxDispatcherDemo test];
            
        } break;
        case 10:{
            
            [self testAES256];
            
        } break;
            
        case 11:{
            
            XDLog(@"%@", @"测试");
            CC(@"%@", @"测试");
            
        } break;
            
        case 12: {
        
            [self.view drawBorderRecursive:YES];
            
        } break;
        
        case 13: {
            
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLEPrinterDemoVC"];
            [self.navigationController pushViewController:vc animated:YES];
            
        } break;
        
        case 14: {
            
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"PaperColorsDemo" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BFPaperColorListViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            
        } break;
            
        case 15: {
            
            XDRuntimeInvokerTestVC *controller = [[XDRuntimeInvokerTestVC alloc] initWithURL:[NSURL URLWithString:@"http://blog.csdn.net"]];
            [self.navigationController pushViewController:controller animated:YES];
            
        } break;
            
        default:
            break;
    }
}


#pragma mark - 

- (void)testAES256
{
    NSString *plainTxt = @"aaaaa";
    NSString *key = @"]EN,JI*@d[CmO=^7hzE).J[m4oIbL3#(";
    
    NSString *IVStr = @"c^S#ukjF#!q7rgfN";
    
    NSString *md5IVStr = [NSString MD5:IVStr];
    
    NSData *iv = [md5IVStr stringToHexData];//[md5IVStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    //    NSString *cipherTxt = [AESCrypt encrypt:plainTxt password:key];
    NSString *cipherTxt = [XDAESCryptUtils encrypt:plainTxt password:key iv:iv];
    
    NSLog(@"%@", cipherTxt);
    
    cipherTxt = @"0rae3ZY8qPVnw34Pthsoyw==";//@"kQk7sffQ22xa3+5SY3/maA==";
    
    //    NSString *decodeTxt = [AESCrypt decrypt:cipherTxt password:key];
    NSString *decodeTxt = [XDAESCryptUtils decrypt:cipherTxt password:key iv:iv];
    
    
    NSLog(@"%@", decodeTxt);
}


@end
