//
//  MRCTableViewController.m
//  TestProject
//
//  Created by chensifang on 2018/7/10.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "MRCViewController.h"
#import "MRCPerson.h"
#import "MRCPort.h"
#import "ARCPerson.h"
#import "MyButton.h"
#import "SFPort.h"

@interface MRCViewController ()
@property (nonatomic, strong) NSObject *obj;
@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, copy) MRCPerson *objCopy;
@end

@implementation MRCViewController

- (void)setObj:(NSObject *)obj {
    if (_obj != obj) {
        [_obj release];
        _obj = [obj retain];
    }
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"内存管理");
    ADD_CELL(@"MRC 测试释放" , testReturn);
    ADD_CELL(@"MRC 测试retainCount" , testRetainCount);
    
    ADD_SECTION(@"多次 release 问题");
    ADD_CELL(@"Release String", releaseString);
    ADD_CELL(@"Release Array", releaseArray);
    ADD_CELL(@"Release Obj", releaseObj);
    
    ADD_SECTION(@"属性关键字");
    ADD_CELL(@"Strong Setter", testStrongSetter);
    ADD_CELL(@"Copy Setter", testCopySetter);
    
    ADD_SECTION(@"Autoreleasepool");
    ADD_CELL(@"Autorelease释放时机", testAutorelease);
//    ADD_CELL(@"返回值测试", testReturn2);
}



#pragma mark - ---- 多次 release
/*
 除了 NSObject 类型，其他 2 类型都可以多次 release 不 crash
 */
#pragma mark -- string
- (void)releaseString {
    NSString *str = @"dadhajdhaiudhaiohdaidh";
    [str release];
    [str release];
}

#pragma mark -- array
- (void)releaseArray {
    NSArray *array = @[];
    [array release];
    [array release];
}
#pragma mark -- obj
- (void)releaseObj {
    NSObject *obj = NSObject.alloc.init;
    [obj release];
    [obj release];
}

#pragma mark - ---- setter测试
#pragma mark -- strong
- (void)testStrongSetter {
    NSObject *o = [MyButton buttonWithType:1];
    NSLog(@"retainCount : %@", @(o.retainCount));
    self.obj = o;
    /** 如果 setter 里不加判断会导致下面这个野指针 crash */
    [self.obj release];
    self.obj = o;
    [self.obj release];
    NSLog(@"retainCount : %@", @(o.retainCount));
}

#pragma mark -- copy
- (void)setObjCopy:(MRCPerson *)objCopy {
    if ([_objCopy isKindOfClass:NSNull.class]) {
        [_objCopy release];
    }
    _objCopy = [objCopy copy];
}

- (void)testCopySetter {
    self.objCopy = [[MRCPerson alloc] init];
    self.objCopy = [[MRCPerson alloc] init];
    [self.objCopy release];
}

#pragma mark - ---- 测试 autorelease 释放时机
/**
 1. runloop 进入之前会 push 一个释放池，休眠之前会 pop 掉并且 push 一个新的，一旦对象调用 autorelease 会往栈顶 pool 中放入这个对象，pop 时候调用 release 方法。
 */
- (void)testAutorelease {
    /** 从打印来看，delloc 并不是在 runloop 即将睡眠时候调用的，可能 runloop 自带的 observer 和我们创建的有什么不同吧，优先级之类的 */
    __unused MRCPerson *person = [[MRCPerson alloc] init].autorelease;
}

- (void)testRetainCount {
    UIButton *arr = [[UIButton alloc] init];
    NSLog(@"%tu", arr.retainCount);
    
    UIButton *arr1 = [UIButton buttonWithType:1];
    NSLog(@"%tu", arr1.retainCount);
}

- (void)testReturn1 {
    __unused ARCPerson *person = [ARCPerson person];
}

- (void)testReturn {
    /*
     1.alloc 不能释放
     2.port 能释放,因为系统默认在返回值里加了 autorelease
    */
    [[MRCPort alloc] init];
    __unused MRCPort * _Nonnull port = [MRCPort port];
    __unused MRCPerson *person = [MRCPerson somePerson];
}
@end
