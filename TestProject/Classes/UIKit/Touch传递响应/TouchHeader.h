//
//  TouchHeader.h
//  TestProject
//
//  Created by chensifang on 2018/9/5.
//  Copyright © 2018 fourye. All rights reserved.
//

#ifndef TouchHeader_h
#define TouchHeader_h

#define TouchHitTest \
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {\
    NSLog(@"%@ => begin", self.class);\
    UIView *hitView = [super hitTest:point withEvent:event];\
    NSLog(@"%@ => retutn: %@", self.class,hitView.class);\
    return hitView;\
}

#define TouchPointInside \
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {\
    BOOL in = [super pointInside:point withEvent:event];\
    NSLog(@"%@ => retutn: %d", self.class, in);\
    return in;\
}

#define TouchMethods \
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {\
    NSLog(@"%s", __func__);\
    [super touchesBegan:touches withEvent:event];\
}\
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {\
    NSLog(@"%s", __func__);\
    [super touchesMoved:touches withEvent:event];\
}\
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {\
    NSLog(@"%s", __func__);\
    [super touchesEnded:touches withEvent:event];\
}\
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {\
    NSLog(@"%s", __func__);\
    [super touchesCancelled:touches withEvent:event];\
}

#endif /* TouchHeader_h */
