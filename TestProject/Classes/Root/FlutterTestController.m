//
//  FlutterTestController.m
//  TestProject
//
//  Created by chen on 2020/1/7.
//  Copyright © 2020 fourye. All rights reserved.
//

#import "FlutterTestController.h"
#import "FlutterTestController.h"
#import <Flutter/Flutter.h>
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

@interface FlutterTestController ()

@property (nonatomic, strong) FlutterViewController *controller;

@end

@implementation FlutterTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"跳转 flutter",handleOpenFlutter);
    ADD_CELL(@"调用 flutter goback", callFlutterGoback);
}

- (void)callFlutterGoback {
    //
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"samples.flutter.io/battery" binaryMessenger:self.controller.binaryMessenger];
    [methodChannel invokeMethod:@"goback" arguments:@{@"number": @"1"} result:^(id  _Nullable result) {
        NSLog(@"%@", result);
        if ([result isEqualToString:@"gobackError"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)handleOpenFlutter {
    FlutterViewController *controller = [[FlutterViewController alloc] init];
    self.controller = controller;
    [controller setInitialRoute:@"/MessagePage"];
    controller.view.backgroundColor = [UIColor blackColor];
    [self presentViewController:controller animated:YES completion:nil];
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"samples.flutter.io/battery" binaryMessenger:controller.binaryMessenger];
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"getBatteryLevel"]) {
            result(@[@([self getBatteryLabel]), @1, @2]);
        }
    }];
}

- (int)getBatteryLabel {
    UIDevice* device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return 22;
    } else {
        return 33;
    }
}


@end
