//
//  LinearListController.m
//  TestProject
//
//  Created by chen on 2019/8/10.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "LinearListController.h"
#import "ArrayList.h"
#import <ReactiveObjC.h>
#import "NSArray+log.h"

@interface LinearListController ()

@end

@implementation LinearListController
static ArrayList *list;
int Random(int from, int to);

- (void)viewDidLoad {
    [super viewDidLoad];
    list = [[ArrayList alloc] initWithCapaticy:10000];
    for (int i = 0; i <= 5; i++) {
        [list add:Random(2, 2)];
    }
    
//    [RACObserve(list, size) subscribeNext:^(id  _Nullable x) {
//        [self logList];
//    }];
    
    ADD_CELL(@"添加", add);
    ADD_CELL(@"添加 index 3 8", addIndex);
    ADD_CELL(@"移除 index 1", removeIndex);
    ADD_CELL(@"添加无数个",  addElements);
    ADD_CELL(@"test", test);
    
}

- (void)logList {
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < list.size; i++) {
        [arr addObject:@([list getIndex:i])];
    }
    NSLog(@"list: %@", arr.description);
}

int Random(int from, int to) {
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (void)test {
    [list test];
    [self logList];
}

/**
 线性表:
 数组:
    - 数组是一种顺序存储的线性表, 所有元素的内存地址是连续的
    - 无法动态修改容量
 */
- (void)add {
    [self selectValue:^(int first, int second) {
        [list add:first];
    }];
}

- (void)addIndex {
    [list addIndex:2 element:8];
}

- (void)removeIndex {
    [list removeIndex:1];
}

- (void)addElements {
    for (int i = 1; i < 1000000; i++) {
        [list add:1];
    }
}


@end
