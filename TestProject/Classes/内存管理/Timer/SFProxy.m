//
//  SFProxy.m
//  TestProject
//
//  Created by chen on 6/24/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SFProxy.h"

@implementation SFProxy

- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    return [invocation invokeWithTarget:self.target];
}

@end
