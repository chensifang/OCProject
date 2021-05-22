//
//  ChatS.h
//  OCProject
//
//  Created by chen on 6/23/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatS : NSObject
- (void)buildServer;
- (void)sendS:(NSString *)content;
- (void)close;
@end

NS_ASSUME_NONNULL_END
