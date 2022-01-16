//
//  ViewController.m
//  OCProject
//
//  Created by Picooc on 2017/6/24.
//  Copyright © 2017年 fourye. All rights reserved.
//

#import "OCStructViewController.h"
#import "KVOPerson.h"
#import <objc/runtime.h>
#import "SFViewController.h"
#import "RunloopOb.h"
#import "SFPerson.h"
#import "MMViewController.h"
#import "ChatC.h"
#import "ChatUDP.h"
#import "NSObject+Extension.h"
#import "ResponseChainVC.h"
#import "SFPerson.h"

@interface OCStructViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, strong) void(^block)(int a);
@end

@implementation OCStructViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"isa");
    ADD_CELL(@"模拟 isa" , testPointer);
    ADD_CELL(@"循环引用" , testRetainCircle);
    ADD_CELL(@"TaggedPoint 测试1" , testTaggedPoint);
    ADD_CELL(@"TaggedPoint 测试2" , testTaggedPoint1);
    ADD_CELL(@"对象本质", whatIsObj);
    ADD_SECTION(@"关键字测试");
    ADD_CELL(@"测试静态变量" , testStatic);
    ADD_CELL(@"测试const" , testConst);
    [self addCellWithTitle:@"isa" nextVC:@"IsaViewController"];
}



#pragma mark - ---- 对象 C++ 结构
- (void)whatIsObj {
    /*
     Tuple 重编译后，就是这个结构，继承了 NSObject_IMPL 的 IVARS部分
    struct Tuple_IMPL {
        struct NSObject_IMPL NSObject_IVARS;
        id  _Nonnull __strong _first;
        id  _Nonnull __strong _second;
        id  _Nonnull __strong _third;
        id  _Nonnull __strong _fourth;
        id  _Nonnull __strong _fifth;
        id  _Nonnull __strong _last;
        NSArray * _Nonnull __strong _args;
    };
     */
}


static NSObject *_obj;
- (void)testStatic {
    static NSObject *_obj;
    _obj = [[NSObject alloc] init];
    // obj 地址不同
    NSLog(@"%@", _obj);
    // 指针地址是相同的
    NSLog(@"%p", &_obj);
}

#pragma mark - ---- c 语言关键字测试
#pragma mark -- const 测试
+ (void)testConst {
    // const 只修饰他后面的东西。
    int i = 10;
    // 此时 const 修饰的 int 类型，也就是说*pi 是不能改的
    const int *pi = &i;
    int j = 20;
    pi = &j;
    //    *pi = 100; // 不能修改
    
    
    //
    int * const pi1 = &i;
    *pi1 = 200;
    // const NSString 这么写没有意义，本身就是不可变的,应该写在后面
    __unused const NSString * str = @"ddd";
    // 应该这么写
    __unused NSString *const str1 = @"ddd";
//    *str = @"dds";
    
    //    a = b;
    //    int * const b = 20;
    //    a = &b;
    
    //    const int *p_a = 20;
    //    *p_a = 10;
    //    a = 12;
}

#pragma mark - ---- testTaggedPoint
- (void)testTaggedPoint {
    /* c++ 文件（.mm）可以下面直接赋值，oc 不行 */
//    static SFPerson *person = SFPerson.alloc.init;
    static SFPerson *person;
    person = SFPerson.alloc.init;
    /* 会crash，多次调用 release，坏内存访问，线程不安全 */
    dispatch_apply(10000, dispatch_get_global_queue(0, 0), ^(size_t idx) {
//        person.name = [NSString stringWithFormat:@"dahdajdlajdlajdaljda"];
    });
    /* 不会crash，这是个taggedPoint类型，不是对象，没有引用计数，系统内部会处理setter，不调用引用计数方法。 */
    dispatch_apply(10000, dispatch_get_global_queue(0, 0), ^(size_t idx) {
        person.name = [NSString stringWithFormat:@"dah"];
    });
    /* [NSString stringWithFormat:@"dahd"] 这样创建的字符串地址不同，@“daad”这种是常量，地址一样。   */
    
}

- (void)testTaggedPoint1 {
    /* 断点可以看到，mutableStr 不会是 taggedPointer 类型，也能想到，操作他的时候不可能改变内存地址 */
   __unused NSMutableString *str = [NSMutableString stringWithFormat:@"222"];
   __unused NSString *str1 = [NSString stringWithFormat:@"222"];
}


#pragma mark - ---- 循环引用
- (void)testRetainCircle {
    // GCD 不用加 weakself
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:SFViewController.alloc.init animated:YES completion:nil];
    });
}

#pragma mark - ---- 指针指向 class 模拟isa
- (void)testPointer {
    __unused NSString *tmp = @"hello world";
    id cls = [SFPerson class];
    void *isa = &cls;
    [(__bridge id)isa test];
}

- (void)test {
    NSLog(@"%s",__func__);
    
}



@end
