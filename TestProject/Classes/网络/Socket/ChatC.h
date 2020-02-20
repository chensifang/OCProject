//
//  ChatC.h
//  TestProject
//
//  Created by chen on 2018/6/22.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatC : NSObject
- (void)buildClient;
- (void)sendData:(NSString *)content;
- (void)reciveDataWithBlock:(void(^)(NSString *reciveData, NSUInteger length))reciveBlock;
@end
