//
//  ResponseChainVC.m
//  TestProject
//
//  Created by chen on 6/24/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "ResponseChainVC.h"
#import "SFSubview0.h"
#import "SFSubview1.h"
#import "UIColor+Extension.h"
#import "SFView.h"
#import "MyButton.h"
#import <ReactiveObjC.h>
#import "TouchHeader.h"

@interface ResponseChainVC ()
/*
 1.如果是 UIView，会顺着响应链往上走，逐级调用 touch 方法，
    自实现的话需要调用 super 才能往响应链下一个传递。
 2. button 不一样,会截断响应链。
 */
@property (weak, nonatomic) IBOutlet SFSubview0 *subview0;
@property (weak, nonatomic) IBOutlet SFSubview1 *subview1;
@property (nonatomic, strong) UIView *clickView;

@end

@implementation ResponseChainVC


- (void)reset {
    [self removeTopViews];
}

TouchMethods


- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
    ADD_CELL(@"响应超出父控件" , responseBeyondSuperView);
    ADD_CELL(@"扩大点击区域" , upRespondeClickRegion);
    ADD_CELL(@"log 响应链" , logResponders);
    ADD_CELL(@"测试 button" , testButton);
    ADD_CELL(@"layer 交换响应", layerExchange);
    

//    [self.subview0 addTarget:self action:@selector(click0:forEvent:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.subview1 addTarget:self action:@selector(click1:forEvent:) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark - ---- 重叠部分响应下面的，不用 hitTest
/**
 事实证明，view 的点击区域完全跟着 layer 走，layer 层级变了，view 跟着变。
 */
- (void)layerExchange {
    MyButton *button1 = [[MyButton alloc] initWithFrame:CGRectMake(20, 20, 200, 100)];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 200, 100)];
    button1.backgroundColor = UIColor.redColor;
    button2.backgroundColor = UIColor.blueColor;
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [[button1 rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"button1 响应");
    }];
    
    [[button2 rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"button2 响应");
    }];
    [button2.layer removeFromSuperlayer];
    [self.view.layer insertSublayer:button2.layer below:button1.layer];
    
}

#pragma mark - ---- 测试 button
- (void)testButton {
    MyButton *btn = [MyButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, 20, 100, 100);
    [self.view addSubview:btn];
    btn.backgroundColor = kRandomColor;
    /** btn 的 touchesBegan 注释掉之后就不会响应 clickBtn 方法 */
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:(UIControlEventTouchUpInside)];
    /** btn 里的 touch 方法识别后会调用下面的方法触发 clickBtn 方法 */
//    [btn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)clickBtn {
    NSLog(@"%s", __func__);
}

#pragma mark - ---- 响应子控件超出父控件的区域
- (void)responseBeyondSuperView {
    SFSubview0 *view = [[SFSubview0 alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
    view.backgroundColor = [UIColor redColor];
    view.text = @"父控件";
    [self.view addSubview:view];
    
    SFSubview1 *view1 = [[SFSubview1 alloc] initWithFrame:CGRectMake(150, 20, 200, 200)];
    view1.backgroundColor = [UIColor purpleColor];
    view1.text = @"子控件";
    [view addSubview:view1];
}

#pragma mark -- 扩大点击区域
- (void)upRespondeClickRegion {
    // 具体代码在 SFView
    SFView *view = [[SFView alloc] initWithFrame:CGRectMake(100, 20, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

#pragma mark - ---- log响应链
- (void)logResponders {
    SFView *view = [[SFView alloc] initWithFrame:CGRectMake(100, 20, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [self logRespondersWithResp:view];
}

- (void)logRespondersWithResp:(UIResponder *)resp {
    NSLog(@"%@", resp);
    if (resp) {
        [self logRespondersWithResp:resp.nextResponder];
    }
}

#pragma mark - ---- 缩小 layer 是否影响相应区域。
- (void)testLayer {
    self.clickView = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self.clickView addGestureRecognizer:tap];
    [self.view addSubview:self.clickView];
    /* 通过改变 layer 的大小，layer 的响应区域跟着变小，layer frame 变了，view 的跟着变化。无法达到响应区域小于显示区域的需求 */
    self.clickView.layer.bounds = CGRectMake(0, 0, 50, 50);
    self.clickView.backgroundColor = kRandomColor;
}

- (void)click {
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
