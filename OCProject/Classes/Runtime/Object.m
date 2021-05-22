//
//  Object.m
//  OCProject
//
//  Created by chen on 2019/11/26.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "Object.h"

@implementation Object
@synthesize intA = _intA;

- (void)start {
    self.intA = 0;
       //线程A
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        for (int i = 0; i < 10000; i ++)

        {
            @synchronized (self) {
                self.intA = self.intA + 1;
            }
            

            NSLog(@"Thread A: %d\n", self.intA);

        }
    });
    

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //线程B

        for (int i = 0; i < 10000; i ++)

        {
            @synchronized (self) {
                self.intA = self.intA + 1;
            }
            

            NSLog(@"Thread B: %d\n", self.intA);

        }
    });
}

- (void)setIntA:(int)intA {
        _intA = intA;
}

- (int)intA {
        return _intA;
}

@end
