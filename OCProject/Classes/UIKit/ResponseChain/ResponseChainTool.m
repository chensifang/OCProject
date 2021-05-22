//
//  ResponseChainTool.m
//  OCProject
//
//  Created by chen on 6/24/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "ResponseChainTool.h"

@implementation ResponseChainTool
+ (void)logResponser:(UIResponder *)responser {
    NSLog(@"responser: %@", responser.class);
    if (responser.nextResponder) {
        [self logResponser:responser.nextResponder];
    }
}

@end
