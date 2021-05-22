//
//  YYView.m
//  TestProject
//
//  Created by chensifang on 2018/9/7.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "YYView.h"
#import <YYAsyncLayer.h>

@implementation YYView
+ (Class)layerClass {
    return YYAsyncLayer.class;
}
@end
