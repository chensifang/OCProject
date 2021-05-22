//
//  TouchViewController.m
//  OCProject
//
//  Created by chensifang on 2018/9/5.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchBlueView.h"
#import "TouchRedView.h"
#import "TouchHeader.h"
#import "TouchButton.h"
#import "TouchGesture.h"
#import "TouchPanGesture.h"
#import "TouchTapGesture.h"

@interface TouchViewController ()

@end

@implementation TouchViewController
- (void)reset {
    [self removeTopViews];
}

TouchMethods
/*
 事件传递响应流程：
 1. 找到 hitView
 2. application 将事件给 window，再给 hitView
 3. hitView 根据 UIResponser，UIControl，手势来决定响应 & 传递还是截断
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
    ADD_SECTION(@"层级");
    ADD_CELL(@"button 上有 view", testTouch1);
    ADD_CELL(@"button 在最上面", testTouch2);
    ADD_CELL(@"button 加手势", buttonGesture);
    ADD_CELL(@"button 父类加手势", buttonSuperGesture);
    ADD_SECTION(@"手势3属性");
    ADD_CELL(@"cancelsTouchesInView", cancelsTouchesInViewTest);
    ADD_CELL(@"cancelsTouchesInView 上有 button", cancelsTouchesInViewTestWithBtn);
    ADD_CELL(@"delaysTouchesBegan", delaysTouchesBeganTest);
    ADD_CELL(@"delaysTouchesBegan，手势在父控件上", delaysTouchesBeganTestWhenInSuperview);
    ADD_SECTION(@"多手势");
    ADD_CELL(@"view 上多手势",  moreGestureInView);
    ADD_CELL(@"多 view 多手势",  moreViewMoreGesture);
    ADD_CELL(@"同级别 view 多手势",  sameLevelViewMoreGesture);
    ADD_CELL(@"self.view & view 多手势",  sameLevelViewMoreGesture1);
}

#pragma mark - ---- 多手势
#pragma mark -- 一个 view 上多手势
/*
 2个手势都会走 touch，但是之后后添加的手势能响应
 */
- (void)moreGestureInView {
    TouchRedView *red = [[TouchRedView alloc] init];
    [self.view addSubview:red];
    TouchTapGesture *blueTap = [[TouchTapGesture alloc] initWithTarget:self action:@selector(blueTap)];
    
    TouchTapGesture *redTap = [[TouchTapGesture alloc] initWithTarget:self action:@selector(redTap)];
    [red addGestureRecognizer:redTap];
    [red addGestureRecognizer:blueTap];
}

#pragma mark -- 多个 view 多个手势
/*
 子控件的手势响应，父控件不响应
 */
- (void)moreViewMoreGesture {
    TouchBlueView *blue = [[TouchBlueView alloc] init];
    TouchTapGesture *blueTap = [[TouchTapGesture alloc] initWithTarget:self action:@selector(blueTap)];
    [blue addGestureRecognizer:blueTap];
    [self.view addSubview:blue];
    TouchRedView *red = [[TouchRedView alloc] init];
    TouchTapGesture *redTap = [[TouchTapGesture alloc] initWithTarget:self action:@selector(redTap)];
    [red addGestureRecognizer:redTap];
    [blue addSubview:red];
}

#pragma mark -- 同级别 view 多手势
/*
 同级别的非 hitview 的手势不会走 touch，也就是不会进入识别，由此可知，不在 hitview 的响应链中的手势是不参与识别的
 */
- (void)sameLevelViewMoreGesture {
    TouchBlueView *blue = [[TouchBlueView alloc] init];
    TouchTapGesture *blueTap = [[TouchTapGesture alloc] initWithTarget:self action:@selector(blueTap)];
    [blue addGestureRecognizer:blueTap];
    [self.view addSubview:blue];
    TouchRedView *red = [[TouchRedView alloc] init];
    TouchTapGesture *redTap = [[TouchTapGesture alloc] initWithTarget:self action:@selector(redTap)];
    [red addGestureRecognizer:redTap];
    [self.view addSubview:red];
}

// 在响应链上的 跟 moreViewMoreGesture 一样
- (void)sameLevelViewMoreGesture1 {
    TouchRedView *red = [[TouchRedView alloc] init];
    TouchTapGesture *redTap = [[TouchTapGesture alloc] initWithTarget:self action:@selector(redTap)];
    [red addGestureRecognizer:redTap];
    [self.view addSubview:red];
    
    TouchTapGesture *viewTap = [[TouchTapGesture alloc] initWithTarget:self action:@selector(blueTap)];
    [self.view addGestureRecognizer:viewTap];
}

- (void)blueTap {
    NSLog(@"%s", __func__);
}

- (void)redTap {
    NSLog(@"%s", __func__);
}


#pragma mark - ---- 手势3属性
#pragma mark -- cancelsTouchesInView 测试
/*
 cancelsTouchesInView：
 1. 当 hitview 确定后，application 会将事件给 手势识别器 & hitview，手势识别器先走 touch，hitview 接着走 touch，
    如果 cancelsTouchesInView = YES（默认），手势识别器一旦识别出来手势，通知 application 取消响应链对时间的响应，会调用 hitview 的 CancelTouch，如果是 UIControl 也会调用 CancelTrack，
    如果 cancelsTouchesInView = NO，手势即便识别，hitview 依然可以响应, 最后不会调用 cancel 方法，只会调用 End 方法。
 2. 在手势识别失败的时候依然正常走响应链。
 */
- (void)cancelsTouchesInViewTest {
    TouchBlueView *blue = [[TouchBlueView alloc] init];
    [self.view addSubview:blue];
    TouchRedView *red = [[TouchRedView alloc] init];
    [blue addSubview:red];
    TouchPanGesture *tap = [[TouchPanGesture alloc] initWithTarget:self action:@selector(redGestureClick)];
    /*
     用拖动手势好测试，拖动过程中，如果为 YES，一旦识别到拖动，Cancel 响应链，不调用 move，反之为 NO 的时候会一遍打印拖动方法，一边调用响应链的 move
     */
//    tap.cancelsTouchesInView = NO;
    [red addGestureRecognizer:tap];
}
/*
 如果手势没有识别依然可以走 button 的方法
 */
- (void)cancelsTouchesInViewTestWithBtn {
    TouchBlueView *blue = [[TouchBlueView alloc] init];
    [self.view addSubview:blue];
    TouchButton *red = [[TouchButton alloc] init];
    [blue addSubview:red];
    TouchPanGesture *tap = [[TouchPanGesture alloc] initWithTarget:self action:@selector(pan)];
    [red addGestureRecognizer:tap];
}

- (void)pan {
    NSLog(@"%s", __func__);
}

- (void)redGestureClick {
    NSLog(@"%s", __func__);
}

#pragma mark -- delaysTouchesBegan
/*
 delaysTouchesBegan 让手势在识别过程中不走响应链的 touchBegan，连 touchBegan 都不调用。
 */
- (void)delaysTouchesBeganTest {
    TouchBlueView *blue = [[TouchBlueView alloc] init];
    [self.view addSubview:blue];
    TouchRedView *red = [[TouchRedView alloc] init];
    [blue addSubview:red];
    TouchTapGesture *tap = [[TouchTapGesture alloc] initWithTarget:self action:@selector(redGestureClick)];
    tap.delaysTouchesBegan = YES;
    [red addGestureRecognizer:tap];
}

/*
 测试得知，只要 hitview 的响应链中有手势，手势的 touch 都是第一调用
 */
- (void)delaysTouchesBeganTestWhenInSuperview {
    TouchBlueView *blue = [[TouchBlueView alloc] init];
    [self.view addSubview:blue];
    TouchRedView *red = [[TouchRedView alloc] init];
    [blue addSubview:red];
    TouchTapGesture *tap = [[TouchTapGesture alloc] initWithTarget:self action:@selector(redGestureClick)];
    // 即便手势在父控件上，也是一样，先走手势 touch，下面设置 YES 直接不走响应链的 touch。
    tap.delaysTouchesBegan = YES;
    [blue addGestureRecognizer:tap];
}


// https://mp.weixin.qq.com/s/nPGJqZTkkLdMyWjHuKRCKg
#pragma mark - ---- 事件传递 & 响应
#pragma mark -- button 上有 view
/*
 调用堆栈：
    ● -[TouchRedView touchesBegan:withEvent:].
    ● -[TouchButton touchesBegan:withEvent:].
    ● -[TouchRedView touchesEnded:withEvent:].
    ● -[TouchButton touchesEnded:withEvent:].
 1. hitView 为 red， red 的 touchBegan调用堆栈是触发 runloop 的 obsever
 2. red touchesBegan 调用顺着响应链传递给 button 的 touchesBegan（UIResponser 的方法），到此截断。不往下传，这是 UICotrol 的特性
 3. 依然不调用 button 的 track 系列方法，不响应 click 事件
 */
- (void)testTouch1 {
    [self reset];
    TouchBlueView *blue = [[TouchBlueView alloc] init];
    TouchRedView *red = [[TouchRedView alloc] init];
    TouchButton *btn = [[TouchButton alloc] init];
    [self.view addSubview:blue];
    [blue addSubview:btn];
    [btn addSubview:red];
}

#pragma mark -- button 在最上面
/*
 调用堆栈：
    ● -[TouchButton touchesBegan:withEvent:].
    ● -[TouchButton beginTrackingWithTouch:withEvent:].
    ● -[TouchButton touchesEnded:withEvent:].
    ● -[TouchButton endTrackingWithTouch:withEvent:].
    ● -[TouchButton click].
 1. hitView 为 button
 2. button click 方法会响应，响应链依然截断
 */

/*
 button target-action 方法调用的堆栈: target-action 触发的是 Runloop 的 observer 事件,其他UIResponser，UIControl，手势系列方法和响应方法都是走的 source0事件
 1   OCProject         main + 0,
 2   UIKitCore           -[UIApplication sendAction:to:from:forEvent:] + 83,
 3   UIKitCore           -[UIControl sendAction:to:forEvent:] + 67,
 4   UIKitCore           -[UIControl _sendActionsForEvents:withEvent:] + 450,
 5   UIKitCore           -[UIControl touchesEnded:withEvent:] + 583,
 6   OCProject         -[TouchButton touchesEnded:withEvent:] + 340,
 7   UIKitCore           _UIGestureEnvironmentSortAndSendDelayedTouches + 5387,
 8   UIKitCore           _UIGestureEnvironmentUpdate + 1506,
 9   CoreFoundation      __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__ + 23,
 10  CoreFoundation      __CFRunLoopDoObservers + 430,
 11  CoreFoundation      __CFRunLoopRun + 1537,
 12  CoreFoundation      CFRunLoopRunSpecific + 625,
 13  GraphicsServices    GSEventRunModal + 62,
 14  UIKitCore           UIApplicationMain + 140,
 15  OCProject         main + 112,
 16  libdyld.dylib       start + 1
 */

- (void)testTouch2 {
    [self reset];
    TouchBlueView *blue = [[TouchBlueView alloc] init];
    TouchRedView *red = [[TouchRedView alloc] init];
    TouchButton *btn = [[TouchButton alloc] init];
    [self.view addSubview:blue];
    [self.view addSubview:red];
    [red addSubview:btn];
}

#pragma mark -- button 加手势
/*
 1. 手势会响应
 2. 调用堆栈：
 ● -[TouchGesture touchesBegan:withEvent:].
 ● -[TouchButton touchesBegan:withEvent:].
 ● -[TouchButton beginTrackingWithTouch:withEvent:].
 ● -[TouchGesture touchesEnded:withEvent:].
 ● -[TouchViewController buttonGestureClick].
 ● -[TouchButton touchesCancelled:withEvent:].
 ● -[TouchButton cancelTrackingWithEvent:].
 手势的 touch 方法居然先调用，UIResponser 的 touch，UIControl 的 track，但最终后面2都被 cancel 由手势响应
 可以总结：手势的 touch 方法调用优先级最高
 */
- (void)buttonGesture {
    [self reset];
    TouchRedView *red = [[TouchRedView alloc] init];
    TouchButton *btn = [[TouchButton alloc] init];
    [self.view addSubview:red];
    [red addSubview:btn];
    TouchGesture *tap = [[TouchGesture alloc] initWithTarget:self action:@selector(buttonGestureClick)];
    // 下面这个属性设置 NO 可以同时响应
//    tap.cancelsTouchesInView = NO;
    [btn addGestureRecognizer:tap];
}

#pragma mark -- button 的 superview 有手势

/*
 
 1. 和上面一样，手势的 touch 方法居然先调用，再让作为 hitview 的走 UIResponser 的 touch，UIControl 的 track，但是最终响应的是 button
 2. 也就是 application 把事件同时先给手势，再给 hitview
 结合网上的博客得出：手势的识别是优先级最高，但是只是识别，响应的话分情况，手势在 button 上，手势的响应级别最高，但是手势在 button 的父控件上，虽然识别优先级高，但是响应优先级低于 button
 */
- (void)buttonSuperGesture {
    [self reset];
    TouchRedView *red = [[TouchRedView alloc] init];
    TouchButton *btn = [[TouchButton alloc] init];
    [self.view addSubview:red];
    [red addSubview:btn];
    TouchGesture *tap = [[TouchGesture alloc] initWithTarget:self action:@selector(buttonGestureClick)];
    [red addGestureRecognizer:tap];
}

/*
 手势的响应堆栈：
 0   ???                    0x0 + 5111611767,
 1   OCProject            main + 0,
 2   UIKitCore              -[UIGestureRecognizerTarget _sendActionWithGestureRecognizer:] + 57,
 3   UIKitCore              _UIGestureRecognizerSendTargetActions + 109,
 4   UIKitCore              _UIGestureRecognizerSendActions + 305,
 5   UIKitCore              -[UIGestureRecognizer _updateGestureWithEvent:buttonEvent:] + 858,
 6   UIKitCore              _UIGestureEnvironmentUpdate + 1329,
 7   UIKitCore              -[UIGestureEnvironment _deliverEvent:toGestureRecognizers:usingBlock:] + 478,
 8   UIKitCore              -[UIGestureEnvironment _updateForEvent:window:] + 200,
 9   UIKitCore              -[UIWindow sendEvent:] + 4058,
 10  UIKitCore              -[UIApplication sendEvent:] + 352,
 11  UIKitCore              __dispatchPreprocessedEventFromEventQueue + 3024,
 12  UIKitCore              __handleEventQueueInternal + 5948,
 13  CoreFoundation         __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17,
 14  CoreFoundation         __CFRunLoopDoSources0 + 243,
 15  CoreFoundation         __CFRunLoopRun + 1263,
 16  CoreFoundation         CFRunLoopRunSpecific + 625,
 17  GraphicsServices       GSEventRunModal + 62,
 18  UIKitCore              UIApplicationMain + 140,
 19  OCProject            main + 112,
 20  libdyld.dylib          start + 1
 */
- (void)buttonGestureClick {
    NSLog(@"%s", __func__);
}

@end
