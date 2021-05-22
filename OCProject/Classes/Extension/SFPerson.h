//
//  Person.h
//  OCProject
//
//  Created by chensifang on 2018/6/22.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFPerson : NSObject <NSCopying>

@property (nonatomic, copy) NSString *name;
+ (instancetype)person;
- (void)test;
@end
