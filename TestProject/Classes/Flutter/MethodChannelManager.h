//
//  MethodChannelManager.h
//  TestProject
//
//  Created by chen on 2020/2/23.
//  Copyright © 2020 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
@interface Messenger : NSObject <FlutterBinaryMessenger>

@end

typedef void(^MethodCall)(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result);

NS_ASSUME_NONNULL_BEGIN

@interface MethodChannelManager : NSObject

+ (instancetype)manager;
- (void)messageMethod:(MethodCall)methodCall;

@end

NS_ASSUME_NONNULL_END
