//
//  NSObject+AOP.h
//  TestProject
//
//  Created by chen on 7/30/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tuple.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, AOPHookOptions) {
    AOPHookOptionBefore,
    AOPHookOptionAfter,
};


@interface NSObject (AOP)
- (void)hookSelector:(SEL)selector option:(AOPHookOptions)option block:(void(^)(id _Nullable arg))block;
+ (void)hookSelector:(SEL)selector option:(AOPHookOptions)option block:(void(^)(id _Nullable arg))block;
void hookAllMethods(Class class);
@end

NS_ASSUME_NONNULL_END
