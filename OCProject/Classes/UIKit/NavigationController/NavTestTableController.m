//
//  NavTestTableController.m
//  OCProject
//
//  Created by chen on 7/7/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "NavTestTableController.h"

@interface NavTestTableController ()

@end

@implementation NavTestTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCellWithTitle:@"导航控制器 view" nextVC:@"NavViewController"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}






@end
