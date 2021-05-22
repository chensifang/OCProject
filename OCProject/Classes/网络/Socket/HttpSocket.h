//
//  HttpEOC.h
//  Chats
//
//  Created by EOC on 2017/6/4.
//  Copyright © 2017年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define URLPath @"http://svr.tuliu.com/center/front/app/util/updateVersions?versions_id=1&system_type=1"

// 第三题
@interface HttpSocket : NSObject

+ (void)netLoadBlock;
+ (void)startHttpPost;

@end
