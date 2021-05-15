//
//  TouchBlueView.m
//  TestProject
//
//  Created by chensifang on 2018/9/5.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "TouchBlueView.h"

@implementation TouchBlueView
TouchHitTest
TouchPointInside

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
- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(20, 20, 200, 200);
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blueColor];
    return self;
}
@end
