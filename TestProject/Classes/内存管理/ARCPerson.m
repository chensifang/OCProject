//
//  ARCPerson.m
//  TestProject
//
//  Created by chensifang on 2018/7/10.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "ARCPerson.h"

@implementation ARCPerson
- (void)dealloc {
    NSLog(@"%s", __func__);
}

+ (instancetype)person {
    return [self new];
}

+ (instancetype)newPerson {
    return [self new];
}

+ (instancetype)allocPerson {
    return [self new];
}
@end
