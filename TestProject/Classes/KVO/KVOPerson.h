//
//  SFPerson.h
//  TestProject
//
//  Created by chen on 2018/6/13.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SFPersonProtocol
@required
@property (nonatomic, strong) NSString *string;
@end
@interface KVOPerson : NSObject
+ (void)testIMP;
@end
