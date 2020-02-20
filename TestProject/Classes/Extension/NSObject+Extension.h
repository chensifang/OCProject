//
//  NSObject+Extension.h
//  TestProject
//
//  Created by chen on 2018/6/14.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSObject (Extension)
+ (void)logMethodsRecursion:(BOOL)recursion;
+ (void)logIvarsRecursion:(BOOL)recursion;
+ (void)logPropertyRecursion:(BOOL)recursion;
+ (void)logProtocalRecursion:(BOOL)recursion;
+ (void)logSuperClass;
void deallocsAdd_(NSObject *obj);

@end
