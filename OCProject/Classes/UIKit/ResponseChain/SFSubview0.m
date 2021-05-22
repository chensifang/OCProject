//
//  SFSubview0.m
//  OCProject
//
//  Created by chen on 6/24/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SFSubview0.h"
#import "SFSubview1.h"

@implementation SFSubview0

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [super touchesBegan:touches withEvent:event];
   ;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"%@ ==> %s", self.class, __func__);
    BOOL yesOrNo = [super pointInside:point withEvent:event];
//    NSLog(@"%@ ==> return: %d ==> %s ", self.class, yesOrNo,__func__);
    if (yesOrNo == NO) {
        __block UIView *view = nil;
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:SFSubview1.class]) {
                view = obj;
                *stop = YES;
            }
        }];
        CGPoint p = [self convertPoint:point toView:view];
        // 这个点不在父控件的范围内，但是在子控件的范围内。
        if ([view pointInside:p withEvent:event]) { // 判断是否在子控件内部。
            NSLog(@"点击超出父控件的区域");
            /* 核心是返回yes，只有返回yes才会去遍历子控件，否则 hitTest直接返回 。 */
            return YES;
        }
    }
    return yesOrNo;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"%@ ==> %s", self.class, __func__);
    UIView *view = [super hitTest:point withEvent:event];
//    NSLog(@"%@ ==> return -> %@ %s", self.class, view.class,__func__);
    NSLog(@"fit view: %@", view.class);
    return view;
}

@end
