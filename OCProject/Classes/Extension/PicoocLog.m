//
//  Log.m
//  Lation2.0
//
//  Created by chensifang on 16/1/21.
//  Copyright © 2016年 PICOOC. All rights reserved.
//

#import "PicoocLog.h"


@implementation LogArg
- (instancetype)initWithLine:(NSUInteger)line func:(const char *)_func file:(const char *)file content:(NSString *)content {
    if (self = [super init]) {
        self.line = line;
        self._func = _func;
        self.file = file;
        self.content = content;
    }
    return self;
}
@end
NSThread *thread;


@implementation PicoocLog

+ (void)initialize {
    //    freopen("/dev/null","w",stdout);
    freopen("/dev/null","w",stderr);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [NSThread.alloc initWithTarget:self selector:@selector(run) object:nil];
        thread.name = @"logThread";
        [thread start];
    });
}

+ (void)run {
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}


+ (void)consoleLog:(LogArg *)model {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *string = [[NSString alloc] initWithCString:model._func encoding:NSUTF8StringEncoding];
    if ([string hasSuffix:@"_block_invoke"]) {
        string = [string substringToIndex:string.length - @"_block_invoke".length];
    }
    fprintf(stdout,"[%s] %s %tu行: ● %s.\n", [dateStr UTF8String], string.UTF8String ,model.line,[model.content UTF8String]);
    fileLog(model.line, model._func, dateStr, model.content);
}

void writeLog(NSString *content) {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"PICOOC_SPORT_LOG.text"];
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            PKLog(@"文件写入失败 errorInfo: %@", error.domain);
        }
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile];
    NSData* stringData  = [content dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:stringData]; // 追加
    [fileHandle synchronizeFile];
    [fileHandle closeFile];
    
}

void fileLog(NSUInteger line, const char *methodName, NSString *timeStr, NSString *format) {
    NSString *logStr = [NSString stringWithFormat:@"[%@] %s %tu行: ● %@.\n", timeStr, methodName,line,format];
    writeLog(logStr);
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
