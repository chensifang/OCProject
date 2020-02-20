//
//  CoreAnimationController.m
//  TestProject
//
//  Created by chen on 2019/8/10.
//  Copyright © 2019 fourye. All rights reserved.
//

// https://zsisme.gitbooks.io/ios-/content/

#import "CoreAnimationController.h"

@interface CoreAnimationController ()

@property (nonatomic, strong) CALayer *sublayer;

@end

@implementation CoreAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
    ADD_SECTION(@"layer.contents");
    ADD_CELL(@"添加寄宿图", contentImage);
    ADD_CELL(@"contentsScale", contentsScale);
    ADD_CELL(@"contentsRect", contentsRect);
    ADD_CELL(@"图片拆开", sprite);
}

- (void)reset {
    [self.sublayer removeFromSuperlayer];
}

- (CALayer *)sublayer {
    if (!_sublayer) {
        _sublayer = [CALayer layer];
        [self.view.layer addSublayer:self.sublayer];
        [_sublayer setFrame:CGRectMake(0, 0, 200, 200)];
        _sublayer.backgroundColor = [UIColor randomColor].CGColor;
    }
    return _sublayer;
}

#pragma mark - layer contents

- (void)contentImage {
    UIImage *image = [UIImage imageNamed:@"ICON"];
    self.sublayer.contents = (__bridge id)image.CGImage;
    [self.view.layer addSublayer:self.sublayer];
    // contentsGravity: 如果 layer 的 frame 不是正方形会形变，设置 kCAGravityResizeAspect 之后变成适应。
    
    
//    layer.contentsRect = CGRectMake(0, 0, 2, 2);
    
    // [UIScreen mainScreen].scale iPhone 8 ==2，iPhone 8P ==3
    NSLog(@"[UIScreen mainScreen].scale: %f", [UIScreen mainScreen].scale);
}

- (void)contentsScale {
    self.sublayer.contentsGravity = kCAGravityCenter;
    /**
     contentsScale:
     解释：
     - 定义了寄宿图的像素尺寸和视图大小的比例？默认 == 1
     如果设置 contentsGravity = kCAGravityResizeAspect, contentsScale 设置多少都不会起作用，因为已经被拉伸自适应。
     如果 contentsGravity = kCAGravityCenter，contentsScale 的设置会起到很大作用。
     - 如果 contentsScale = 1.0，将会以每个点1个像素绘制图片，如果设置为2.0，则会以每个点 2 个像素绘制图片，这就是我们熟知的 Retina 屏幕（出 plus 系列之前？），
     3x 似乎需要 = 3，也就是说在 contentsScale 相等的情况下，图片像素越高，最后显示就越大。因为 frame 表示点，点相同，一个点显示的像素（contentsScale）相同，那么像素越高的图片就会显得越大。
     */
    self.sublayer.contentsScale = [UIScreen mainScreen].scale;
}

/**
 点 ——
     在 iOS 和 Mac OS中最常见的坐标体系。点就像是虚拟的像素，也被称作逻辑像素。在标准设备上，一个点就是一个像素，但是在Retina设备上，一个点等于2*2 || 3*3 个像素。iOS 用点作为屏幕的坐标测算体系就是为了在 Retina 设备和普通设备上能有一致的视觉效果。
 像素 ——
    物理像素坐标并不会用来屏幕布局，但是仍然与图片有相对关系。UIImage 是一个屏幕分辨率解决方案，所以指定点来度量大小。但是一些底层的图片表示如 CGImage 就会使用像素，所以你要清楚在 Retina 设备和普通设备上，他们表现出来了不同的大小。
 单位
    —— 对于与图片大小或是图层边界相关的显示，单位坐标是一个方便的度量方式， 当大小改变的时候，也不需要再次调整。单位坐标在OpenGL这种纹理坐标系统中用得很多，Core Animation中也用到了单位坐标。
 */

// contentsRect 使用的就是单位坐标, 可以用户图片合成
- (void)contentsRect {
    self.sublayer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
}

- (void)sprite {
    UIImage *image = [UIImage imageNamed:@"ICON"];
    self.sublayer.contents = (__bridge id)image.CGImage;
    self.sublayer.contentsGravity = kCAGravityResizeAspect;
    self.sublayer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
}



@end
