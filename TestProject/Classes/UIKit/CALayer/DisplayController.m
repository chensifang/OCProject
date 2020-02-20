//
//  DisplayController.m
//  TestProject
//
//  Created by chen on 2019/8/17.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "DisplayController.h"
#import "MyLayer.h"
#import "MyView.h"

@interface DisplayController ()<CALayerDelegate>

@end

@implementation DisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
    ADD_SECTION(@"系统绘制");
    ADD_CELL(@"测试无代理的 layer" , testLayerNohasDelegate);
    ADD_CELL(@"测试有代理的 layer" , testLayerHasDelegate);
    ADD_SECTION(@"异步绘制");
    ADD_CELL(@"异步绘制", asyncDisplay);
    ADD_SECTION(@"layer delegate");
    ADD_CELL(@"测试代理方法", layerDelegateSetSelf);
    ADD_CELL(@"测试 appCode", testAppCode);
}

- (void)testAppCode {
    NSLog(@"dayin, xxx");
}

- (void)reset {
    [self removeTopViews];
}

/**
 1. layer 没有 delegate 或者 有 delegate 却没有实现 displayLayer 就走系统绘制流程
 */
#pragma mark - 系统绘制
#pragma mark - ---- 没有代理的 layer, 走系统绘制流程
/**
 ● -[MyLayer setNeedsDisplay].
 ● -[MyLayer display].
 ● -[MyLayer drawInContext:].
 */
- (void)testLayerNohasDelegate {
    MyLayer *layer = MyLayer.layer;
    layer.frame = CGRectMake(200, 100, 100, 100);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    // 注意: 假如我不调用下面这个方法, 上面注释的 3 个方法都不调用.
    [layer setNeedsDisplay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /**
         如果调用了上面 [layer setNeedsDisplay]
         打印结果: <CABackingStore 0x7f9497803d70 (buffer [100 100] BGRA8888)>, 这种 log 表明 layer 没有实在的 contents, 只有个 CABackingStore,
         只有真实生成了寄宿图,才会有值
         如果没调用 [layer setNeedsDisplay]
         打印结果 NULL
         也就是说 setNeedsDisplay 调用了才会去生成寄宿图, 即便是个空的寄宿图
         */
        NSLog(@"%@", layer.contents);
    });
}

#pragma mark - ---- 有代理的 layer 且代理没有实现 displayLayer:  走系统绘制流程
/**
 是否实现 displayLayer: 代理方法，实现了走这个，未实现走系统绘制流程,系统绘制流程走 - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
 */
- (void)testLayerHasDelegate {
    // 注释掉 MyView displayLayer: 才能测试这种情况
    MyView *view = MyView.alloc.init;
    view.frame = CGRectMake(100, 100, 100, 100);
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /**
         如果实现了 - (void)drawRect:(CGRect)rect
         会调用 layer 的 setNeedsDisplay
         打印结果: <CABackingStore 0x7f9497803d70 (buffer [300 300] BGRA8888)>
         如果没有
         不会调用 layer 的 setNeedsDisplay
         打印结果 NULL
         也就是说 - (void)drawRect:(CGRect)rect 最终是用来设置 layer.contents 的
         */
        NSLog(@"%@", view.layer.contents);
    });
    // view 不需要显示调用 setNeedsDisplay, 在 view 初始化的时候会自动调用. 和上面的 testLayerNohasDelegate 不一样
}

#pragma mark - 异步绘制
#pragma mark - ---- 有代理的 layer 且实现了 displayLayer: 另一套(即可以做为异步绘制入口)
- (void)asyncDisplay {
    // 放开 MyView displayLayer: 才能测试这种情况, 就可以在 displayLayer: 中写异步绘制的代码。经过我的测试系统绘制流程一样可以异步绘制
    MyView *view = MyView.alloc.init;
    if (![view respondsToSelector:@selector(displayLayer:)]) {
        NSLog(@"先实现 displayLayer 才能异步绘制");
        return;
    }
    view.frame = CGRectMake(100, 100, 100, 100);
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /**
         真实的生成了 contents
         ● <CGImage 0x7fe8da40fb90> (DP)
         <<CGColorSpace 0x600000ed8300> (kCGColorSpaceICCBased; kCGColorSpaceModelRGB; sRGB IEC61966-2.1)>
         width = 200, height = 200, bpc = 8, bpp = 32, row bytes = 800
         kCGImageAlphaPremultipliedFirst | kCGImageByteOrder32Little  | kCGImagePixelFormatPacked
         is mask? No, has masking color? No, has soft mask? No, has matte? No, should interpolate? Yes
         */
        NSLog(@"%@", view.layer.contents);
    });
}

#pragma mark - layer 代理设置为 self
- (void)layerDelegateSetSelf {
    MyLayer *layer = MyLayer.layer;
    layer.delegate = self;
    layer.frame = CGRectMake(200, 100, 100, 100);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    [layer setNeedsDisplay];
}


@end
