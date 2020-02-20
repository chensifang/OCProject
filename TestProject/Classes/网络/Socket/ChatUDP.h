//
//  ChatUDP.h
//  TestProject
//
//  Created by chen on 6/23/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatUDP : NSObject
- (void)buildClient;
- (void)sendData:(NSString *)content;
- (void)reciveDataWithBlock:(void(^)(NSString *reciveData, NSUInteger length))reciveBlock;
@end

NS_ASSUME_NONNULL_END
