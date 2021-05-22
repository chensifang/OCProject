//
//  LinkedList.m
//  OCProject
//
//  Created by chen on 2019/8/10.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "LinkedList.h"

@interface Node()

@property (nonatomic, assign) int value;

@end

@implementation Node

@end

@interface LinkedList()

@end

@implementation LinkedList

/**
 链表也是一种线性表, 只不过不是连续分配存储空间
 */

- (void)add:(int)element {
    [self addIndex:self.size element:element];
}

- (void)addIndex:(int)index element:(int)element {
    if (index > self.size) {
        NSLog(@"越界");
        return;
    }
    Node *node = [[Node alloc] init];
    node.value = element;
    
    if (index == 0) {
        node.next = self.first;
        self.first = node;
    } else {
        // index 上一个
        Node *lastNode = [self noteOfIndex:index - 1];
        node.next = lastNode.next;
        lastNode.next = node;
    }
    
    self.size++;
}

- (int)getIndex:(int)index {
    return [self noteOfIndex:index].value;
}

- (void)removeIndex:(int)index {
    if (![self checkRange:index]) {
        return;
    }
    if (index == 0) {
        self.first = self.first.next;
    } else {
        Node *lastNode = [self noteOfIndex:index - 1];
        lastNode.next = lastNode.next.next;
    }
    self.size--;
}

- (void)clear {
    self.first = NULL;
    self.size = 0;
}

- (BOOL)isEmpty {
    return self.size == 0;
}

- (Node *)noteOfIndex:(int)index {
    if (![self checkRange:index]) {
        NSLog(@"越界");
        return nil;
    }
    Node *note = self.first;
    for (int i = 1; i <= index; i++) {
        note = note.next;
    }
    return note;
}

- (BOOL)checkRange:(int)index {
    if (index >= self.size || index < 0) {
        NSLog(@"越界");
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - leetcode

#pragma mark -- 删除指定的节点
- (void)deleteNode:(Node *)node {
    /**
     把要删除的节点的 value 赋值为 next 的 value，然后本身指向 next.next。
     为什么这样做，因为删除是要拿到 上一个 note，这里不好拿，拿到了时间复杂度也很高。
     */
    node.value = node.next.value;
    node.next = node.next.next;
    self.size --;
}

#pragma mark -- 翻转链表 递归
- (Node *)revertList:(Node *)head {
    if (!head) {
        return nil;
    }
    // 边界条件
    if (head.next == nil) {
        return head;
    }
    /**
     newHead 表明已经翻转好的前面的 list
     */
    Node *newHead = [self revertList:head.next];
    head.next.next = head;
    head.next = nil;
    /**
     假设 [5 4 3 2 1 0]
     递归是反着返回的此时调用顺序：
     head = 0 return 0
     head = 1 newHead = 0, head.next.next = head => 0.next = 1, head.next = nil => 1.next = nil
     head = 2 newHead = 0, head.next.next = head => 1.next = 2, head.next = nil => 2.next = nil
     ....
     head = 5 newHead = 0, head.next.next = head => 4.next = 5, head.next = nil => 5.next = nil
     翻转成功！
     */
    return newHead;
}

#pragma mark -- 翻转链表 循环

- (Node *)revertForList:(Node *)head {
    
    /**
     假设 [5 4 3 2 1 0]
     */
    // 由于拿到的 head 是 5， 所以流程只能从 5 -> 0
    Node *newHead;
    while (head != nil) {
        Node *temp = head.next;
        head.next = newHead;
        newHead = head;
        head = temp;
    }
    /**
     newHead = nil, temp = 4, 5->nil, newHead = 5, head = 4
     head = 4, temp = 3, 4->5, newHead = 4, head = 3
     head = 3, temp = 2, 3->4, newHead = 3, head = 2
     head = 2, temp = 1, 2->3, newHead = 2, head = 1
     head = 1, temp = 0, 1->2, newHead = 1, head = 0
     head = 0, temp = nil, 0->1, newHead = 0, head = nil
     翻转成功！
     */
    
    return newHead;
}

#pragma mark -- 链表是否有环
- (BOOL)hasCircle:(Node *)head {
    if (head.next == nil || head == nil) {
        return NO;
    }
    Node *fast = head;
    Node *slow = head.next;
    // 条件不能少，OC 可以省事因为 nil 调方法没问题，其他语言会空指针异常
    while (fast != nil && fast.next != nil) {
        slow = slow.next.next;
        fast = fast.next;
        if (fast == slow) {
            return YES;
        }
    }
    return NO;
}

@end
