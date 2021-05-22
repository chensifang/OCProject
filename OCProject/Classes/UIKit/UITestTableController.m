//
//  UITestTableController.m
//  OCProject
//
//  Created by chen on 7/6/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "UITestTableController.h"

@interface UITestTableController ()

@end

@implementation UITestTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCellWithTitle:@"导航控制器测试" nextVC:@"NavTestTableController"];
    [self addCellWithTitle:@"TableView" nextVC:@"TableViewController"];
}



@end
