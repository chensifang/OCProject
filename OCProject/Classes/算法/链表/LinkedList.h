//
//  LinkedList.h
//  OCProject
//
//  Created by chen on 2019/8/10.
//  Copyright © 2019 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Node : NSObject
@property (nonatomic, strong) Node *next;
@end

@interface LinkedList : NSObject

@property (nonatomic, assign) int size;
@property (nonatomic, strong) Node *first;

- (void)add:(int)element;

- (void)addIndex:(int)index element:(int)element;

- (int)getIndex:(int)index;

- (void)removeIndex:(int)index;

- (void)clear;

- (BOOL)isEmpty;

- (void)deleteNode:(Node *)mode;
- (Node *)revertList:(Node *)head;
- (Node *)revertForList:(Node *)head;
- (Node *)noteOfIndex:(int)index;
- (BOOL)hasCircle:(Node *)head;

@end

NS_ASSUME_NONNULL_END
