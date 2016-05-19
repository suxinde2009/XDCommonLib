//
//  MulticastDelegateDemoVC.m
//  XDCommonLib
//
//  Created by su xinde on 15/5/6.
//  Copyright (c) 2015年 su xinde. All rights reserved.
//

#import "MulticastDelegateDemoVC.h"

#import "XDMulticastDelegate.h"

// -----------------------------------------------
// MulticastDeleate demo1
// -----------------------------------------------
@interface RSChat : NSObject
@end

@implementation RSChat

- (void)messageDidReceived:(NSString *) message
{
    NSLog(@"[in chat] : %@",message);
}

@end

@interface RSHistory : NSObject
@end

@implementation RSHistory

- (void)messageDidReceived:(NSString *) message
{
    NSLog(@"[in history] : %@",message);
}

@end

@interface MessageHandler : NSObject

@property (nonatomic,strong) id multicastDelegate;

- (void)acceptMessage;

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

@end

@protocol MessageHandlerDelegate

@optional
- (void)messageDidReceived:(NSString *) message;

@end

@implementation MessageHandler

- (id)init {
    
    self = [super init];
    if (self) {
        // init multicastDelegate
        _multicastDelegate = [[XDMulticastDelegate alloc]init];
    }
    return self;
}


- (void)acceptMessage{
    // send message to delegate
    NSString *s = @"hello";
    [self.multicastDelegate messageDidReceived:s];
    NSLog(@"[accept]:%@",s);
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    dispatch_block_t block = ^{
        [_multicastDelegate addDelegate:delegate delegateQueue:delegateQueue];
    };
    
    block();
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    dispatch_block_t block = ^{
        [_multicastDelegate removeDelegate:delegate delegateQueue:delegateQueue];
    };
    
    block();
}

@end


// -----------------------------------------------


// -----------------------------------------------
// MulticastDeleate demo2
// -----------------------------------------------

@protocol UserInfoHandlerDelegate

@optional
- (void)setText:(NSString *) text;

@end

@interface UserInfo : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) id<UserInfoHandlerDelegate> multicastDelegate;

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

@end

@implementation UserInfo

- (id)init
{
    if (self = [super init]) {
        _multicastDelegate = (id<UserInfoHandlerDelegate>)[[XDMulticastDelegate alloc] init];
    }
    return self;
}

- (void)setUserName:(NSString *)userName{
    _userName=userName;
    [_multicastDelegate setText:userName];//调用多播委托
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    dispatch_block_t block = ^{
        [(XDMulticastDelegate *)_multicastDelegate addDelegate:delegate delegateQueue:delegateQueue];
    };
    
    block();
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    dispatch_block_t block = ^{
        [(XDMulticastDelegate*)_multicastDelegate removeDelegate:delegate delegateQueue:delegateQueue];
    };
    
    block();
}


@end




// -----------------------------------------------

@interface MulticastDelegateDemoVC ()
{
    UserInfo *userInfo;
}
@end

@implementation MulticastDelegateDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self testCase1];
    
    NSLog(@"\n\n-----------------------------------------------\n\n");
    
    [self testCase2];
    
    
}

-  (void)testCase1
{
    MessageHandler *messageHandler = [[MessageHandler alloc]init];
    RSHistory *history = [[RSHistory alloc]init];
    RSChat *chat = [[RSChat alloc]init];
    
    [messageHandler addDelegate:history delegateQueue:dispatch_get_main_queue()];
    [messageHandler addDelegate:chat delegateQueue:dispatch_get_main_queue()];
    
    [messageHandler acceptMessage];
}

- (void)testCase2
{
    // http://www.2cto.com/kf/201410/345524.html

    //初始化一个userinfo的实例
    userInfo=[[UserInfo alloc] init];
    
    //添加一个lable
    UILabel *lbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 80, 100, 30)];
    lbl.backgroundColor=[UIColor blueColor];
    lbl.textColor=[UIColor blackColor];
    [userInfo addDelegate:lbl delegateQueue:dispatch_get_main_queue()];//向多播委托注册
    [self.view addSubview:lbl];
    
    lbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 130, 100, 30)];
    lbl.backgroundColor=[UIColor blueColor];
    lbl.textColor=[UIColor blackColor];
    [userInfo addDelegate:lbl delegateQueue:dispatch_get_main_queue()];
    [self.view addSubview:lbl];
    
    lbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 170, 100, 30)];
    lbl.backgroundColor=[UIColor blueColor];
    lbl.textColor=[UIColor blackColor];
    [userInfo addDelegate:lbl delegateQueue:dispatch_get_main_queue()];
    [self.view addSubview:lbl];
    
    //添加一个按钮
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(200, 90, 100, 50)];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setTitle:@"button1" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnCLicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)btnCLicked:(UIButton *)btn{
    userInfo.userName=@"123456";//给userInfo赋值
}

@end
