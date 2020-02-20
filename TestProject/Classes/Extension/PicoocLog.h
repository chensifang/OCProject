//
//  Log.h
//  Lation2.0
//
//  Created by chensifang on 16/1/21.
//  Copyright © 2016年 PICOOC. All rights reserved.

#import <Foundation/Foundation.h>

#if 0
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define kLogFile 0

#if 1
#define PKLog(frmt,...)\
[PicoocLog performSelector:@selector(consoleLog:) onThread:thread withObject:[LogArg.alloc initWithLine:__LINE__ func:__func__ file:__FILE__ content:[NSString stringWithFormat:frmt, ## __VA_ARGS__]] waitUntilDone:NO];

#else
#define PKLog(frmt,...)
#endif

#define OffLog(...)
extern NSThread *thread;
@interface LogArg:NSObject
@property (nonatomic, assign) NSUInteger line;
@property (nonatomic, assign) const char *_func;
@property (nonatomic, assign) const char *file;
@property (nonatomic, copy) NSString *content;
- (instancetype)initWithLine:(NSUInteger)line func:(const char *)_func file:(const char *)file content:(NSString *)content;
@end

@interface PicoocLog : NSObject
+ (void)consoleLog:(LogArg *)model;
@end


@interface NSArray (Log)
@end

@interface NSDictionary (Log)
@end

