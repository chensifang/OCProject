//
//  SFView.m
//  TestProject
//
//  Created by chen on 7/22/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SFView.h"
#import "TouchHeader.h"

@implementation SFView
TouchMethods
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"SFView 响应");
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL yesOrNo = [super pointInside:point withEvent:event];
    CGRect rect = [self upRect];
    if (CGRectContainsPoint(rect, point)) {
        NSLog(@"点击了扩大区域");
        return YES;
    } else {
        return yesOrNo;
    }
}

- (CGRect)upRect {
    CGRect rect = CGRectMake(-self.bounds.size.width * 0.5, -self.bounds.size.height * 0.5, self.bounds.size.width * 2, self.bounds.size.height * 2);
    return rect;
}
@end
