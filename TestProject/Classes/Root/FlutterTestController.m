//
//  FlutterTestController.m
//  TestProject
//
//  Created by chen on 2020/1/7.
//  Copyright © 2020 fourye. All rights reserved.
//

#import "FlutterTestController.h"
#import <Flutter/Flutter.h>

@interface FlutterTestController ()

@end

@implementation FlutterTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"跳转 flutter",handleOpenFlutter);
}

- (void)handleOpenFlutter {
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] init];
    [flutterViewController setInitialRoute:@"/MessagePage"];
    flutterViewController.view.backgroundColor = [UIColor blackColor];
    [self presentViewController:flutterViewController animated:YES completion:nil];
}


@end
