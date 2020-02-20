//
//  GraySuperView.m
//  TestProject
//
//  Created by chen on 7/23/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "ScrollSuperView.h"

@implementation ScrollSuperView

/** 方法1：滑动灰色区域时候，返回 Scroll，就可以让 Scroll 响应滑动,方法2有问题见子类 pointInside 方法 */
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *fitView = [super hitTest:point withEvent:event];
//    if (fitView) {
//        fitView = self.subviews[0];
//    }
//    return fitView;
//}

@end
