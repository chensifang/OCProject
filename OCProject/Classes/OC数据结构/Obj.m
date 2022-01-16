//
//  Obj.m
//  OCProject
//
//  Created by 陈四方 on 2022/1/15.
//  Copyright © 2022 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
{
    int _age;
    double _height;
    NSString *_name;
}
/* clang 之后
 struct Student_IMPL {
     struct NSObject_IMPL NSObject_IVARS;
     int _age;
     double _height;
     NSString *_name;
 };
 */
@end

