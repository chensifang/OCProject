//
//  SFScrollView.m
//  OCProject
//
//  Created by chen on 7/23/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SFScrollView.h"

@implementation SFScrollView
/** 方法2， 注意：转换成 convertPoint 后才能传给 superView */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL inside = [super pointInside:point withEvent:event];
    CGPoint convertPoint = [self convertPoint:point toView:self.superview];
    if (!inside) {
        if ([self.superview pointInside:convertPoint withEvent:event]) {
            return YES;
        } else {
            return NO;
        }
    }
    return inside;
}

@end
