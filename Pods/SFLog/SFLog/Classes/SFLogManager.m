//
//  Log.m
//  Lation2.0
//
//  Created by chensifang on 16/1/21.
//  Copyright © 2016年 PICOOC. All rights reserved.
//

#import "SFLogManager.h"

#define defaultPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"__log__.text"]

@interface SFLogManager()
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, assign) const char *time;
@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, assign) NSUInteger line;
@property (nonatomic, assign) const char* cmd;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, copy) NSString *filePath;


@end

@implementation SFLogManager
+ (void)load {
    [self shared];
    
}

static SFLogManager *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        
    });
    return _instance;
}

+ (BOOL)isJailBreak {
    NSArray *jailbreak_tool_paths = @[
                                      @"/Applications/Cydia.app",
                                      @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                      ];
    for (int i = 0; i<jailbreak_tool_paths.count; i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreak_tool_paths[i]]) {
//            NSLog(@"越狱手机");
            return YES;
        }
    }
    return NO;
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        _instance.formatter = formatter;
        formatter.dateFormat= @"YYYY-MM-dd HH:mm:ss.SSS";
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        _instance.thread = [[NSThread alloc] initWithTarget:_instance selector:@selector(runloopRun) object:nil];
        [_instance.thread start];
        NSError *error;
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *bundleId = info[@"CFBundleIdentifier"];
        BOOL isJailBreak= [self isJailBreak];
        NSString *shortVersion = info[@"CFBundleShortVersionString"];
        NSString *bundleVersion = info[@"CFBundleVersion"];
        NSString *header = [NSString stringWithFormat:@"bundleId：%@\nshortVersion：%@\nbundleVersion：%@\n是否越狱：%d\n", bundleId, shortVersion, bundleVersion, isJailBreak];
        NSMutableString *str = @"".mutableCopy;
        for (int i = 0; i < 60; i ++) {
            if (i == 30) {
                [str appendString:@" 日志 "];
            }
            [str appendString:@"=="];
        }
        [str appendString:[NSString stringWithFormat:@"\n%@", header]];
        [str writeToFile:defaultPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
//            NSLog(@"临时文件创建失败！");
        } else {
//            NSLog(@"临时文件创建成功！");
        }
    });
    return _instance;
}

- (void)runloopRun {
    NSRunLoop *rp = [NSRunLoop currentRunLoop];
    [rp addPort:NSPort.port forMode:NSDefaultRunLoopMode];
    [rp run];
}

- (void)consoleLog:(NSUInteger)line cmd:(const char *)cmd date:(NSDate *)date file:(const char *)file format:(NSString *)format {
    [self performOnThread:self.thread withBlock:^{
        self.line = line;
        self.cmd = cmd;
        self.date = date;
        self.format = format;
        self.time = [self.formatter stringFromDate:date].UTF8String;
        __CONSOLE_LOG__(self);
        if (self.fileLogOpen) {
            __FILE_LOG__(self);
        }
    }];
    
}

- (void)fileLog:(NSUInteger)line cmd:(const char *)cmd date:(NSDate *)date format:(NSString *)format {
    [self performOnThread:self.thread withBlock:^{
        self.line = line;
        self.cmd = cmd;
        self.date = date;
        self.format = format;
        self.time = [self.formatter stringFromDate:date].UTF8String;
        __FILE_LOG__(self);
    }];
}

static void __CONSOLE_LOG__(SFLogManager *self) {
    fprintf(stderr,"[%s] %s[%tu行] ● %s.\n", self.time, self.cmd , self.line,[self.format UTF8String]);
}


static void __FILE_LOG__(SFLogManager *self) {
    NSString *content = [NSString stringWithFormat:@"[%s] %s[%tu行] ● %@.\n", self.time, self.cmd,self.line,self.format];
    NSError *error = nil;
    NSString *filePath = self.path ?: defaultPath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]) {
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"写入失败");
        }
    } else {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [fileHandle seekToEndOfFile];
        NSData* stringData  = [content dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:stringData];
        [fileHandle synchronizeFile];
    }
}

- (void)setPath:(NSString *)path {
    if (!_path) {
        _path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:path];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL suc = [fileManager createFileAtPath:_path contents:nil attributes:nil];
        if (!suc) {return;}
        if ([fileManager fileExistsAtPath:defaultPath]) {
            NSData *data = [fileManager contentsAtPath:defaultPath];
            NSString *string = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
            NSError *error;
            [string writeToFile:_path atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"迁移失败!");
            } else {
                NSLog(@"迁移成功！");
            }
        }
    }
}

- (NSFileHandle *)fileHandle {
    if (!self.path) {
        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:defaultPath];
    } else {
        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.path];
    }
    return _fileHandle;
}

@end

@implementation NSObject (NSThread)

- (void)performOnThread:(NSThread *)thr withBlock:(void(^)(void))block {
    [self performSelector:@selector(execute:) onThread:thr withObject:block waitUntilDone:NO];
}

- (void)execute:(void(^)(void))block {
    if (block) {
        block();
    }
}

@end

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}

@end
