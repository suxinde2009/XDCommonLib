//
//  XDContact.h
//  XDCommonLib
//
//  Created by suxinde on 16/5/10.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XDContactEntity : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *numbers;
@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) UIImage *photo;


@end
