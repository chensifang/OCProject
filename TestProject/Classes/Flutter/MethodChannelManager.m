//
//  MethodChannelManager.m
//  TestProject
//
//  Created by chen on 2020/2/23.
//  Copyright © 2020 fourye. All rights reserved.
//

#import "MethodChannelManager.h"



@implementation Messenger

- (void)sendOnChannel:(nonnull NSString *)channel message:(NSData * _Nullable)message {
   NSLog(@"%s", __func__);
}

- (void)sendOnChannel:(nonnull NSString *)channel message:(NSData * _Nullable)message binaryReply:(FlutterBinaryReply _Nullable)callback {
    NSLog(@"%s", __func__);
}

- (void)setMessageHandlerOnChannel:(nonnull NSString *)channel binaryMessageHandler:(FlutterBinaryMessageHandler _Nullable)handler {
    NSLog(@"%s", __func__);
}

@end

@interface MethodChannelManager()

@property (nonatomic, strong) FlutterMethodChannel *methodChannel;


@end

@implementation MethodChannelManager

singleton_m(MethodChannelManager)

- (instancetype)init {
    if (self = [super init]) {
        self.methodChannel = [FlutterMethodChannel methodChannelWithName:@"samples.flutter.io/battery" binaryMessenger:Messenger.alloc.init];
    }
    return self;
}

- (void)messageMethod:(MethodCall)methodCall {
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        methodCall(call, result);
    }];
}

+ (instancetype)manager {
    return [self shared];
}

@end
