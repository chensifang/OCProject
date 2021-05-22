//
//  AnimationTableViewController.m
//  OCProject
//
//  Created by chensifang on 2018/7/11.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "AnimationViewController.h"
#import "NSObject+Extension.h"
#import "MyView.h"
#import "MyLayer.h"
#import "AnimationView.h"

@interface AnimationViewController ()
@property (nonatomic, strong) UIView *animatView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MyLayer *layer;
@property (nonatomic, strong) AnimationView *aView;
@end

@implementation AnimationViewController
- (void)reset {
    [self removeTopViews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
    ADD_CELL(@"开始/暂停动画" , startAnimation);
    ADD_CELL(@"圆圈 loading 动画" , startAnimationLoadingCircle);
    ADD_CELL(@"layer 属性" , logLayerProperty);
    
    ADD_SECTION(@"layer 动画");
    ADD_CELL(@"layer 隐式动画" , implicitAnimation);
    ADD_CELL(@"UIView block 动画" , viewAnimation);
    ADD_CELL(@"CAAnimtaion动画", caAnimation);
    ADD_CELL(@"动画时间测试", animatTime);
}

#pragma mark - ---- layer 动画相关
- (void)viewAnimation {
    // 打印可以看到遵守 CALayerDelegate 协议。
    [MyView logProtocalRecursion:YES];
    AnimationView *view = [[AnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = kRandomColor;
    [self.view addSubview:view];
    [UIView animateWithDuration:2 animations:^{
        view.left = 200;
    }];
    
}

#pragma mark -- 隐式动画
- (void)implicitAnimation {
    MyLayer *layer = MyLayer.layer;
    layer.frame = CGRectMake(200, 100, 100, 100);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    /**
     1、必须延迟一下才能出隐式动画
     2、猜测：同一次 runloop 中设置多次 postion 只取最后的，不会出动画，第二次 runloop 再设置，发现和上一次不一样才动画。
     3、再猜：其实应该是跟屏幕刷新频率有关，如果刷新3次 t0、t1、t2，在 t0&t1直接设置多次没有动画，在t0&t1 和 t1&t2之间分别设置才有动画,推翻上面的猜测。延迟时间就是保证2个刷新间隔里。
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.position = CGPointMake(200, 200);
        NSLog(@"%@",[layer.delegate actionForLayer:layer forKey:@"position"]);
    });
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkRun)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
static int i = 0;
- (void)linkRun {
    if (i++ == 1) {
        return;
    }
    self.layer.position = CGPointMake(0, 200);
}

#pragma mark - ---- CAAnimation
/**
 1. layer 有 presentationLayer 负责显示，modelLayer 负责数据。
 2. p 的显示过程是：每当一帧到来就去询问 m 的数据，根据 m 的数据调整自己的位置。
 3. 如果给 layer 加上 CAAnimation（简称 c），则 p 不问 m 了，直接问 c，动画结束后 c 被移除，p 又去问 m，p 恢复原始位置，这也就是为什么动画完毕后会回到原始位置。
 */
- (void)caAnimation {
    AnimationView *view = [[AnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = kRandomColor;
    [self.view addSubview:view];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(80, 80)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
    anim.duration = 2;
    /** 下面2句代码控制动画结束后不会到原始位置 */
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:anim forKey:@"position"];
}

#pragma mark - ---- layer 属性
- (void)logLayerProperty {
    // 只有一个 ivar
    [CALayer logIvarsRecursion:YES];
    // 有很多 property
    [CALayer logPropertyRecursion:YES];
}

#pragma mark - ---- 圆圈 loading 动画
- (void)startAnimationLoadingCircle {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ICON"]];
    self.imageView.frame = CGRectMake(100, 50, 200, 200);
    [self.view addSubview:self.imageView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.imageView.width * 0.5, self.imageView.width * 0.5) radius:self.imageView.width * sin(0.25 * M_PI) startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
    layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    layer.lineWidth = self.imageView.width * sin(0.25 * M_PI) * 2;
    [self.imageView.layer addSublayer:layer];
    /* 下面2句等价，一个针对 layer 一个针对 view 而已。？ */
    self.imageView.layer.masksToBounds = YES;
//    [self.imageView setClipsToBounds:YES];
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    anima.duration = 2;
    anima.toValue = @1;
    [layer addAnimation:anima forKey:nil];
}

#pragma mark - ---- 动画时间概念
static int _number = 0;
- (void)startAnimation {
    if (!self.animatView) {
        self.animatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.animatView.backgroundColor = kRandomColor;
        [self.view addSubview:self.animatView];
        [UIView animateWithDuration:10 animations:^{
            self.animatView.left = self.view.width;
        }];
        
    } else {
        _number++;
        if (_number % 2 == 1) {
            [self pauseLayer:self.animatView.layer];
        }
        if (_number % 2 == 0) {
            [self resumeLayer:self.animatView.layer];
        }
    }
}

- (void)linkRun1 {
    CFTimeInterval pausedTime = [self.aView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    NSLog(@"time : %f", pausedTime);
}


//暂停动画
- (void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
-(void)resumeLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark -- 动画时间测试
- (void)animatTime {
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkRun1)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    AnimationView *view = [[AnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.aView = view;
    view.backgroundColor = kRandomColor;
    [self.view addSubview:view];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(80, 80)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
    anim.duration = 7;
    [view.layer addAnimation:anim forKey:nil];
}

@end
