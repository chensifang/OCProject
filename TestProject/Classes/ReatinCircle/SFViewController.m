//
//  SFViewController.m
//  TestProject
//
//  Created by chensifang on 2018/6/21.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import "SFViewController.h"
#import <objc/runtime.h>

@interface SFViewController ()
@property (nonatomic, strong) void(^block)(void);
@end

@implementation SFViewController
- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
    [self retainCircle];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)retainCircle {
    void(^block)(void) = ^{
        NSLog(@"%@", self);
    };
    [self testWithBlock:block];
}

- (void)testWithBlock:(void(^)(void))block {
    block();
}
@end
