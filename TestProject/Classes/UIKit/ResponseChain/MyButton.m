//
//  Button.m
//  TestProject
//
//  Created by chen on 7/22/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton
- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - ---- UIResponser 方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s", __func__);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    NSLog(@"%s", __func__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%s", __func__);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"%s", __func__);
}

#pragma mark - ---- UIControl 方法
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    return [super continueTrackingWithTouch:touch withEvent:event];
}
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    return [super endTrackingWithTouch:touch withEvent:event];
}
- (void)cancelTrackingWithEvent:(nullable UIEvent *)event {
    return [super cancelTrackingWithEvent:event];
}


- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [super sendAction:action to:target forEvent:event];
}


@end
