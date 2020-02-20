//
//  RunloopObserver.m
//  TestProject
//
//  Created by chensifang on 2018/6/22.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import "RunloopOb.h"

@implementation RunloopOb
+ (void)observerRunloop:(CFRunLoopRef)cfRunloop {
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"即将进入runloop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理timer");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理source");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入睡眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"刚从睡眠中唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"即将exit");
                break;
            default:
                break;
        }
    });
    CFRunLoopAddObserver(cfRunloop, observer, kCFRunLoopDefaultMode);
}
@end
