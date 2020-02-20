//
//  ThreadViewController.m
//  TestProject
//
//  Created by chensifang on 2018/8/14.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()
@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"执行线程", executeThread);
}

- (void)test {
    NSLog(@"2");
}

// 只会执行 1
- (void)executeThread {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
    }];
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:NO];
    [thread start];
}

@end
