//
//  NSTimer+Extension.m
//  OCProject
//
//  Created by chensifang on 2018/6/22.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)
+ (NSTimer *)sf_timerWithTimeSecond:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(void))block {
    /* timer 会对 target 强引用, 这样封装成类方法就可以打破循环引用. */
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerRun:) userInfo:block repeats:YES];
}

+ (void)timerRun:(NSTimer *)timer {
    void(^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}
@end
