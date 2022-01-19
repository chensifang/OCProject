//
//  OCClassController.m
//  OCProject
//
//  Created by 陈四方 on 2022/1/16.
//  Copyright © 2022 fourye. All rights reserved.
//

#import "OCClassController.h"

@interface OCClassController ()

@end

@implementation OCClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"class 的数据结构");
}

/*
 1. NSObject 类的结构，在源码中如下
 @interface NSObject {
     Class isa;
 }
 
 2. Class 定义如下
 typedef struct objc_class *Class;
 所以 NSObject 其实就只有 objc_class * 类型的成员，名字叫 isa
 
 3. objc_class 定义 (注意去 new 里面找，不然找的是老的)
 struct objc_class : objc_object {
     // Class ISA;
     Class superclass;
     cache_t cache;
     class_data_bits_t bits;
 }
 其中 objc_class 继承 objc_object
 4. objc_object 结构如下：
 struct objc_object {
     isa_t isa;
 }
 综合 3 ，4 objc_class 为：
 struct objc_class {
     isa_t isa;
     Class superclass;
     cache_t cache;
     class_data_bits_t bits;
 }
 */






@end
