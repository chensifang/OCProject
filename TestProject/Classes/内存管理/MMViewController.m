//
//  TimerViewController.m
//  TestProject
//
//  Created by chensifang on 2018/6/22.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import "MMViewController.h"
#import "NSTimer+Extension.h"
#import "SFProxy.h"
#import "SFPort.h"
#import "ARCPerson.h"



@interface MMViewController ()
@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, weak) NSTimer *timer;
@end
extern void _objc_autoreleasePoolPrint(void);
@implementation MMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"NSTimer 内存");
    ADD_CELL(@"NSTimer 类方法" , testTimer);
    ADD_CELL(@"定时器 NSProxy" , proxyTimer);
    ADD_SECTION(@"释放池");
    ADD_CELL(@"大循环释放", autoreleaseFor);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    /* 解除 runloop 对 timer 的强引用 */
    [self.timer invalidate];
}

- (void)testReturn {
    ARCPerson *person = [ARCPerson person];
}


#pragma mark - ---- autoreleasePool
- (void)autoreleaseFor {
    NSObject *obj = NSObject.alloc.init;
    NSMutableArray *arr = @[].mutableCopy;
    /*
     1. 用 button 加 autorelease 和不加分别内存峰值为 400，600，为什么差距不大，因为 uiview 类型即便进了释放池，在释放池释放的同时好像内存也降不下来
     2. 普通的创建对象不加入到 autorelease 的不需要加 @autorelease，因为会直接 release，没有内存峰值
     3. NSPort 出了作用域根本不释放
     4.
     */
    for (int i = 0; i < 100000; i++) {
        /**
         很多对象创建不会自动加入到自动释放池，即便用了类方法创建
         */
//        @autoreleasepool {
            __unused id obj = [NSMutableArray array];
//        }
//        NSObject *obj = NSObject.alloc.init;
    }
    NSLog(@"添加完成");
//    _objc_autoreleasePoolPrint();
}

#pragma mark - ---- timer
- (void)testTimer {
    /* timer 不会强引用 self, 内部是类方法 */
    self.timer = [NSTimer sf_timerWithTimeSecond:1 repeats:YES block:^{
        NSLog(@"timer run");
    }];
    /* runloop 强引用 timer */
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
/*
 虚基类做中间对象消息转发也是个思路，项目设计用得上。
 属性用弱引用，定时器用下面这个方法也能解决问题。不能用 timerWithTimeInterval ，self.timer 会创建即释放。
 self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self , timerRun) userInfo:nil repeats:YES];
 */
- (void)proxyTimer {
    /* 没有 init 方法 */
    SFProxy *proxy = [SFProxy alloc];
    proxy.target = self;
    self.timer = [NSTimer timerWithTimeInterval:2 target:proxy selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerRun {
    NSLog(@"timer run");
}



@end
