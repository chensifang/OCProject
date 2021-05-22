//
//  SFSubview1.m
//  OCProject
//
//  Created by chen on 6/24/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SFSubview1.h"
#import "ResponseChainTool.h"

@implementation SFSubview1

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [ResponseChainTool logResponser:self];
    NSLog(@"%s", __func__);
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"%@ ==> %s", self.class, __func__);
    BOOL yesOrNo = [super pointInside:point withEvent:event];
//    NSLog(@"%@ ==> return: %d ==> %s ", self.class, yesOrNo,__func__);
    return yesOrNo;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"%@ ==> %s", self.class, __func__);
    UIView *view = [super hitTest:point withEvent:event];
//    NSLog(@"%@ ==> return -> %@ %s", self.class, view.class,__func__);
    return view;
}

@end
