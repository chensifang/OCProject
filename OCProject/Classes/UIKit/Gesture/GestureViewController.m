//
//  RootViewCroller.m
//  OCProject
//
//  Created by chen on 6/24/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "GestureViewController.h"
#import "GrayView.h"
#import "RedView.h"
#import "GreenView.h"
#import "GestureModel.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "GrayGesture.h"
#import "MyButton.h"
#import "RedGesture.h"
#import "TapGesture.h"


@interface GestureViewController ()<UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIView *customScroll;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation GestureViewController

/*
 UIControl 继承自 UIView。
 */

- (void)reset {
    [self removeTopViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
    ADD_CELL(@"系统 scrollView" ,testScroll);
    ADD_CELL(@"自定义 scrollView" ,testCustomScroll);
    ADD_CELL(@"手势响应" ,testResponder);
    ADD_CELL(@"手势响应 Model 方法" ,objResponds);
    ADD_CELL(@"手势 touchs & view touchs" ,twoTouchs);
    ADD_CELL(@"手势冲突" ,gestureConflict);
}



- (void)clickBtn:(MyButton *)btn {
    /**
     调用堆栈：
     -[UIApplication sendAction:to:from:forEvent:] + 83,
     -[UIControl sendAction:to:forEvent:] + 67,
     -[UIControl _sendActionsForEvents:withEvent:] + 450,
     -[UIControl touchesEnded:withEvent:] + 583,
     -[Button touchesEnded:withEvent:] + 113,
     -[UIWindow _sendTouchesForEvent:] + 2729,
     -[UIWindow sendEvent:] + 4080,
     -[UIApplication sendEvent:] + 352,
     __dispatchPreprocessedEventFromEventQueue + 2580,
     __handleEventQueueInternal + 5948,
     __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17,
     __CFRunLoopDoSources0 + 243,
     __CFRunLoopRun + 1263,
     CFRunLoopRunSpecific + 625,
     GSEventRunModal + 62,
     UIApplicationMain + 140,
     main + 112,
     */
    NSLog(@"%s", __func__);
}



#pragma mark - ---- 手势冲突
- (void)gestureConflict {
    GrayView *grayView = [[GrayView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [self.view addSubview:grayView];
    GrayGesture *grayGes = [[GrayGesture alloc] initWithTarget:self action:@selector(grayViewResponds)];
    [grayView addGestureRecognizer:grayGes];
    
    /** red 能响应，gray 不能响应 */
    RedView *redView = [[RedView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    redView.center = CGPointMake(grayView.width * 0.5, grayView.height * 0.5);
    [grayView addSubview:redView];
    RedGesture *redGes = [[RedGesture alloc] initWithTarget:self action:@selector(redViewResponds)];
    [redView addGestureRecognizer:redGes];
    
    /**
     互斥，red 需要 grayGes 识别失败，这句代码让 gray 响应，red 不响应
     由于 gray 识别不失败，所以 redGes 没法响应。
     */
//    [redGes requireGestureRecognizerToFail:grayGes];
}

- (void)grayViewResponds {
    NSLog(@"gray 响应！");
}

- (void)redViewResponds {
    NSLog(@"red 响应！");
}

#pragma mark - ---- 手势 touchs 和 view touchs 关系
- (void)twoTouchs {
    /*
     调用顺序：
     -[Gesture touchesBegan:withEvent:].
     -[GrayView touchesBegan:withEvent:].
     -[Gesture touchesEnded:withEvent:].
     -[GestureViewController responds].
     -[GrayView touchesCancelled:withEvent:].
     */
    GrayView *view = [[GrayView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [self.view addSubview:view];
    TapGesture *tap1 = [[TapGesture alloc] initWithTarget:self action:@selector(responds)];
    [view addGestureRecognizer:tap1];
    
    /**
     延迟 view 的 touch 事件，结果是放弃 view 的 touch 事件，那为什么要叫延迟 ？
     这个问题在 TouchViewController 里解释了
     */
    /**
     调用：还是可以相应手势方法。
      ● -[Gesture touchesBegan:withEvent:].
      ● -[Gesture touchesEnded:withEvent:].
      ● -[GestureViewController responds].
     */
//    tap1.delaysTouchesBegan = YES;
    
    /**
     调用： 这个属性结果是 view 的 cancel 不掉了，换成调用 end。
     ● -[Gesture touchesBegan:withEvent:].
     ● -[GrayView touchesBegan:withEvent:].
     ● -[Gesture touchesEnded:withEvent:].
     ● -[GestureViewController responds].
     ● -[GrayView touchesEnded:withEvent:].
     */
//    tap1.cancelsTouchesInView = NO;
}

#pragma mark - ---- 手势响应
- (void)testResponder {
    /**
     1. 如果在父控件的 hittest 里返回 redview，green 的手势不响应。
     2. 如果在父控件的 hittest 里返回 redview，父控件的手势会响应。
     这可能就是响应链中，响应只会传到 nextResponder 里吧 ？red 的 next 是父控件，不是 green
     */
    GrayView *view = [[GrayView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    RedView *view1 = [[RedView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    GreenView *view2 = [[GreenView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
    [self.view addSubview:view];
    [view addSubview:view1];
    [view addSubview:view2];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responds)];
    [view2 addGestureRecognizer:tap1];
    
}

- (void)responds {
    NSLog(@"%s", __func__);
}

#pragma mark -- 非 UIResponer 是否响应方法
static GestureModel *_model;
- (void)objResponds {
    _model = [[GestureModel alloc] init];
    GrayView *view = [[GrayView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [self.view addSubview:view];
    // -[GestureModel responds]. 依然可以调用 NSObject 的方法，这个应该跟响应链没有什么关系。
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:_model action:@selector(responds)];
    [view addGestureRecognizer:tap1];
    
}

#pragma mark - ---- 自定义 scroll
- (void)testCustomScroll {
    self.contentSize = CGSizeMake(300, 0);
    self.customScroll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.topHeight)];
    self.customScroll.backgroundColor = kRandomColor;
    self.customScroll.text = @"自定义滚动视图";
    [self.view addSubview:self.customScroll];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 50, 100)];
    subView.text = @"自视图";
    subView.backgroundColor = kRandomColor;
    [self.customScroll addSubview:subView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRun:)];
    [self.customScroll addGestureRecognizer:pan];
}

- (void)testScroll {
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.topHeight)];
    [self.view addSubview:scroll];
    scroll.delegate = self;
    scroll.backgroundColor = kRandomColor;
    scroll.contentSize = CGSizeMake(1000, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 打印可知，系统的滚动视图就是在改变视图的 bounds。
//    NSLog(@"%@", NSStringFromCGRect(scrollView.bounds));
}

- (void)twoScroll {
    
}




- (void)panRun:(UIPanGestureRecognizer *)pan {
    CGRect temp = self.customScroll.bounds;
    if (temp.origin.x >= -self.contentSize.width) {
        temp.origin.x -= [pan translationInView:self.customScroll].x * 0.3;
    } else {
        temp.origin.x = -self.contentSize.width;
    }
    NSLog(@"%@", NSStringFromCGRect(temp));
//    NSLog(@"%f", [pan translationInView:self.customScroll].x);
    self.customScroll.bounds = temp;
    /** 手势的偏移量 可以叠加，越滑越快，所以每次都需要置为0 */ 
    [pan setTranslation:CGPointZero inView:self.customScroll];
}




//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s", __func__);
//    [super touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s", __func__);
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s", __func__);
//    [super touchesCancelled:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s", __func__);
//    [super touchesEnded:touches withEvent:event];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}


- (void)tap:(UITapGestureRecognizer *)tap {
    NSLog(@"%s", __func__);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

@end
