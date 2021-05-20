//
//  RuntimeViewController.m
//  TestProject
//
//  Created by chensifang on 2018/7/30.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "RuntimeViewController.h"
#import "Aspects.h"
#import <objc/runtime.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "NSObject+AOP.h"
#import "SFObject.h"
#import "Object.h"

@interface RuntimeViewController ()
@property (nonatomic, strong) Object *obj;
@property (nonatomic, strong) NSString *returnValue;
@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.obj = [[Object alloc] init];
    /** respondsToSelector 动态添加的方法也算，如果没有显式地实现方法，就走动态消息解析 resolveInstanceMethod  */
    [self addSectionTitle:@"HOOK"];
    ADD_CELL(@"AOP Hook 实例方法" ,myInstanceMethodHook);
    ADD_CELL(@"AOP Hook 类方法" ,myClassMethodHook);
    ADD_CELL(@"Aspect Hook" ,aspectHook);
    ADD_CELL(@"Rac Hook" ,racHook);
    ADD_CELL(@"Rac Hook Obj" ,racHookObj);
    ADD_CELL(@"调用实例方法" ,runInstanceMethod);
    ADD_CELL(@"调用类方法" ,runClassMethod);
    [self addSectionTitle:@"Perform"];
    ADD_CELL(@"多参数 perform" ,perform);
    
    ADD_SECTION(@"签名 & invocation");
    ADD_CELL(@"测试签名 & invocation", testSignAndInvocation);
    
    ADD_SECTION(@"消息发送");
    ADD_CELL(@"test IsNull", testIsNull);
    ADD_CELL(@"atomic", atomic);
    
    
}

- (void)atomic {
    [self.obj start];
}

#pragma mark - ---- 签名&invocation

- (void)testSignAndInvocation {
    NSMethodSignature *sign = [self methodSignatureForSelector:@selector(testWithNum:width:)];
    /*
     MethodSignature 只是代表方法的内存结构，其实也就是返回值和参数的结构（类型，所占内存空间），并不代表方法；方法结构相同的不同方法的签名应该是一样的。
     invocation： 方法对象化
     所以下面这句代码表明用这种方法结构初始化 invocation，并不代表invocation已经和这个 selector 关联起来了，所以还需要设置
     selector & target。
     */
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sign];
    invocation.target = self;
    invocation.selector = @selector(testWithAge:height:);
    int age = 10;
    float height = 100.f;
    [invocation setArgument:&age atIndex:2];
    [invocation setArgument:&height atIndex:3];
    [invocation invoke];
    /**
     几种取得返回值的方法，普通方法 crash,涉及到arc id 对象的内存管理，强指针的话，系统会 release，但其实他没有 retain，导致 crash不用深究。
     1.__weak
     2.__bridge
     */
//    __weak id returnValue;
//    [invocation getReturnValue:&returnValue];
    void *buff;
    [invocation getReturnValue:&buff];
    NSString *returnValue = (__bridge id)buff;
    NSLog(@"returnValue: %@", returnValue);
    
}


- (NSString *)testWithNum:(int)num width:(float)width {
    NSLog(@"%s", __func__);
    return @"我是返回值1";
}

- (NSString *)testWithAge:(int)age height:(float)height {
    NSLog(@"%s", __func__);
    return @"我是返回值2";
}


#pragma mark - ---- perform
- (void)perform {
    id xx = [self performSelector:@selector(logWithObject:withObject:withObject:withObject:withObject:withObject:withObject:) withObject:@1 withObject:@2 withObject:@3 withObject:@4 withObject:@5 withObject:@6 withObject:CGRectMake(0, 0, 20, 20)];
    NSLog(@"%@", xx);
}

- (id)logWithObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 withObject:(CGRect)p7 {
    NSLog(@"%@,%@,%@,%@,%@,%@,%@",p1,p2,p3,p4,p5,p6, NSStringFromCGRect(p7));
    return @(10);
}


- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 withObject:(CGRect)p7 {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
        NSUInteger count = invo.methodSignature.numberOfArguments;
        [invo setTarget:self];
        [invo setSelector:selector];
        count > 2 ? [invo setArgument:&p1 atIndex:2]: nil;
        count > 3 ? [invo setArgument:&p2 atIndex:3]: nil;
        count > 4 ? [invo setArgument:&p3 atIndex:4]: nil;
        count > 5 ? [invo setArgument:&p4 atIndex:5]: nil;
        count > 6 ? [invo setArgument:&p5 atIndex:6]: nil;
        count > 7 ? [invo setArgument:&p6 atIndex:7]: nil;
        count > 8 ? [invo setArgument:&p7 atIndex:8]: nil;
        [invo invoke];
        if (sig.methodReturnLength) {
            id anObject;
            [invo getReturnValue:&anObject];
            return anObject;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

#pragma mark - ---- HOOK 相关
- (void)runClassMethod {
    [RuntimeViewController test:YES num:8];
}

- (void)runInstanceMethod {
    [self test:YES num:8];
}

+ (void)test:(BOOL)yes num:(int)num {
    NSLog(@"类方法：%s %d, %d", __func__, yes, num);
}

- (void)test:(BOOL)yes num:(int)num {
    NSLog(@"func: %@", [NSString stringWithFormat:@"%s", __func__]);
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    NSLog(@"%p", NSSelectorFromString([NSString stringWithFormat:@"%s", __func__]));
    NSLog(@"%p", NSSelectorFromString(@"-[RuntimeViewController test:num:]"));
}

- (void)myClassMethodHook{
    
    [RuntimeViewController hookSelector:@selector(test:num:) option:(AOPHookOptionBefore) block:^(id arg) {
        NSLog(@"回调类 hook");
        NSLog(@"%@", NSStringFromSelector(_cmd));
    }];
}

- (void)myInstanceMethodHook{
    [self hookSelector:@selector(test:num:) option:(AOPHookOptionBefore) block:^(id arg) {
        NSLog(@"回调实例 hook");
        NSLog(@"%@", NSStringFromSelector(_cmd));
    }];
}



- (void)aspectHook {
    [RuntimeViewController aspect_hookSelector:@selector(test:num:) withOptions:(AspectPositionBefore) usingBlock:^{
        
    } error:nil];
}

- (void)racHook {
    [[self.class rac_signalForSelector:@selector(test:num:)] subscribeNext:^(RACTuple * _Nullable x) {
        
    }];
}

- (void)racHookObj {
    [[self rac_signalForSelector:@selector(test:num:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"rac hook call");
    }];
}

#pragma mark - 消息发送
- (void)testIsNull {
    id xxx = [[SFObject alloc] init];
    [xxx performSelector:@selector(isNull)];
}



@end
