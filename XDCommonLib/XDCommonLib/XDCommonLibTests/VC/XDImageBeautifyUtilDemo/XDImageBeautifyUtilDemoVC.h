//
//  XDImageBeautifyUtilDemoVC.h
//  XDCommonLib
//
//  Created by suxinde on 16/5/19.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDImageBeautifyUtilDemoVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property(nonatomic,strong)UIImage * image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;
@property(nonatomic,retain)NSArray * effectImages;

@end
