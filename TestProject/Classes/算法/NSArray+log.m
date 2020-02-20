//
//  NSArray+log.m
//  TestProject
//
//  Created by chen on 2019/8/10.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "NSArray+log.h"

@implementation NSArray (log)

- (NSString *)description {
    NSMutableString *log = @"".mutableCopy;
    [self enumerateObjectsUsingBlock:^(NSObject *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [log appendString:@"["];
        }
        
        if (idx == self.count - 1) {
            [log appendFormat:@"%@]", obj.description];
        } else {
            [log appendFormat:@"%@, ", obj.description];
        }
    }];
    return log;
}

- (NSString *)debugDescription {
    return self.description;
}

@end
