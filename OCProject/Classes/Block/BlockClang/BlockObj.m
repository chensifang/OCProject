//
//  BlockObj.m
//  OCProject
//
//  Created by chen on 8/11/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "BlockObj.h"

@implementation BlockObj
void startBlock () {
    NSObject *obj0 = NSObject.alloc.init;
    __weak NSObject *obj = obj0;
    
    void (^myBlock)(void) = ^ {
        obj;
    };
    myBlock();
}
@end

@implementation BlockInt
void startBlockInt () {
    int i = 2;
    
    void (^myBlock)(void) = ^ {
        NSLog(@"%d", i);
    };
    myBlock();
}
@end
