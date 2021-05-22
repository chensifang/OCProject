//
//  Gesture.m
//  OCProject
//
//  Created by chen on 7/22/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "GrayGesture.h"
/* 这里是手势类的一个分类，定义了下面几个和 UIResponder 一样的几个 touch 方法 */
//#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation GrayGesture
/* 注意下面的 touchs 方法不是 UIRespnder 的 touch 方法，是自己的，自己分类里的，手势类型识别就是靠这些 touchs 方法 */
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

@end
