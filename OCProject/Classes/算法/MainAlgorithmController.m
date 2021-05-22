//
//  MainAlgorithmContorller.m
//  OCProject
//
//  Created by chen on 2019/8/10.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "MainAlgorithmController.h"

@interface MainAlgorithmController ()

@end

@implementation MainAlgorithmController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCellWithTitle:@"斐波那契" nextVC:@"FibController"];
    ADD_SECTION(@"线性表");
    [self addCellWithTitle:@"数组" nextVC:@"LinearListController"];
    [self addCellWithTitle:@"链表" nextVC:@"LinkListController"];
//    [self ]
}


@end
