//
//  ArrayList.h
//  OCProject
//
//  Created by chen on 2019/8/10.
//  Copyright © 2019 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArrayList : NSObject

@property (nonatomic, assign) int size;
@property (nonatomic, assign) int *elements;

- (void)test;

- (instancetype)initWithCapaticy:(int)capaticy;

- (void)add:(int)element;

- (void)addIndex:(int)index element:(int)element;

- (int)getIndex:(int)index;

- (void)removeIndex:(int)index;

- (void)clear;

- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
