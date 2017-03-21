//
//  XDJellyViewTestController.m
//  XDCommonLib
//
//  Created by SuXinDe on 2017/3/22.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import "XDJellyViewTestController.h"
#import "XDJellyView.h"


@interface XDJellyViewTestController ()

@end

@implementation XDJellyViewTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XDJellyView *jellyView = [[XDJellyView alloc] initWithFrame:self.view.bounds];
    jellyView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:jellyView];
}

@end
