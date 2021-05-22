//
//  ArrayList.m
//  OCProject
//
//  Created by chen on 2019/8/10.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "ArrayList.h"
/** 动态数组 */

@interface ArrayList()

@property (nonatomic, assign) NSInteger capaticy;

@end

@implementation ArrayList

- (void)test {
    static ArrayList *list;
    list = [[ArrayList alloc] initWithCapaticy:10];
    for (int i = 1; i < 10; i++) {
        [list add:1];
    }
}

- (instancetype)initWithCapaticy:(int)capaticy {
    if (self = [super init]) {
        if (capaticy <= 0) {
            return nil;
        }
        self.elements = malloc(capaticy * sizeof(int));
        self.capaticy = capaticy;
        NSLog(@"%lu", sizeof(self.elements));
    }
    return self;
}

- (void)add:(int)element {
    self.elements[self.size] = element;
    self.size++;
}

- (void)ensureCapaticy:(int)capaticy {
    if (self.capaticy < capaticy) {
        // >> 1 等于除以 2, 扩容到原来的 1.5 倍, Java 是 1.5, OC 是 1.6 左右
        int newCapaticy = self.capaticy + (self.capaticy * 0.5);
        int *elements = malloc(newCapaticy * sizeof(int));
        for (int i = 0; i < self.size; i++) {
            elements[i] = self.elements[i];
        }
        self.elements = elements;
    }
}

// 时间复杂度 O(n), n 都表示数据规模，此处 n = size
- (void)addIndex:(int)index element:(int)element {
    if (index > self.size || index < 0) {
        NSLog(@"越界");
    } else {
        [self ensureCapaticy:self.size + 1];
        for (int i = self.size - 1; i >= index; i--) {
            self.elements[i+1] = self.elements[i];
            if (i == index) {
                self.elements[i] = element;
                self.size++;
            }
        }
    }
}

// 时间复杂度 O(1)，直接根据下标算出内存地址
- (int)getIndex:(int)index {
    if (self.size - 1 < index) {
        NSLog(@"越界"); return -1;
    }
    return self.elements[index];
}

// 时间复杂度 O(1)
- (void)removeIndex:(int)index {
    if (index > self.size - 1) {
        NSLog(@"越界");
    } else {
        if (index == self.size - 1) {
            self.size--;
        } else {
            for (int i = index; i < self.size -1; i++) {
                self.elements[i] = self.elements[i + 1];
            }
            self.size--;
        }
    }
}

- (void)clear {
    self.size = 0;
}

- (BOOL)isEmpty {
    return self.size == 0;
}

@end
