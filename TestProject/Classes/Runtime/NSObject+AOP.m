//
//  NSObject+AOP.m
//  TestProject
//
//  Created by chen on 7/30/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "NSObject+AOP.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+Extension.h"


@implementation NSObject (AOP)

static NSMutableDictionary *_map;

- (void)setBlock:(void(^)(id _Nullable arg))block {
    objc_setAssociatedObject(self , @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(id _Nullable arg))block {
    return objc_getAssociatedObject(self, @selector(block));
}

- (Tuple *)tuple {
    return objc_getAssociatedObject(self, @selector(tuple));
}

- (void)setTuple:(Tuple *)tuple {
    objc_setAssociatedObject(self, @selector(tuple), tuple, OBJC_ASSOCIATION_RETAIN);
}

- (AOPHookOptions)option {
    return [objc_getAssociatedObject(self, @selector(option)) unsignedIntegerValue];
}

- (void)setOption:(AOPHookOptions)option {
    objc_setAssociatedObject(self, @selector(option), @(option), OBJC_ASSOCIATION_ASSIGN);
}

- (void)hookSelector:(SEL)selector option:(AOPHookOptions)option block:(void(^)(id _Nullable arg))block {
    self.block = block;
    self.option = option;
    addHook((NSObject *)self, selector);
}

+ (void)hookSelector:(SEL)selector option:(AOPHookOptions)option block:(void(^)(id _Nullable arg))block {
    self.block = block;
    addHook((NSObject *)self, selector);
}

void hookAllMethods(Class class) {
    uint count;
    Method *instanceMethods = class_copyMethodList(class, &count);
    for (uint i = 0; i < count; i ++) {
        Method method = *(instanceMethods + i);
        SEL selector = method_getName(method);
        hookMethodForAll(class, selector);
    }
    
    Method *classMethods = class_copyMethodList(object_getClass(class), &count);
    for (uint i = 0; i < count; i ++) {
        Method method = *(classMethods + i);
        SEL selector = method_getName(method);
        if (![NSStringFromSelector(selector) isEqualToString:@"load"]) {
            hookMethodForAll(object_getClass(class), selector);
        }
    }
}

static void hookMethodForAll(Class isaClass, SEL selector) {
    Method method = class_getInstanceMethod(isaClass, selector);
    const char *type = method_getTypeEncoding(method);
    SEL hookSelector = NSSelectorFromString([NSString stringWithFormat:@"ALL_HOOK_%@", NSStringFromSelector(selector)]);
    IMP imp = class_getMethodImplementation(isaClass, selector);
    class_addMethod(isaClass, hookSelector, imp, type);
    class_replaceMethod(isaClass, selector, _objc_msgForward, type);
    
    IMP signatureImp = imp_implementationWithBlock(^(id self, SEL selector) {
        Class isaClass = object_getClass(self);
        Method method = class_getInstanceMethod(isaClass, selector);
        const char *type = method_getTypeEncoding(method);
        NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:type];
        return sign;
    });
    
    SEL sel = @selector(methodSignatureForSelector:);
    Method signatureMethod = class_getInstanceMethod(isaClass,sel);
    const char *signType = method_getTypeEncoding(signatureMethod);
    class_replaceMethod(isaClass, sel, signatureImp, signType);
    
    IMP forwardImp = imp_implementationWithBlock(^(id self, NSInvocation *invocation) {
        NSMutableArray *args = @[].mutableCopy;
        NSMutableString *string = @"args：".mutableCopy;
        for (int i = 2; i < invocation.methodSignature.numberOfArguments; i++) {
            id arg = [self getArgWithIndex:i invocation:invocation];
            [args addObject:arg];
            [string appendFormat:@"%@，",arg];
        }
        invocation.target = self;
        if (object_isClass(self)) {
            NSLog(@"+[%@]（%@），（%@）", NSStringFromSelector(invocation.selector),string, invocation.target);
        } else {
            NSLog(@"-[%@]（%@），（%@）", NSStringFromSelector(invocation.selector),string, invocation.target);
        }
        
        SEL hookSelector = NSSelectorFromString([NSString stringWithFormat:@"ALL_HOOK_%@", NSStringFromSelector(invocation.selector)]);
        invocation.selector = hookSelector;
        [invocation invoke];
    });

    SEL forwardSel = @selector(forwardInvocation:);
    Method forwardMethod = class_getInstanceMethod(isaClass,forwardSel);
    const char *forwardType = method_getTypeEncoding(forwardMethod);
    class_replaceMethod(isaClass, forwardSel, forwardImp, forwardType);
    
}


static void addHook(NSObject *self, SEL selector) {
    _SwizzleMethod(self, selector);
    _SwizzleMethodSignature(self);
    _SwizzleForwardInvocation(self);
}

static void _SwizzleMethod(NSObject *self, SEL selector) {
    
    Class isaClass = object_getClass(self);
    BOOL isMetaClass = class_isMetaClass(isaClass);
    
    Method method = class_getInstanceMethod(isaClass, selector);
    const char *type = method_getTypeEncoding(method);
    SEL hookSelector = NSSelectorFromString([NSString stringWithFormat:@"AOP_%@", NSStringFromSelector(selector)]);
    IMP imp = class_getMethodImplementation(isaClass, selector);
    if (isMetaClass) { // 类方法
        class_addMethod(isaClass, hookSelector, imp, type);
        class_replaceMethod(isaClass, selector, _objc_msgForward, type);
    } else { // 实例方法
        NSString *orginClassName = [[NSString alloc] initWithCString:class_getName(self.class) encoding:NSUTF8StringEncoding];
        NSString *subClassName = [NSString stringWithFormat:@"%@_AOP", orginClassName];
        const char *char_sub_class_name = [subClassName UTF8String];
        Class subClass = objc_getClass(char_sub_class_name);
        if (!subClass) {
            subClass = objc_allocateClassPair(isaClass, char_sub_class_name, 0);
            objc_registerClassPair(subClass);
            object_setClass(self,  subClass);
            class_addMethod(isaClass, hookSelector, imp, type);
            class_replaceMethod(isaClass, selector, _objc_msgForward, type);
        }
    }
}


static void _SwizzleMethodSignature(id self) {
    Class isaClass = object_getClass(self);
    IMP signatureImp = imp_implementationWithBlock(^(id self, SEL selector) {
        Class isaClass = object_getClass(self);
        Method method = class_getInstanceMethod(isaClass, selector);
        const char *type = method_getTypeEncoding(method);
        NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:type];
        return sign;
    });
    
    SEL sel = @selector(methodSignatureForSelector:);
    Method signatureMethod = class_getInstanceMethod(isaClass,sel);
    const char *type = method_getTypeEncoding(signatureMethod);
    NSLog(@"%s", type);
    class_replaceMethod(isaClass, sel, signatureImp, type);
}

static void _SwizzleForwardInvocation(id self) {
    Class isaClass = object_getClass(self);
    IMP forwardImp = imp_implementationWithBlock(^(id self, NSInvocation *invocation) {
        NSMutableArray *args = @[].mutableCopy;
        for (int i = 2; i < invocation.methodSignature.numberOfArguments; i++) {
            id arg =[self getArgWithIndex:i invocation:invocation];
            [args addObject:arg];
        }
        Tuple *tuple = [[Tuple alloc] initWithArgs:args.copy];
        invocation.target = self;
        
        SEL subSelector = NSSelectorFromString([NSString stringWithFormat:@"AOP_%@", NSStringFromSelector(invocation.selector)]);
        invocation.selector = subSelector;
        if ([self option] == AOPHookOptionBefore) [(NSObject *)self block](tuple);
        [invocation invoke];
        if ([self option] == AOPHookOptionAfter) [(NSObject *)self block](tuple);
    });
    
    SEL sel = @selector(forwardInvocation:);
    Method signatureMethod = class_getInstanceMethod(isaClass,sel);
    const char *type = method_getTypeEncoding(signatureMethod);
    class_replaceMethod(isaClass, sel, forwardImp, type);
}

- (id)getArgWithIndex:(NSUInteger)index invocation:(NSInvocation *)invocation {
#define TYPE_RETURN(type) \
type val = 0; \
[invocation getArgument:&val atIndex:(NSInteger)index]; \
return @(val);
    const char *argType = [invocation.methodSignature getArgumentTypeAtIndex:index];
    if (argType[0] == 'r') {
        argType++;
    }
    
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        __autoreleasing id returnObj;
        [invocation getArgument:&returnObj atIndex:(NSInteger)index];
        return returnObj;
    } else if (strcmp(argType, @encode(char)) == 0) {
        TYPE_RETURN(char);
    } else if (strcmp(argType, @encode(int)) == 0) {
        TYPE_RETURN(int);
    } else if (strcmp(argType, @encode(short)) == 0) {
        TYPE_RETURN(short);
    } else if (strcmp(argType, @encode(long)) == 0) {
        TYPE_RETURN(long);
    } else if (strcmp(argType, @encode(long long)) == 0) {
        TYPE_RETURN(long long);
    } else if (strcmp(argType, @encode(unsigned char)) == 0) {
        TYPE_RETURN(unsigned char);
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        TYPE_RETURN(unsigned int);
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        TYPE_RETURN(unsigned short);
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        TYPE_RETURN(unsigned long);
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        TYPE_RETURN(unsigned long long);
    } else if (strcmp(argType, @encode(float)) == 0) {
        TYPE_RETURN(float);
    } else if (strcmp(argType, @encode(double)) == 0) {
        TYPE_RETURN(double);
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        TYPE_RETURN(BOOL);
    } else if (strcmp(argType, @encode(char *)) == 0) {
        TYPE_RETURN(const char *);
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        __unsafe_unretained id block = nil;
        [invocation getArgument:&block atIndex:(NSInteger)index];
        return [block copy];
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(argType, &valueSize, NULL);
        unsigned char valueBytes[valueSize];
        [invocation getArgument:valueBytes atIndex:(NSInteger)index];
        return [NSValue valueWithBytes:valueBytes objCType:argType];
    }
    return nil;
    
#undef TYPE_RETURN
}

@end
