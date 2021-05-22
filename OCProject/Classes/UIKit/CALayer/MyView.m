//
//  MyView.m
//  OCProject
//
//  Created by chen on 6/30/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "MyView.h"
#import "MyLayer.h"

@implementation MyView
/*
 如果是draWRect (绘制)，需要一块区域来绘制，首先它会生成绘制区域(宽*高)，所有你屏幕上看到的都是image (纹理) ，此时内存大小，就是绘制区域所占内存:宽*高(尺寸) ; retina 屏幕，一个点占2个像素，宽*高*2*4/1024/1024
 */
- (void)drawRect:(CGRect)rect {
    NSLog(@"%s", __func__);
    // 此时获取到的 ctx 就是 - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx 中的 ctx
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(ctx, 5);
    CGContextStrokeRect(ctx, CGRectMake(0, 0, 100, 100));
}

+ (Class)layerClass {
    return MyLayer.class;
}

- (void)setNeedsDisplay {
    NSLog(@"%s", __func__);
    [super setNeedsDisplay];
}

#pragma mark - ---- layer 的代理方法
/*
    整个绘制流程 参考 oneNote 的 “绘制流程”
 */
//- (void)displayLayer:(CALayer *)layer {
//    NSLog(@"%@", NSThread.currentThread);
//    /*
//     这里调用 super 会 crash，找不到这个方法,父类默认是没有实现这个方法的。
//     异步绘制的入口
//     */
//    [self asyncDisplay:layer];
//    NSLog(@"%s", __func__);
//}

// 实不实现该走都要走
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    NSLog(@"%s", __func__);
    [self asyncDisplay:layer];
    // 是下面这个方法触发的 drawRect:
//    [super drawLayer:layer inContext:ctx];
}

#pragma mark -- 异步绘制
- (void)asyncDisplay:(CALayer *)layer {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [UIImage imageNamed:@"ICON"];
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        CGContextRef context = UIGraphicsGetCurrentContext();
        [image drawInRect:CGRectMake(0, 0, 200, 200)];
        UIColor *color = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextFillRect(context, CGRectMake(0, 0, 200, 200));
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        dispatch_async(dispatch_get_main_queue(), ^{
            layer.contents = (__bridge id _Nullable)(imageRef);
        });
    });
}


@end
