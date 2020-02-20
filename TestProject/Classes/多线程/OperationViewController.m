//
//  OperationViewController.m
//  TestProject
//
//  Created by chensifang on 2018/8/21.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "OperationViewController.h"
#import <ReactiveObjC.h>
#import "SFOperation.h"

@interface OperationViewController ()
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"添加任务", setOperations);
    ADD_CELL(@"暂停", suspended);
    ADD_CELL(@"继续", _continue);
    ADD_CELL(@"测试取消", testCancel);
    ADD_CELL(@"测试最大并发", testMaxOp);
}

#pragma mark - ---- NSOperation
- (void)observeQueueStatus {
    [RACObserve(self.queue, isSuspended) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)testMaxOp {
    self.queue = [[NSOperationQueue alloc] init];
    //        [self observeQueueStatus];
    self.queue.maxConcurrentOperationCount = 2;
    NSLog(@"%@", self.queue);
    for (int i = 0; i < 100; i++) {
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"任务%@执行中... ：%@ %@", @(i),@(self.queue.operationCount), [NSThread currentThread]);
            sleep(3);
            NSLog(@"任务%@即将完成... ：%@ %@", @(i),@(self.queue.operationCount), [NSThread currentThread]);
        }];
        [self.queue addOperation:op];
    }
}

- (void)testCancel {
    SFOperation *op = [SFOperation blockOperationWithBlock:^{
        NSLog(@"2. %@", @(self.queue.operationCount));
        [self.queue setSuspended:YES];
        sleep(3);
        NSLog(@"2. %@", @(self.queue.operationCount));
    }];
//    [op start];
//    [op start];
    self.queue = [NSOperationQueue new];
    [self.queue addOperation:op];
}

- (void)setOperations {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.queue = [[NSOperationQueue alloc] init];
//        [self observeQueueStatus];
        self.queue.maxConcurrentOperationCount = 2;
        NSLog(@"%@", self.queue);
        for (int i = 0; i < 1000000; i++) {
            NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
                NSLog(@"1. 执行 ：%@， %@", @(i),@(self.queue.operationCount));
//                sleep(3);
                NSLog(@"2. %@", @(self.queue.operationCount));
            }];
            
//            [RACObserve(op, isExecuting) subscribeNext:^(id  _Nullable x) {
//                NSLog(@"isExecuting %@. %s", x,__func__);
//            }];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [op cancel];
//            });
//            [RACObserve(op, isFinished) subscribeNext:^(id  _Nullable x) {
//                NSLog(@"isFinished %@. %s", x,__func__);
//            }];
//
//            [RACObserve(op, isCancelled) subscribeNext:^(id  _Nullable x) {
//                NSLog(@"isCancelled %@. %s", x,__func__);
//            }];
            
            [self.queue addOperation:op];
        }
        NSLog(@"self.queue 添加完成");
//        dispatch_apply(2000000000, dispatch_get_global_queue(0, 0), ^(size_t idx) {
//            if (self.queue.operationCount == 0) {
//                NSLog(@"%@", @(self.queue.operationCount));
//            }
//        });
    });
    
}

- (void)suspended {
    self.queue.suspended = YES;
}

- (void)_continue {
    self.queue.suspended = NO;
}




@end
