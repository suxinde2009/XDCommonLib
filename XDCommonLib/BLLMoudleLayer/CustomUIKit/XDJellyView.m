//
//  XDJellyView.m
//  XDCommonLib
//
//  Created by SuXinDe on 2017/3/22.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import "XDJellyView.h"

#define DEVICE_WIDTH    ([[UIScreen mainScreen] bounds].size.width)                  // 屏幕宽度
#define DEVICE_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)                 // 屏幕长度
#define MIN_HEIGHT          100

@interface XDJellyView ()

@property (nonatomic, assign) CGFloat height;

//红色点的坐标的x值
@property (nonatomic, assign) CGFloat curveX;

//红色点的坐标的Y值
@property (nonatomic, assign) CGFloat curveY;

//红色的点对应的视图
@property (nonatomic, strong) UIView *curveView;

//形状对应的layer
@property (nonatomic, strong) CAShapeLayer *shareLayer;

//用于多次运行shareLayer的形状变换
@property (nonatomic, strong) CADisplayLink *displayLink;

//shareLayer形状变化是否进行中...
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation XDJellyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _shareLayer = [CAShapeLayer layer];
        _shareLayer.fillColor = [UIColor blueColor].CGColor;
        [self.layer addSublayer:_shareLayer];
        
        // _curveView就是r5点
        _curveX = DEVICE_WIDTH/2.0f;
        _curveY = MIN_HEIGHT;
        _curveView = [[UIView alloc] initWithFrame:CGRectMake(_curveX, _curveY, 3, 3)];
        _curveView.backgroundColor = [UIColor redColor];
        [self addSubview:_curveView];
        
        _height = 100;      // 手势移动时相对高度
        _isAnimating = NO;  // 是否处于动效状态
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:pan];
        
        //CADisplayLink默认每秒运行60次calculatePath是算出在运行期间_curveView的坐标，从而确定_shapeLayer的形状
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calculatePath)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink.paused = YES;
    }
    [self updateShapeLayerPath];
    return self;
}

- (void)handlePanAction:(UIPanGestureRecognizer *)pan {
    if (!_isAnimating) {
        if (pan.state == UIGestureRecognizerStateChanged) {
           
             // 手势移动时，_shapeLayer跟着手势向下扩大区域
            
            CGPoint point = [pan translationInView:self];
            
            // 这部分代码使r5红点跟着手势走
            _height = point.y*0.7 + MIN_HEIGHT;
            _curveX = DEVICE_WIDTH/2.0f + point.x;
            _curveY = MAX(_height, MIN_HEIGHT);
            _curveView.frame = CGRectMake(_curveX, _curveY, _curveView.frame.size.width, _curveView.frame.size.height);
            
            // 根据r5的坐标,更新_shapeLayer形状
            [self updateShapeLayerPath];
            
        } else if (pan.state == UIGestureRecognizerStateCancelled ||
                   pan.state == UIGestureRecognizerStateEnded ||
                   pan.state == UIGestureRecognizerStateFailed) {
            
            // 手势结束时,_shapeLayer返回原状并产生弹簧动效
            _isAnimating = YES;
            
            //这个对象开始执行，calculatePath被多次调用
            _displayLink.paused = NO;
            
            // 弹簧动画
            [UIView animateWithDuration:1.0f
                                  delay:0.0f
                 usingSpringWithDamping:0.5f
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 
                                 // 曲线点(r5点)是一个view.所以在block中有弹簧效果.然后根据他的动效路径,在calculatePath中计算弹性图形的形状
                                 _curveView.frame = CGRectMake(DEVICE_WIDTH/2.0f, MIN_HEIGHT, 3, 3);
                                 
                             }
                             completion:^(BOOL finished) {
                
                                 if (finished) {
                                     _displayLink.paused = YES;
                                     _isAnimating = NO;
                                 }
                                 
                             }];
        }
    }
}


#pragma mark 每次更新的时候，都初始化一个path，然后重新绘制shapelayer
- (void)updateShapeLayerPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];                        // r1点
    [path addLineToPoint:CGPointMake(DEVICE_WIDTH, 0)];          // r2点
    [path addLineToPoint:CGPointMake(DEVICE_WIDTH, MIN_HEIGHT)]; // r4
    
    [path addQuadCurveToPoint:CGPointMake(0, MIN_HEIGHT) //  r3,r4,r5确定的一个弧线
                 controlPoint:CGPointMake(_curveX, _curveY)];
    [path closePath];
    _shareLayer.path = path.CGPath;
}

- (void)calculatePath {
    // 由于手势结束时,r5执行了一个UIView的弹簧动画,把这个过程的坐标记录下来,并相应的画出_shapeLayer形状
    CALayer *layer = _curveView.layer.presentationLayer;
    _curveX = layer.position.x;
    _curveY = layer.position.y;
    [self updateShapeLayerPath];
}


@end























