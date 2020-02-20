//
//  BlockViewController.m
//  TestProject
//
//  Created by chen on 8/12/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "BlockViewController.h"
#import "BlockObj.h"
#import "NSObject+Extension.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "NSObject+AOP.h"


@interface BlockViewController ()
@property (nonatomic, strong) void(^testBlock)(void);
@property (nonatomic, weak) void(^weakBlock)(void);
@property (nonatomic, strong) void(^strongBlock)(void);
@property (nonatomic, copy) void(^copyBlock)(void);
@property (nonatomic, strong) NSObject *obj;
@end

@implementation BlockViewController
extern int _objc_rootRetainCount(id);

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"block 对象结构");
    ADD_SECTION(@"block 循环引用");
    [self addCellWithTitle:@"retainCount" func:start];
    ADD_CELL(@"hook Block", hookBlock);
    ADD_CELL(@"循环引用", ratainCircle);
    ADD_SECTION(@"题目");
    ADD_CELL(@"block 初始化", blockClassInfo);
    ADD_CELL(@"调用 weakblock", callWeakBlock);
    ADD_CELL(@"案例1", test1);
    ADD_CELL(@"案例2", test2);
    ADD_CELL(@"案例3", test3);
    ADD_CELL(@"案例4", test4);
    ADD_CELL(@"block 外部关联对象", assosatAndBlock);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - ---- block 结构
#pragma mark -- blcok 类信息
- (void)blockClassInfo {
    // 参数不算是外部变量
    int xx = 10;
    self.weakBlock = ^ {
        NSLog(@"%d", xx);
    };
    NSLog(@"%@", self.weakBlock);
    
    self.strongBlock = ^ {
    };
    
    self.copyBlock = ^ {
    };
}

- (void)callWeakBlock {
    self.weakBlock();
}


#pragma mark - ---- 几道题目
#pragma mark -- 案例1
- (void)test1 {
    NSObject *obj = [[NSObject alloc] init];
    _strongBlock = ^{
        NSLog(@"%@", obj);
    };
    obj = nil;
    _strongBlock();
}

#pragma mark -- 案例2
- (void)test2 {
    __block NSObject *obj = [[NSObject alloc] init];
    _strongBlock = ^{
        NSLog(@"%@", obj);
    };
    /*
     ● <NSObject: 0x6000022e20a0>.
     ● (null).
     */
    _strongBlock();
    obj = nil;
    _strongBlock();
}
#pragma mark -- 案例3
- (void)test3 {
    NSObject *obj = [[NSObject alloc] init];
    __weak NSObject *weakObj = obj;
    _strongBlock = ^{
        NSLog(@"%@", weakObj);
    };
    _strongBlock();
    obj = nil;
    _strongBlock();
}

#pragma mark -- 案例4
- (void)test4 {
    /*
     ● <NSObject: 0x6000022e20a0>.
     ● (null).
     */
    _obj = [[NSObject alloc] init];
    _strongBlock = ^ {
        NSLog(@"%@", _obj);
    };
    _strongBlock();
    _obj = nil;
    _strongBlock();
}


#pragma mark -- block & 关联对象
- (void)assosatAndBlock {
    __block id key; // 栈区 key
    objc_setAssociatedObject(self, &key, @1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    void(^block)(void) = ^{
        objc_setAssociatedObject(self, &key, @2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    };
    id m = objc_getAssociatedObject(self, &key); // 获取 &(struct -> forwarding -> key) 堆区
    block();
    id n = objc_getAssociatedObject(self, &key);
    NSLog(@"m: %@, n: %@", m, n);
}

#pragma mark - ---- block 循环引用
- (void)ratainCircle {
    __weak typeof(self) weakSelf = self;
    self.testBlock = ^{
        NSLog(@"%@", weakSelf);
    };
}

#pragma mark - ---- block 数据结构
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

static struct __block_impl *blo;
- (void)hookBlock {
    int a = 10;
    void(^block)(void) = ^ {
        NSLog(@"%d",a);
    };
    
   
    __unused Class cls1 = NSClassFromString(@"__NSMallocBlock");
  
//    [object_getClass(block) logSuperClass];
//    [cls1 logIvarsRecursion:YES];
    Class blockCls = object_getClass(block);
    [blockCls logMethodsRecursion:YES];
    blo = (__bridge struct __block_impl *)block;
    __unused void(*func)(void) = (blo->FuncPtr);
    block();
}


- (void)blockHook {
    NSLog(@"%s", __func__);
}

void start () {
    NSObject *bbb = [NSObject alloc];
    __unused __weak NSObject *aaa = bbb;
    
    void (^myBlock)(void) = ^ {
        NSLog(@"%@", aaa);
    };
    myBlock();
}

void printRetainCount(id obj) {
    NSLog(@"retainCount: %d", _objc_rootRetainCount(obj) - 1);
}

@end
