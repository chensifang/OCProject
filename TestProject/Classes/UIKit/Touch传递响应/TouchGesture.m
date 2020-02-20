//
//  TouchGesture.m
//  TestProject
//
//  Created by chensifang on 2018/9/5.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "TouchGesture.h"
#import "TouchHeader.h"

@implementation TouchGesture
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [super touchesCancelled:touches withEvent:event];
}
@end
