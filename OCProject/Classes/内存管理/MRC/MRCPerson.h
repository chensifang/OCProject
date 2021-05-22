//
//  MRCPerson.h
//  OCProject
//
//  Created by chensifang on 2018/7/10.
//  Copyright © 2018 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRCPerson : NSObject <NSCopying>
@property (nonatomic, copy) void(^myBlock)(void);
+ (instancetype)newPerson;
+ (instancetype)somePerson;
@end

NS_ASSUME_NONNULL_END
