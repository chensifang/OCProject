//
//  SubjectViewController.m
//  OCProject
//
//  Created by chen on 8/21/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SubjectViewController.h"
#import <UIImage+GIF.h>

@interface SubjectViewController ()

@end


@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
    ADD_CELL(@"NSLock 死锁", testNSLock);
}

- (void)reset {
    [self removeTopViews];
}



#pragma mark - ---- NSLock 死锁
static NSLock *lock;
- (void)testNSLock {
    lock = [[NSLock alloc] init];
    [lock lock];
    [lock lock];
    /**
     这里会死锁，原因是 lock 已经被锁定，如果还想调用 lock 的 lock 方法必须先解锁，导致死锁。
     所以锁不是针对线程，不是锁住线程，只是锁上以后，再想调用同一个 lock 的 lock 方法，必须先 unlock。
     */
    [lock unlock];
    [lock unlock];
    
}

@end
