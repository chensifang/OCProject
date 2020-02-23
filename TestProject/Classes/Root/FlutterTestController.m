//
//  FlutterTestController.m
//  TestProject
//
//  Created by chen on 2020/1/7.
//  Copyright © 2020 fourye. All rights reserved.
//

#import "FlutterTestController.h"
#import <Flutter/Flutter.h>
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import "MethodChannelManager.h"

@interface FlutterTestController ()

@end

@implementation FlutterTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"跳转 flutter",handleOpenFlutter);
}

- (void)handleOpenFlutter {
    FlutterViewController *controller = [[FlutterViewController alloc] init];
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
