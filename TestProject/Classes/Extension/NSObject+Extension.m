//
//  NSObject+Extension.m
//  TestProject
//
//  Created by chen on 2018/6/14.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>
#import "NSObject+AOP.h"
#import <objc/message.h>

@implementation NSObject (Extension)
static NSMutableArray *deallocs_;
static IMP imp;

void deallocsAdd_(NSObject *obj) {
    [deallocs_ addObject:[NSString stringWithFormat:@"%p_%@", obj, obj.class]];
}

- (void)aop {
    SEL sel = NSSelectorFromString(@"dealloc");
    Method dealloc_method = class_getInstanceMethod(NSObject.class, sel);
    imp = method_getImplementation(dealloc_method);
    Method myDealloc_method = class_getInstanceMethod(NSObject.class, @selector(myDealloc));
    method_exchangeImplementations(dealloc_method, myDealloc_method);
}


- (void)myDealloc {
    /* 交换 dealloc 实现, 可以看到很多生僻的 NSObject 对象释放 */
    if ([deallocs_ containsObject:[NSString stringWithFormat:@"%p_%@", self, self.class]]) {
        printf("[%s %s]\n",NSStringFromClass(self.class).UTF8String, NSStringFromSelector(_cmd).UTF8String);
    }
    [self myDealloc];
//    ((void(*)(id, SEL))imp)(self, NSSelectorFromString(@"dealloc"));
}

+ (void)logMethodsRecursion:(BOOL)recursion {
    if ([self isMemberOfClass:object_getClass(NSObject.class)]) {
        if (recursion == NO) {
            return;
        }
        [self logMethodsRecursion:NO];
    } else {
        uint count;
        Method *methods = class_copyMethodList(self, &count);
        for (int i = 0; i < count; i++) {
            SEL method_name = method_getName(*(methods + i));
            IMP imp = method_getImplementation(*(methods + i));
            NSLog(@"%@ => %@ => %p", self,NSStringFromSelector(method_name), imp);
        }
        free(methods);
        if (recursion) {
            [self.superclass logMethodsRecursion:YES];
        }
    }
}

+ (void)logProtocalRecursion:(BOOL)recursion {
    uint count;
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList(self, &count);
    for (int i = 0; i < count; i++) {
        Protocol *pro = protocols[i];
        NSLog(@"%@", NSStringFromProtocol(pro));
    }
    free(protocols);
    if (recursion) {
        [self.superclass logProtocalRecursion:YES];
    }
}


+ (void)logIvarsRecursion:(BOOL)recursion {
    if ([self isMemberOfClass:object_getClass(NSObject.class)]) {
        
    } else {
        uint count;
        Ivar *ivars = class_copyIvarList(self, &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = *(ivars + i);
            NSLog(@"%@==>%@", self.class,[NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding]);
        }
        if (recursion) { 
            [self.superclass logIvarsRecursion:YES];
        }
    }
}

+ (void)logPropertyRecursion:(BOOL)recursion {
    if ([self isMemberOfClass:object_getClass(NSObject.class)]) {
        
    } else {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(self, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSLog(@"%@==>%@", self.class,[NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding]);
        }
        if (recursion) {
            [self.superclass logPropertyRecursion:YES];
        }
    }
    
}

+ (void)logSuperClass {
    Class superCls = class_getSuperclass(self);
    if (superCls) {
        NSLog(@"super: %@", superCls) ;
        [superCls logSuperClass];
    }
}

@end
