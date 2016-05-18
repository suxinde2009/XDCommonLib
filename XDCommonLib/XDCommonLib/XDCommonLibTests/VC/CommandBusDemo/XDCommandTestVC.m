//
//  XDCommandTestVC.m
//  XDCommonLib
//
//  Created by suxinde on 16/5/11.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import "XDCommandTestVC.h"

#import "XDCommandBus.h"
#import "LoginCommand.h"

@interface XDCommandTestVC ()

@property(nonatomic, strong) XDCommandBus *commandBus;

@end

@implementation XDCommandTestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.commandBus = [[XDCommandBus alloc] init];
    [self performLogin];
}

- (void)performLogin
{
    LoginCommand *loginCommand = [LoginCommand new];
    
    loginCommand.username = @"SXD";
    loginCommand.password = @"password";
    
    [self.commandBus executeCommand:loginCommand withCompletion:^(id result) {
        NSLog(@"%s: %@", __func__, result);
    }];
}

@end
