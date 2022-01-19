//
//  Person.m
//  OCProject
//
//  Created by chensifang on 2018/6/22.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import "SPerson.h"

@implementation SPerson
void pushController(UIViewController *vc, BOOL animated) {
    
}

- (instancetype)copyWithZone:(NSZone *)zone {
    SPerson *new = [self.class.alloc init];
    new.name = self.name;
    return new;
}

- (BOOL)isEqual:(id)object {
    return YES;
}

+ (instancetype)person {
    SPerson *person = [[super alloc] init];
    return person;
}
- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)test {
    NSLog(@"%s", __func__);
    NSLog(@"self.name: %@", self.name);
}
@end
