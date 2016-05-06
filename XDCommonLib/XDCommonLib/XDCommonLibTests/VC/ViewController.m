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

@interface ViewController ()
{
    NSMutableArray *mTestCases;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mTestCases = [@[] mutableCopy];
    [mTestCases addObject:@"多播委托-MulticastDelegateDemoVC"];
    [mTestCases addObject:@"测试非主线程刷新UI监测"];
    [mTestCases addObject:@"导出倒序播放的视频"];
    [mTestCases addObject:@"NSString+Tokenize"];
    
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
            
            BOOL isCancel = NO;
            
            
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
                                      } cancel:&isCancel];
            });
            

            
        } break;
            
        case 3:{
            
            //封装了CFStringTokenizer的NSString Category，可以方便的应用于Mac或者iOS APP， 其不但支持西方语言，更支持中文和日文这样没有空格分词的语言。
            
            NSString *inputString = @"Test / dsfasdfs";
            NSLog(@"TokensArray = %@", inputString.arrayWithWordTokenize);
            NSLog(@"%@", [inputString separatedStringWithSeparator:@"/"]);
            
        } break;
            
        case 4:{
            
        } break;
            
        case 5:{
            
        } break;
            
        case 6:{
            
        } break;
            
        case 7:{
            
        } break;
            
        default:
            break;
    }
}


#pragma mark - 


@end
