//
//  StackViewController.m
//  OCProject
//
//  Created by chensifang on 2018/9/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "StackViewController.h"
static const uint length = 999;

struct Stack {
    int top;
    int arr[length];
};

struct Stack stack;

@implementation StackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
}

- (void)setup {
    for (int i = 0; i < length; i++) {
        stack.arr[i] = arc4random()%(length*10);
    }
    stack.top = stack.arr[length - 1];
}


void push(int a) {
    
}

void pop() {
    
}



/* 拟物的想象2个乒乓球筒来回倒,很清晰 */
#pragma mark - ---- 2栈实现队列

#pragma mark - ---- 2队列实现栈
@end
