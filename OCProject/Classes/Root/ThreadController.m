//
//  ThreadController.m
//  OCProject
//
//  Created by chensifang on 2018/9/17.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "ThreadController.h"

@interface ThreadController ()

@end

@implementation ThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ADD_SECTION(@"网络");
    [self addCellWithTitle:@"Socket" nextVC:@"SocketViewController"];
    [self addCellWithTitle:@"Session" nextVC:@"SessionViewController"];
    
    ADD_SECTION(@"多线程");
    [self addCellWithTitle:@"GCD" nextVC:@"GCDViewController"];
    [self addCellWithTitle:@"NSOperation" nextVC:@"OperationViewController"];
    [self addCellWithTitle:@"NSThread" nextVC:@"ThreadViewController"];
}

@end
