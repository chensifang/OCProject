//
//  UIView+Extension.m
//  OCProject
//
//  Created by chen on 7/21/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>
@implementation UIView (Extension)
- (void)setText:(NSString *)text {
    BOOL hasLabel = NO;
    [self.subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [obj setValue:obj forKey:@"text"];
            [obj sizeToFit];
            obj.center = CGPointMake(self.height * 0.5, self.width * 0.5);
            *stop = YES;
        }
    }];
    if (!hasLabel) {
        UILabel * label = [[UILabel alloc] init];
        [self addSubview:label];
        label.text = text;
        label.font = [UIFont systemFontOfSize:12];
        [label sizeToFit];
        label.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    }
    objc_setAssociatedObject(self , @selector(text), text, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)text {
   return objc_getAssociatedObject(self, _cmd);
}
@end
