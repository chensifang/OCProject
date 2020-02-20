//
//  UITestViewController.m
//  TestProject
//
//  Created by chensifang on 2018/9/17.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "UIController.h"
#import "NSTimer+Extension.h"

@interface UIController ()

@end

@implementation UIController
/* {{0, -64}, {320, 568}}. 导航控制器中有 scrollview, scrollview 子控件从64开始是因为 bounds 改了.  */
//    NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"界面");
    [self addCellWithTitle:@"CALayer" nextVC:@"LayerViewController"];
    [self addCellWithTitle:@"绘制流程" nextVC:@"DisplayController"];
    ADD_SECTION(@"绘图动画");
    [self addCellWithTitle:@"动画" nextVC:@"AnimationViewController"];
    [self addCellWithTitle:@"CoreAnimation" nextVC:@"CoreAnimationController"];
    [self addCellWithTitle:@"Bitmap,绘图" nextVC:@"BitmapViewController"];
    [self addCellWithTitle:@"Touch 传递响应" nextVC:@"TouchViewController"];
    [self addCellWithTitle:@"响应链" nextVC:@"ResponseChainVC"];
    [self addCellWithTitle:@"手势" nextVC:@"GestureViewController"];
    [self addCellWithTitle:@"Scroll 手势冲突" nextVC:@"TestScrollViewController"];
    [self addCellWithTitle:@"Some 控件" nextVC:@"UITestTableController"];
    ADD_SECTION(@"新组")
    [self addCellWithTitle:@"新控制器" nextVC:@"DataController"];
    [self addCellWithTitle:@"测试 flutter" nextVC:@"FlutterTestController"];
    
}


@end
