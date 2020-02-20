//
//  SFPerson.m
//  testProject
//
//  Created by chen on 2018/6/13.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import "KVOPerson.h"
#import <objc/runtime.h>
#import <objc/message.h>
//#import "NSObject+Extension.h"
@interface KVOPerson()
@property (nonatomic, copy) NSString *name;
@end

@implementation KVOPerson
- (instancetype)init {
    self = [super init];
    [self isaSwizzling];
    [self lookKVOCpp];
    return self;
}

#pragma mark - ----  isa 混写 实现 KVO
- (void)isaSwizzling {
    NSString *newName = [@"SFKVONotifying_" stringByAppendingString:NSStringFromClass(object_getClass(self))];
    NSString *setterName = @"setName:";
    
    Class subCls = objc_allocateClassPair(object_getClass(self), [newName UTF8String], 0);
    Method method = class_getInstanceMethod(self.class, @selector(setAndNotify:));
    const char *types = method_getTypeEncoding(method);
    IMP imp = method_getImplementation(method);
    class_addMethod(subCls, NSSelectorFromString(setterName), imp, types);
    objc_registerClassPair(subCls);
    object_setClass(self, subCls);
    [self setName:@"你好"];
//    [self.class logIvarsRecursion:YES];
    NSLog(@"class : %@", self.class);
}

- (void)note {
    // 上面这个方法就是正确赋值 superCls = KVOPerson.
    /*
     struct objc_super {
     /// Specifies an instance of a class.
     __unsafe_unretained _Nonnull id receiver;
     __unsafe_unretained _Nonnull Class super_class;
     // super_class is the first class to search
     }*/
    
    
    /* 此处如果用下面这个不行:
     [super performSelectorInBackground:@selector(setName:) withObject:arg1];
     转换成 cpp:
     (id)class_getSuperclass(objc_getClass("KVOPerson")) self 会从 KVOPerson 的父类方法列表去找,也就是 NSObject, 主要是此时编译阶段编译器不知道 self 不是 KVOPerson 类型了;
     ((id (*)(__rw_objc_super *, SEL, SEL, id))(void *)objc_msgSendSuper)((__rw_objc_super){(id)self, (id)class_getSuperclass(objc_getClass("KVOPerson"))}, sel_registerName("performSelector:withObject:"), sel_registerName("setName:"), (id)arg1);
     */
}

- (void)setAndNotify:(id)arg1 {
    Class superCls = class_getSuperclass(object_getClass(self));
    struct objc_super superInfo = {
        self,
        superCls
    };
    ((void (*) (void * , SEL, ...))objc_msgSendSuper)(&superInfo, _cmd, arg1);
}

- (void)setName:(NSString *)name {
    _name = name;
}


// 测试 KVO 的 setter 的 IMP
+ (void)testIMP {
    KVOPerson *person = [[KVOPerson alloc] init];
    [person addObserver:person forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
    __unused IMP imp = [person methodForSelector:@selector(setName:)];
    // result (IMP) imp = 0x0000000107bdaa7a (Foundation`_NSSetObjectValueAndNotify)
    __unused IMP imp1 = class_getMethodImplementation(object_getClass(person), @selector(setName:));
    // result (IMP) imp = 0x0000000107bdaa7a (Foundation`_NSSetObjectValueAndNotify)
}

#pragma mark - ---- KVO cpp
- (void)lookKVOCpp {
    // 转成 cpp 看不到什么 isa 混写的东西,可能是因为不到运行时
    [self addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
}

@end
