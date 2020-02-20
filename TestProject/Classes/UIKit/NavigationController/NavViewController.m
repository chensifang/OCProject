//
//  NavViewController.m
//  TestProject
//
//  Created by chen on 7/7/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()
@property (nonatomic, strong) UIScrollView *scroll;
@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
    [self scrollAdjust];
//    [self translucentAnd0];
//    [self translucentAnd64];
//    [self noTranslucentAnd64];
//    [self noTranslucentAnd0];
}
/*
 push/pop 是要消失的 view viewDidDisappear 先调用，要出现的 view viewDidAppear 后调用。
 present 相反。
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)test {
    self.navigationController.view.backgroundColor = [UIColor blueColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationController.toolbar.backgroundColor = kRandomColor;
    // 显示 toolbar。
//    self.navigationController.toolbarHidden = NO;
    
    /*
     导航控制器里的 view 默认依然是从0开始的。
     */
    NSLog(@"%@", self.view);
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *redView = UIView.alloc.init;
    redView.frame = CGRectMake(0, 0, 200, 200);
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(230, 0, 200, 200)];
    self.scroll = scroll;
    scroll.contentSize = CGSizeMake(0, 500);
    scroll.backgroundColor = [UIColor blueColor];
    [self.view addSubview:scroll];
    /* scroll 的 view 是从0开始，但是 scroll 的子控件却是从导航栏底部开始 */
    UIView *scrollSubView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    scrollSubView.backgroundColor = [UIColor yellowColor];
    [scroll addSubview:scrollSubView];
    NSLog(@"%d", self.navigationController.navigationBar.translucent);
}


#pragma mark - ---- 导航控制器内容4种情况
/*
 translucent: 是否透明。
 edgesForExtendedLayout: 从哪里开始。
 extendedLayoutIncludesOpaqueBars: 是否包含不透明的 bar，不透明还要从0开始就需要用到。
 */
// 透明并且从0开始， 这是 iOS7以后的默认设置
- (void)translucentAnd0{
    // iOS7 之前这个属性默认是 NO，因为是拟物的，不透明的。
    self.navigationController.navigationBar.translucent = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

// 透明并且从64开始（iPhoneX 从84）
- (void)translucentAnd64{
    self.navigationController.navigationBar.translucent = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

// 不透明并且从64开始（iPhoneX 从84）
- (void)noTranslucentAnd64 {
    // 设置为 NO 就默认从64开始。
    self.navigationController.navigationBar.translucent = NO;
}

// 不透明并且从0开始
- (void)noTranslucentAnd0 {
    // 设置为 NO 就默认从64开始。
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)scrollAdjust {
    /* 在透明情况下，scroll y=0的时候从0开始，但是子控件从64开始，这句代码取消从64开始，也就是不用自适应。 */
    if (@available(iOS 11.0, *)) {
        self.scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}


@end
