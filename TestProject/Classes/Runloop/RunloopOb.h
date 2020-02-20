//
//  RunloopObserver.h
//  TestProject
//
//  Created by chensifang on 2018/6/22.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunloopOb : NSObject
+ (void)observerRunloop:(CFRunLoopRef)runloop;
@end
