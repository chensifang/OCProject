//
//  OptimizationViewController.m
//  OCProject
//
//  Created by chensifang on 2018/9/6.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "OptimizationViewController.h"
#import "NSTimer+Extension.h"
//#import <YYAsyncLayer.h>
//#import "YYView.h"
//#import <YYLabel.h>

@interface OptimizationViewController ()

@end

@implementation OptimizationViewController
- (void)reset {
    [self removeTopViews];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.partTable = YES;
//    ADD_SECTION(@"离屏渲染");
//    ADD_CELL(@"设置圆角", cornerTest);
//    ADD_CELL(@"绘制圆角", drawImageForButton);
//    ADD_SECTION(@"异步绘制")
//    ADD_CELL(@"YYLayer 测试", YYAsyncLayerTest);
//}
//
//#pragma mark - ---- 异步绘制
///** 并非只能在 - (void)displayLayer:(CALayer *)layer 方法里写异步绘制，YYAsyncLayer 似乎就是直接写在 display 方法里的 */
//- (void)YYAsyncLayerTest {
//    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(20, 20, 100, 50)];
//    label.displaysAsynchronously = YES;
//    label.backgroundColor = [UIColor redColor];
//    label.text = @"hello world";
//    [self.view addSubview:label];
//}
//
//#pragma mark - ---- 离屏渲染
//#pragma mark -- 设置圆角
//- (void)cornerTest {
//    __block int i = 0;
//    [NSTimer sf_timerWithTimeSecond:0.1 repeats:YES block:^{
//        UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
//        icon.left = i++;
//        icon.top = i;
//        icon.width = icon.height = 100;
//        UIImage *image = [UIImage imageNamed:@"ICON"];
//        //        icon.image = [self drawCorner:image imageView:icon];
//        // 在 instrument 里面设置下面 2 句，GPU 消耗 20% 左右，不设置的话在 0% 左右
//        // iOS 9以后，imageview 设置圆角不触发离屏渲染，但是 button 还是会
//        icon.layer.masksToBounds = YES;
//        icon.layer.cornerRadius = icon.width * 0.5;
//        [icon setImage:image forState:(UIControlStateNormal)];
//        [self.view addSubview:icon];
//    }];
//}
//
//#pragma mark -- 绘制圆角
//// 这样写不会产生离屏渲染
//- (void)drawImageForButton {
//    __block int i = 0;
//    [NSTimer sf_timerWithTimeSecond:0.1 repeats:YES block:^{
//        UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
//        icon.left = i++;
//        icon.top = i;
//        icon.width = icon.height = 100;
//        UIImage *image = [UIImage imageNamed:@"ICON"];
//        [icon setImage:[self drawCorner:image view:icon] forState:(UIControlStateNormal)];
//        [self.view addSubview:icon];
//    }];
//}
//
//- (UIImage *)drawCorner:(UIImage *)image view:(UIView *)icon {
//    UIGraphicsBeginImageContext(CGSizeMake(icon.width, icon.height));
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGRect rect = CGRectMake(0, 0, icon.width, icon.height);
//    // 这就是画椭圆的函数
//    CGContextAddEllipseInRect(context, rect);
//    CGContextClip(context);
//    /* 要放在 CGContextClip 这句代码后面，表示在这个截取的上下文区域绘制 */
//    [image drawInRect:CGRectMake(0, 0, icon.width, icon.height)];
//    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return clipImage;
//}


@end
