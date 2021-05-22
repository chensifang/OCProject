//
//  TestViewController.m
//  OCProject
//
//  Created by chen on 7/1/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "LayerViewController.h"
#import "MyView.h"
#import "UIColor+Extension.h"
#import "NSTimer+Extension.h"
#import "NSObject+Extension.h"
#import "MyLayer.h"
#import "AnimationView.h"
#import "NSObject+AOP.h"

@interface LayerViewController () <CALayerDelegate>
@end

@implementation LayerViewController
- (void)reset {
    [self removeTopViews];
}

/**
 1. layer 的 position = 父控件的 frame 的中心点。
 2. anchorPoint 和 position 是重合的。anchorPoint 是指在 layer 本身的位置，position 是在父控件的中心位置。
 改变 anchorPoint 的时候是不会改变 position 的，所以改变了 anchorPoint 以后，因为 anchorPoint 和 position 还是重合的，所以 view 发生了位移。此处 position 就不在 layer 的中心了。
 3. 理解：找到 position， 把 view 上 anchorPoint 的位置钉在 position 上，完毕。如果 anchorPoint 是（0，0），就把左上角钉上去，如果是（1，0），就把右上角钉上去。。。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
//    _partTable = YES;
    ADD_SECTION(@"layer 基本属性");
    ADD_CELL(@"测试view的frame对layer bounds影响" , testViewFrame);
    ADD_CELL(@"测试锚点动画" , testArchorPoint);
    ADD_CELL(@"显示位置：锚点&位置", testPositionAndArchorPoint);
    ADD_CELL(@"测试图片" , testImageView);
    ADD_CELL(@"测试 bounds.origin" , testBoundsOrigin);
    ADD_CELL(@"测试 bounds.size" , testBoundsSize);
    ADD_SECTION(@"绘制相关");
    ADD_CELL(@"测试 layer.contents" , testSetLayerContents);
    ADD_CELL(@"测试一边圆角横线" , testLayerCorner);
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
    [super viewDidAppear:animated];
}

#pragma mark - ---- 测试view的frame对layer bounds影响
- (void)testViewFrame {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    [self.view addSubview:view];
    view.backgroundColor = kRandomColor;
    NSLog(@"%@", NSStringFromCGRect(view.layer.frame));
}

#pragma mark - ---- 测试 position & position
#pragma mark -- 锚点 和 position 决定显示位置
- (void)testPositionAndArchorPoint {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    view.backgroundColor = kRandomColor;
    [self.view addSubview:view];
    /* position: （只是默认）就是自己的中心点在父控件的位置，其实是锚点在父控件的位置，坐标系是父控件 */
    NSLog(@"position: %@", NSStringFromCGPoint(view.layer.position));
    /* anchorPoint: 默认0.5，0.5， 按宽高比例的点 */
    NSLog(@"anchorPoint: %@", NSStringFromCGPoint(view.layer.anchorPoint));
    /* 显示的原理是，找到父控件的 position 的点，找到自己的锚点，让其重合就唯一确定定了显示位置  */
    
    // 改变 position, 当然会改变 view.frame
    view.layer.position = CGPointMake(20, 20);
    NSLog(@"%@", NSStringFromCGRect(view.frame));
    
    // 改变锚点也是一样的
    view.layer.anchorPoint = CGPointMake(0 , 0);
    NSLog(@"%@", NSStringFromCGRect(view.frame));
}


- (void)testArchorPoint {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kRandomColor;
    /** view 的 frame 都是靠 layer 的 frame 实现的 */
    view.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:view];
    //    NSLog(@"%@", view.layer.position);
    
    // 秒针的例子
    CALayer *pointer = [[CALayer alloc] init];
    pointer.bounds = CGRectMake(0, 0, 20, 60);
    pointer.backgroundColor = kRandomColor.CGColor;
    pointer.position = CGPointMake(10, 60);
    pointer.anchorPoint = CGPointMake(0.5, 1);
    [view.layer addSublayer:pointer];
    [NSTimer sf_timerWithTimeSecond:1 repeats:YES block:^{
        static int i = 0;
        ++i;
        pointer.transform = CATransform3DMakeRotation(i*(M_PI * 2)/60.0, 0, 0, 1);
    }];
}

#pragma mark - ---- 测试 bounds
- (void)testBoundsOrigin {
    UIView *view = UIView.new;
    view.backgroundColor = kRandomColor;
    view.frame = CGRectMake(20, 20, 200, 200);
    // 改变 bounds x.y 影响的是子控件，x 改为20，意味着self.view 自身的坐标系的 x 从20开始，所以view.x = 20的时候会贴合到 self.view 的左端。
    self.view.bounds = CGRectMake(20, 20, self.view.bounds.size.width, self.view.bounds.size.height);
    NSLog(@"view.frame: %@", NSStringFromCGRect(view.frame));
    [self.view addSubview:view];
}

- (void)testBoundsSize {
    UIView *view = UIView.new;
    view.backgroundColor = kRandomColor;
    view.frame = CGRectMake(0, 0, 200, 200);
    UIView *view1 = UIView.new;
    view1.backgroundColor = kRandomColor;
    view1.frame = CGRectMake(0, 0, 200, 200);
    // 改变 bounds 的 size 会直接改变自己的 frame 的 size，但是自己在父控件的 center 不会变，会平均分配。
    view.bounds = CGRectMake(0, 0, 50, 100);
    NSLog(@"view.frame: %@", NSStringFromCGRect(view.frame));
    [self.view addSubview:view1];
    [self.view addSubview:view];
    UIView *view3 = UIView.new;
    view3.backgroundColor = kRandomColor;
    view3.frame = CGRectMake(0, 0, 20, 20);
    [view addSubview:view3];
}



#pragma mark - ---- 测试 imageView
/* view 的显示内容由 layer 的 contents 来决定，除了这个它还可以通过绘制添加 */
- (void)testImageView {
    UIImageView *imageView = UIImageView.alloc.init;
    imageView.image = [UIImage imageNamed:@"ICON"];
    imageView.frame = CGRectMake(100, 200, 200, 200);
//    [self.view addSubview:imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    view.backgroundColor = kRandomColor;
    /* 下面这句代码必须这样强转，直接用 UIImage 是没有效果的 */
    view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"ICON"].CGImage);
    [self.view addSubview:view];
}

#pragma mark - ---- 没有代理的 layer, 走系统绘制流程
- (void)testLayerNohasDelegate {
    MyLayer *layer = MyLayer.layer;
    layer.frame = CGRectMake(200, 100, 100, 100);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    [layer setNeedsDisplay];
}
#pragma mark - ---- 有代理的 layer
/**
 是否实现 displayLayer: 代理方法，实现了走这个，未实现走系统绘制流程,系统绘制流程走 - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
 */
- (void)testLayerHasDelegate {
    MyView *view = MyView.alloc.init;
    view.frame = CGRectMake(100, 100, 100, 100);
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

#pragma mark - ---- 测试直接设置 contents
- (void)testSetLayerContents {
    MyView *view = MyView.alloc.init;
    view.frame = CGRectMake(100, 100, 300, 300);
    view.backgroundColor = [UIColor redColor];
    view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"ICON"].CGImage);
    [self.view addSubview:view];
    /*
     只调用了  -[MyView setNeedsDisplay] 和 -[MyLayer setNeedsDisplay]
     都没有走 layer 的 displayer。 更不会走接下来的自己的绘制流程或者系统的绘制流程。
     */
}

- (void)testLayerCorner {
    UIView *card = [[UIView alloc] init];
    [self.view addSubview:card];
    card.width = kScreenWidth;
    card.height = 80;
    card.backgroundColor = [UIColor redColor];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:card.bounds
                                               byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                     cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = card.bounds;
    maskLayer.path = path.CGPath;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    card.layer.mask = maskLayer;
    
    UIView *bottom = [[UIView alloc] init];
    bottom.height = card.height;
    bottom.width = card.width;
    bottom.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottom];
    bottom.top = card.bottom;
    
}


@end
