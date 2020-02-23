//
//  NativeFlutterVC.m
//  TestProject
//
//  Created by chen on 2020/2/23.
//  Copyright © 2020 fourye. All rights reserved.
//

#import "NativeFlutterVC.h"
#import <Flutter/Flutter.h>

@interface NativeFlutterVC ()

@property (nonatomic, strong) FlutterMethodChannel *pushChannel;

@end

@implementation NativeFlutterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    if (self.navigationController != nil) {
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.pushChannel) {
        return;
    }
    
    __weak typeof(self) ws = self;
    self.pushChannel = [FlutterMethodChannel methodChannelWithName:@"qd.flutter.io/qd_push_main" binaryMessenger:ws];
    [self.pushChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSLog(@"%@", call.method);
        NSLog(@"%@", result);
        [ws handleFlutterMethod:call result:result];
    }];
}


- (void)handleFlutterMethod:(FlutterMethodCall *)call result:(FlutterResult )result {
    if ([call.method isEqualToString:@"pushNativePage"]) {
        NSLog(@"pushNativePage");
    }
}


- (void)gotoBack {
    if (self.navigationController != nil) {
        [self.pushChannel invokeMethod:@"goback" arguments:@{@"number": @"1"} result:^(id  _Nullable result) {
            NSLog(@"%@", result);
            if ([result isEqualToString:@"gobackError"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
