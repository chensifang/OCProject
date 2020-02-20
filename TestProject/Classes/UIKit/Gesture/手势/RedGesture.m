//
//  RedGesture.m
//  TestProject
//
//  Created by chen on 7/23/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "RedGesture.h"

@implementation RedGesture
- (instancetype)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    self.delegate = self;
    return self;
}


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

#pragma mark - ---- delegate
/** 手势已经识别出来了，是否响应 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%s", __func__);
    return YES;
}

/** 本手势是否与 other 手势共存,2个手势代理中有一个方法返回 YES 就可以共存 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//}

/** 是否接受 touch 事件,返回 NO 连 touchBegan 都不会调用 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

// called before pressesBegan:withEvent: is called on the gesture recognizer for a new press. return NO to prevent the gesture recognizer from seeing this press
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
//
//}



@end
