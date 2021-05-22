
//
//  TouchButton.m
//  OCProject
//
//  Created by chensifang on 2018/9/5.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "TouchButton.h"
#import "TouchHeader.h"

@implementation TouchButton

TouchHitTest
TouchPointInside

- (instancetype)init {
    self = [TouchButton buttonWithType:0];
    [self setTitle:@"Button" forState:(UIControlStateNormal)];
    [self addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
    self.width = self.height = 70;
    self.backgroundColor = UIColor.purpleColor;
    return self;
}
- (void)click {
    NSLog(@"%s", __func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"%s", __func__);
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"%s", __func__);
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"%s", __func__);
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"%s", __func__);
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark - ---- UIControl 方法
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    NSLog(@"%s", __func__);
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    NSLog(@"%s", __func__);
    return [super continueTrackingWithTouch:touch withEvent:event];
}
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    NSLog(@"%s", __func__);
    return [super endTrackingWithTouch:touch withEvent:event];
}
- (void)cancelTrackingWithEvent:(nullable UIEvent *)event {
    NSLog(@"%s", __func__);
    return [super cancelTrackingWithEvent:event];
}

@end
