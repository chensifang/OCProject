//
//  Object.h
//  TestProject
//
//  Created by chen on 2019/11/26.
//  Copyright © 2019 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Object : NSObject

@property (atomic, assign) int intA;

- (void)start;

@end

NS_ASSUME_NONNULL_END