//
//  GradientViewController.m
//  XDCommonLib
//
//  Created by suxinde on 2017/2/21.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import "GradientViewController.h"
#import "UIColor+Gradient.h"

/**
 *  颜色值转换
 */
#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]

#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#define RGBAHEX(hex,a)    RGBACOLOR((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),a)


@interface GradientViewController ()

@property (nonatomic, weak) IBOutlet UIView *view1;
@property (nonatomic, weak) IBOutlet UIView *view2;

@end

@implementation GradientViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor * color1 = [UIColor gradientFromColor:RGBCOLOR(255, 138, 111)
                                          toColor:RGBCOLOR(253, 73, 101)
                                       withHeight:self.view.bounds.size.height];
    self.view1.backgroundColor = color1;
    
    UIColor * color2 = [UIColor gradientFromColor:RGBCOLOR(173, 178, 188)
                                          toColor:RGBCOLOR(52, 58, 69)
                                       withHeight:self.view.bounds.size.height];
    self.view2.backgroundColor = color2;
}


@end
