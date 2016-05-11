//
//  LoginCommand.h
//  XDCommonLib
//
//  Created by suxinde on 16/5/11.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const KDIDLOGINNOTIFICATION;

@interface LoginCommand : NSObject

@property(nonatomic, strong)NSString *username;
@property(nonatomic, strong)NSString *password;

@end
