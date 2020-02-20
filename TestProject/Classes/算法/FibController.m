//
//  FibController.m
//  TestProject
//
//  Created by chen on 2019/8/10.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "FibController.h"

@implementation FibController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"斐波那契");
    ADD_CELL(@"递归斐波那契", getFibValue);
    ADD_CELL(@"for 求斐波那契", getFibForValue);
}

- (void)checkDuration:(void(^)(void))excute {
    NSTimeInterval begin = [NSDate date].timeIntervalSince1970;
    excute();
    NSTimeInterval endtime = [NSDate date].timeIntervalSince1970;
    NSLog(@"耗时: %.8f", endtime - begin);
}

#pragma mark - 斐波那契

- (void)getFibValue {
    [self selectValue:^(int first, int second) {
        [self checkDuration:^{
            NSLog(@"%d", fib(first));
        }];
    }];
}

- (void)getFibForValue {
    [self selectValue:^(int first, int second) {
        [self checkDuration:^{
            NSLog(@"%d", fibFor(first));
        }];
    }];
}

/**
 求第 n 个斐波那契数
0,1,1,2,3,5,8,13,21,34
 */
#pragma mark -- 递归
// 时间复杂度 O(n)
int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n -2);
}

// 时间复杂度 O(2^n)
int fibFor(int n) {
    if (n <= 1) {
        return n;
    }
    int first = 0;
    int second = 1;
    int target = 0;
    for (int i = 0; i < n -1; i++) {
        target = first + second;
        first = second;
        second = target;
    }
    return target;
}


@end
