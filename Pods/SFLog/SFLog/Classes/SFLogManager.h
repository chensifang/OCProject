//
//  Log.h
//  Lation2.0
//
//  Created by chensifang on 16/1/21.
//  Copyright © 2016年 PICOOC. All rights reserved.

#import <Foundation/Foundation.h>

#define SFLog(frmt,...) [[SFLogManager shared] consoleLog:__LINE__ cmd:__func__ date:[NSDate date] file:__FILE__ format:[NSString stringWithFormat:frmt, ## __VA_ARGS__]]


@interface SFLogManager : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) BOOL fileLogOpen;

+ (instancetype)shared;

- (void)consoleLog:(NSUInteger)line cmd:(const char *)cmd date:(NSDate *)date file:(const char *)file format:(NSString *)format ;
- (void)fileLog:(NSUInteger)line cmd:(const char *)cmd date:(NSDate *)date format:(NSString *)format;
@end

@interface NSObject (NSThread)
- (void)performOnThread:(NSThread *)thr withBlock:(void(^)(void))block;
@end
@interface NSArray (Log)
@end

@interface NSDictionary (Log)
@end

