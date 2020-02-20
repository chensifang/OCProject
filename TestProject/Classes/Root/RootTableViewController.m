//
//  RootTableViewController.m
//  TestProject
//
//  Created by chen on 7/6/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "RootTableViewController.h"
#import "NSObject+AOP.h"
#import "NSObject+Extension.h"

@interface RootTableViewController () 

@end

@implementation RootTableViewController

+ (void)load {
    
}

- (void)viewDidDisappear:(BOOL)animated {
//    NSLog(@"%s", __func__);
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inCenter = NO;
    self.title = @"🤠Welcome";
    
    ADD_SECTION(@"算法");
    [self addCellWithTitle:@"算法" nextVC:@"AlgorithmViewController"];
    
    ADD_SECTION(@"三方库");
    [self addCellWithTitle:@"SDWebImage" nextVC:@"SDTestViewController"];
    [self addCellWithTitle:@"AFNetworking" nextVC:@"AFNetViewController"];
    ADD_SECTION(@"网络");
    [self addCellWithTitle:@"Socket" nextVC:@"SocketViewController"];
    [self addCellWithTitle:@"Session" nextVC:@"SessionViewController"];
    ADD_SECTION(@"Subjects");
    [self addCellWithTitle:@"Subjects" nextVC:@"SubjectViewController"];
    [self addCellWithTitle:@"性能优化" nextVC:@"OptimizationViewController"];
    ADD_SECTION(@"内存管理");
    [self addCellWithTitle:@"ARC 内存管理" nextVC:@"MMViewController"];
    [self addCellWithTitle:@"MRC 内存管理" nextVC:@"MRCViewController"];
    ADD_SECTION(@"OC 数据结构");
    [self addCellWithTitle:@"OC 数据结构" nextVC:@"OCStructViewController"];
    [self addCellWithTitle:@"KVO" nextVC:@"KVOViewController"];
    [self addCellWithTitle:@"Runloop" nextVC:@"RunloopViewController"];
    [self addCellWithTitle:@"Runtime" nextVC:@"RuntimeViewController"];
    
    ADD_SECTION(@"Block");
    [self addCellWithTitle:@"ARC Block" nextVC:@"BlockViewController"];
    [self addCellWithTitle:@"MRC Block" nextVC:@"MRCBlockViewController"];
    
    ADD_SECTION(@"多线程");
    [self addCellWithTitle:@"GCD" nextVC:@"GCDViewController"];
    [self addCellWithTitle:@"NSOperation" nextVC:@"OperationViewController"];
    [self addCellWithTitle:@"NSThread" nextVC:@"ThreadViewController"];
    
    ADD_SECTION(@"界面");
    [self addCellWithTitle:@"CALayer" nextVC:@"LayerViewController"];
    [self addCellWithTitle:@"动画" nextVC:@"AnimationViewController"];
    [self addCellWithTitle:@"Bitmap,绘图" nextVC:@"BitmapViewController"];
    [self addCellWithTitle:@"Touch 传递响应" nextVC:@"TouchViewController"];
    [self addCellWithTitle:@"响应链" nextVC:@"ResponseChainVC"];
    [self addCellWithTitle:@"手势" nextVC:@"GestureViewController"];
    [self addCellWithTitle:@"Scroll 手势冲突" nextVC:@"TestScrollViewController"];
    [self addCellWithTitle:@"Some 控件" nextVC:@"UITestTableController"];
    ADD_SECTION(@"Foundation");
    [self addCellWithTitle:@"Foundation" nextVC:@"FoundationViewController"];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /* {{0, -64}, {320, 568}}. 导航控制器中有 scrollview, scrollview 子控件从64开始是因为 bounds 改了.  */
//    NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
}

@end
