//
//  RunloopViewController.m
//  TestProject
//
//  Created by chen on 7/11/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "RunloopViewController.h"
#import "RunloopOb.h"
#import "NSTimer+extension.h"
@interface RunloopViewController ()
@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation RunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"Runloop 测试", runloopTest);
    ADD_CELL(@"监听主线程 Runloop", observerRunloop);
    ADD_CELL(@"layout 和 Runloop", layoutAndRunloop);
    ADD_CELL(@"performSelecter", performSelecterTest);
}

#pragma mark - ---- PerformSelecter
- (void)performSelecterTest {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 没有 after 会调用,after 不会，为0也不会
        [self performSelector:@selector(log) withObject:nil afterDelay:0];
    });
}

- (void)log {
    NSLog(@"%s", __func__);
}


#pragma mark - ---- layout 和 runloop
- (void)layoutAndRunloop {
    [NSTimer sf_timerWithTimeSecond:2 repeats:YES block:^{
        [self.view setNeedsLayout];
    }];
}


#pragma mark -- 监听
- (void)observerRunloop {
    [NSTimer sf_timerWithTimeSecond:1 repeats:YES block:^{
        NSLog(@"执行 timer");
        for (int i = 0; i < 100000; i++) {
            UIView *view = [[UIView alloc] init];
            [self.view addSubview:view];
        }
    }];
    [RunloopOb observerRunloop:CFRunLoopGetCurrent()];
}
- (void)runloopTest {
    self.thread = [[NSThread alloc] initWithBlock:^{
        self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"run");
        }];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [RunloopOb observerRunloop:CFRunLoopGetCurrent()];
        [runloop addTimer:self.timer forMode:NSDefaultRunLoopMode];
        //        [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        /* 在 timer 开始的线程停止 timer 才会走 runloop exit. 因为 runloop 里已经没有资源了. 可以走到 end____. */
//        [self performSelector:@selector(invalidateTimer) withObject:nil afterDelay:2];
        /* 可以不要 fire,fire 只是让 timer 立即执行.不加也会在合适的时候自动执行. */
        [self.timer fire];
        [runloop run];
        NSLog(@"end_____");
    }];
        [self.thread start];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /* 子线程开启的 timer 在主线程停止也可以停止,但是runloop 不会 exit 只会休眠,导致 runloop 资源浪费. timer 在 runloop 里不出来 */
        [self invalidateTimer];
    });
}

- (void)invalidateTimer {
    NSLog(@"%s", __func__);
    [self.timer invalidate];
}

- (void)threadRun {
    NSLog(@"%s", __func__);
}



@end
