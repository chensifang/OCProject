//
//  NSTimer+Extension.h
//  OCProject
//
//  Created by chensifang on 2018/6/22.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)
+ (NSTimer *)sf_timerWithTimeSecond:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(void))block;
@end
