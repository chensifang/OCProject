//
//  TestScrollViewController.m
//  OCProject
//
//  Created by chen on 7/23/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "TestScrollViewController.h"
#import "ScrollSuperView.h"
#import "SFScrollView.h"
#import <ReactiveObjC.h>
#import "TapGesture.h"
#import "GrayView.h"
#import "SFSlider.h"

@interface TestScrollViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation TestScrollViewController
- (void)reset {
    [self removeTopViews];
    self.view.gestureRecognizers = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
    ADD_CELL(@"扩大 Scroll 的滚动范围" , upScroll);
    ADD_CELL(@"解决侧滑手势冲突" , solveGestureConflict);
    ADD_CELL(@"2个 scroll 叠加" , twoScroll);
    ADD_CELL(@"table 手势冲突" , tableGesture);
    ADD_CELL(@"slider 手势冲突" , sliderConflict);
    ADD_CELL(@"button 手势冲突" , buttonConflict);
    ADD_CELL(@"view 手势冲突" , viewConflict);
    
}

#pragma mark - ---- view 手势冲突
- (void)viewConflict {
    [self reset];
    SFScrollView *scroll1 = [[SFScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5 * self.topHeight)];
    [self.view addSubview:scroll1];
    scroll1.contentSize = CGSizeMake(1000, 0);
    scroll1.delegate = self;
    scroll1.backgroundColor = UIColor.redColor;
    
    GrayView *view = GrayView.alloc.init;
    view.frame = CGRectMake(100, 0, 100, 100);
    [scroll1 addSubview:view];
    /**
     1. 触摸到 view 后，150ms 内没有滑动手指，就会调用 view 的 touchBegan,后面滑动手指会调用 touchCancel，scroll 会滚动
     2. delaysContentTouches = NO，不会有150m，直接调用 view 的 touchBegan。
     3. canCancelContentTouches = NO， 一旦调用了 touchBegan 则不会调用 touchCancel，导致再怎么滑动手指，scroll 都不会滚动。
     */
//    scroll1.delaysContentTouches = NO;
//    scroll1.canCancelContentTouches = NO;
}

#pragma mark - ---- button 手势冲突
- (void)buttonConflict {
    [self reset];
    SFScrollView *scroll1 = [[SFScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5 * self.topHeight)];
    [self.view addSubview:scroll1];
    scroll1.contentSize = CGSizeMake(1000, 0);
    scroll1.delegate = self;
    scroll1.backgroundColor = UIColor.lightGrayColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchDown)];
    btn.frame = CGRectMake(100, 0, 100, 100);
    btn.backgroundColor = kRandomColor;
    [scroll1 addSubview:btn];
    
//    scroll1.delaysContentTouches = YES;
    scroll1.canCancelContentTouches = NO;
}

- (void)btnClick {
    NSLog(@"%s", __func__);
}

#pragma mark - ---- slider 手势冲突
- (void)sliderConflict {
    [self reset];
    SFScrollView *scroll1 = [[SFScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5 * self.topHeight)];
    [self.view addSubview:scroll1];
    scroll1.contentSize = CGSizeMake(1000, 0);
    scroll1.delegate = self;
    scroll1.backgroundColor = UIColor.lightGrayColor;
    
    /** 打印 slider 的手势为空，所以有些响应不是一定有手势的 */
    SFSlider *slider = [[SFSlider alloc] initWithFrame:CGRectMake(100, 0, 200, 20)];
    [scroll1 addSubview:slider];
//    scroll1.delaysContentTouches = NO;
//    scroll1.canCancelContentTouches = NO;
}

#pragma mark - ---- self.view 和 table 手势冲突
- (void)tableGesture {
    [self reset];
    TapGesture *ges = [[TapGesture alloc] initWithTarget:self action:@selector(clickSelfView)];
    ges.delegate = self;
    [self.view addGestureRecognizer:ges];
    /**
     1. 点击 cell 的时候不响应cell，响应的上面手势。
     2. 没有上面手势的情况下，如果在 table 的 touchBegin 不调用 super，cell 也不响应，说明 cell 是通过 table 的 touches实现的点击效果。
     3. 下面这个代码解决问题，cell 和 self.view 的手势都起作用,如果不调用下面这个方法，长按 cell 也是能响应的。
     */
    ges.cancelsTouchesInView = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    /** touch.view 是 cell 类型的就不让手势响应 */
    return ![touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")];
}

- (void)clickSelfView {
    NSLog(@"%s", __func__);
}

#pragma mark - ---- 两个 scroll 叠加
/** 2个滚动视图，滚动子视图，父子俩视图无规律响应，一会响应这个一会响应那个 */
- (void)twoScroll {
    [self reset];
    UIScrollView *scroll1 = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth - 200, 0.5 * self.topHeight)];
    [self.view addSubview:scroll1];
    scroll1.contentSize = CGSizeMake(1000, 0);
    scroll1.delegate = self;
    scroll1.backgroundColor = UIColor.lightGrayColor;
    
    UIScrollView *scroll2 = [[UIScrollView alloc] initWithFrame:CGRectMake(scroll1.width * 0.25, 0.25 * scroll1.height, scroll1.width * 0.5, 0.5 * scroll1.height)];
    scroll2.delegate = self;
    scroll2.backgroundColor = UIColor.yellowColor;
    scroll2.contentSize = CGSizeMake(1000, 0);
    [scroll1 addSubview:scroll2];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@ 滚动", scrollView.class);
}

#pragma mark - ---- 扩大 scroll 的滚动范围
- (void)upScroll {
    [self reset];
    ScrollSuperView *superView = [[ScrollSuperView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.75 * self.topHeight)];
    superView.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:superView];
    SFScrollView *scroll = [[SFScrollView alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth - 200, 0.5 * self.topHeight)];
    scroll.contentSize = CGSizeMake(1000, 0);
    scroll.backgroundColor = UIColor.redColor;
    [superView addSubview:scroll];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ICON"]];
    image.width = image.height = 100;
    [scroll addSubview:image];
}

#pragma mark 解决 scroll 和系统侧滑有冲突
/**
 子控件响应手势，他所有的父控件都会识别，但是不响应？？
 为什么叠加的控件都是子控件响应，但是 scroll 确实底下的侧滑响应？？
 
 */
- (void)solveGestureConflict {
    [self reset];
    ScrollSuperView *superView = [[ScrollSuperView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.75 * self.topHeight)];
    superView.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:superView];
    SFScrollView *scroll = [[SFScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5 * self.topHeight)];
    scroll.contentSize = CGSizeMake(1000, 0);
    scroll.backgroundColor = UIColor.redColor;
    [superView addSubview:scroll];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ICON"]];
    image.width = image.height = 100;
    [scroll addSubview:image];
    /**
     侧滑依赖于 scroll 的手势识别失败
     解决冲突。
     */
    
    [self.navigationController.interactivePopGestureRecognizer requireGestureRecognizerToFail:scroll.panGestureRecognizer];
}
@end
