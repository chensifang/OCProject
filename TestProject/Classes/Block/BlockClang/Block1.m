//
//  Block1.m
//  TestProject
//
//  Created by chen on 2019/6/18.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "Block1.h"

@implementation Block1

- (void)start {
    __block int i = 2;
    void (^myBlock)(void) = ^ {
        i = 5;
    };
    i = 6;
    myBlock();
}

@end
