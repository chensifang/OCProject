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

@interface FlutterTestController ()<FlutterPluginRegistry>

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
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    static FlutterMethodChannel* batteryChannel;
    batteryChannel = [FlutterMethodChannel methodChannelWithName:@"samples.flutter.io/battery" binaryMessenger:controller];
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([@"getBatteryLevel" isEqualToString:call.method]) {
            int batteryLevel = [self getBatteryLabel];
            if (batteryLevel == -1) {
                result( [FlutterError errorWithCode:@"UNAVAILABLE" message:@"Battery info unavailable" details:nil]);
            } else {
                result (@(batteryLevel));
            }
        } else {
            result(FlutterMethodNotImplemented);
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
