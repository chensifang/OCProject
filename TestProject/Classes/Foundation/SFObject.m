//
//  SFObject.m
//  TestProject
//
//  Created by chen on 9/9/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SFObject.h"

@implementation SFObject
- (id)copyWithZone:(NSZone *)zone {
    return [super copy];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return nil;
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    
}


@end
