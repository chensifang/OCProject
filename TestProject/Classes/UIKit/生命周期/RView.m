//
//  RView.m
//  TestProject
//
//  Created by chen on 7/3/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "UIColor+Extension.h"
#import "RView.h"

@implementation RView
- (instancetype)init {
    NSLog(@"%s", __func__);
    return super.init;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSLog(@"%s", __func__);
    self = [super initWithFrame:frame];
    UIView *subV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    subV.backgroundColor = kRandomColor;
    [self addSubview:subV];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __func__);
    return [super initWithCoder:aDecoder];
}

- (void)awakeFromNib {
    NSLog(@"%s", __func__);
    [super awakeFromNib];
}

- (void)layoutSubviews {
    NSLog(@"%s", __func__);
    self.count ++;
    [super layoutSubviews];
}

/*
 系统提供全局的栈 stack 存放 CGContextRef
 默认情况下是空的。
 */
- (void)drawRect:(CGRect)rect {
    NSLog(@"%s", __func__);
    /* drawRect 里会默认生成一个上下文并和 View 的 CALayer 关联起来 */
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    /* 调用这句会导致下面贝塞尔曲线无法绘制，因为当前的上下文被 pop 出去了 会报错：CGContextSaveGState: invalid context 0x0 */
    UIGraphicsPopContext();
    /*
     下面这句代码写在别的地方是无效的。
     这个贝塞尔曲线就是画在全局的栈顶的那个 CGContextRef（上下文）上。
     */
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:40 startAngle:0.1 endAngle:0.5 clockwise:YES];
    [path stroke];
}


@end
