//
//  MyLayer.m
//  OCProject
//
//  Created by chen on 7/1/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "MyLayer.h"
#import "NSObject+Extension.h"

/*
 layer 的 frame：他是计算出来的，是个虚拟的属性
 根据 bounds，position，anchorPoint，transform 计算出来的。
 */
@implementation MyLayer
- (instancetype)init {
    self = super.init;
    /* 打印出来，layer 确实没有属性 */
    [self.class logIvarsRecursion:NO];
    return self;
}

- (void)setFrame:(CGRect)frame {
    /* 这里一旦不调用 super 方法，view 设置的 frame 会失效 */
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
}

- (void)setPosition:(CGPoint)position {
    [super setPosition:position];
}

#pragma mark - ---- 绘制相关
- (void)setNeedsDisplay {
    NSLog(@"%s", __func__);
    [super setNeedsDisplay];
}
- (void)display {
    NSLog(@"%s", __func__);
    [super display];
}

/* 走系统的绘制流程都会调用这个方法, 只有代理实现了 displayLayer 才不会走这个方法, 走那个异步绘制入口 */
- (void)drawInContext:(CGContextRef)ctx {
    NSLog(@"%s", __func__);
    [super drawInContext:ctx];
}


@end
