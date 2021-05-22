//
//  ListController.m
//  OCProject
//
//  Created by chen on 2019/8/10.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "LinkListController.h"
#import "LinkedList.h"
#import <ReactiveObjC.h>
#import <HealthKit/HealthKit.h>
#import <Aspects.h>

@interface LinkListController ()

@end

@implementation LinkListController

static LinkedList *list;
__unused static int Random(int from, int to) {
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reset];
    ADD_CELL(@"添加", add);
    ADD_CELL(@"添加 index", addIndex);
    ADD_CELL(@"移除 index", removeIndex);
    ADD_CELL(@"添加多个元素",  addElements);
    ADD_SECTION(@"leetcode");
    ADD_CELL(@"删除指定节点", deleteNode);
    ADD_CELL(@"翻转链表-递归", revertList);
    ADD_CELL(@"翻转链表-for", revertForList);
    ADD_CELL(@"链表是否有环", hasCircle);
}

- (void)logList {
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < list.size; i++) {
        [arr addObject:@([list getIndex:i])];
    }
    NSLog(@"list: %@", arr.description);
}

#pragma mark - progress

- (void)reset {
    list = [[LinkedList alloc] init];
    for (int i = 4; i >= 0; i--) {
        [list add:i];
    }
    [RACObserve(list, size) subscribeNext:^(id  _Nullable x) {
        [self logList];
    }];
}

- (void)add {
    [self selectValue:^(int first, int second) {
        [list add:first];
    }];
}

- (void)addIndex {
    [self selectValue:^(int first, int second) {
        [list addIndex:first element:second];
    }];
}

- (void)removeIndex {
    [self selectValue:^(int first, int second) {
        [list removeIndex:first];
    }];
}

- (void)addElements {
    [self selectValue:^(int first, int second) {
        for (int i = 0; i < first; i++) {
            [list add:Random(1, 100)];
        }
    }];
}

#pragma mark - leecode
// 删除链表中的节点
- (void)deleteNode {
    [self selectValue:^(int first, int second) {
        [list deleteNode:[list noteOfIndex:first]];
    }];
}

// 翻转链表 递归
- (void)revertList {
    list.first = [list revertList:list.first];
    [self logList];
}

- (void)revertForList {
    list.first = [list revertForList:list.first];
    [self logList];
}

- (void)hasCircle {
    [list noteOfIndex:list.size - 1].next = [list noteOfIndex:Random(1, list.size - 1)];
    NSLog(@"有环 %d", [list hasCircle:list.first]);
}



@end
