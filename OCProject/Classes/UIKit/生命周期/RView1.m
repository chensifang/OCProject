//
//  RView1.m
//  OCProject
//
//  Created by chen on 7/4/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "RView1.h"
#import "RView.h"
#import "UIColor+Extension.h"
@implementation RView1

- (instancetype)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

- (void)drawRect:(CGRect)rect {
    RView *view = [[RView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    view.backgroundColor = kRandomColor;
    [self addSubview:view];
    
    
}

@end
