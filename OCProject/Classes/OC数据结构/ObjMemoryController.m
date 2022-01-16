//
//  ObjMemoryController\.m
//  OCProject
//
//  Created by 陈四方 on 2022/1/15.
//  Copyright © 2022 fourye. All rights reserved.
//

#import "ObjMemoryController.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

@interface Person : NSObject
{
    int _age;
    int _age1;
};
@end

@implementation Person
@end

@interface Student : Person
{
    int _age2;
};
@end

@implementation Student

@end

@interface Cat : NSObject
{
    int x1;
    int x2;
    int x3;
};
@end

@implementation ObjMemoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"内存测试");
    ADD_CELL(@"NSObject 对象占用多少内存", testNSObjectMemory);
    ADD_CELL(@"Person 对象占用多少内存", testPersonMemory);
    ADD_CELL(@"Student 对象占用多少内存", testStudentnMemory);
    ADD_CELL(@"sizeof", sizeofTest);
    ADD_CELL(@"测试 log", logTest);
}

#pragma mark - 占用多少内存
/*
 class_getInstanceSize: 需要多少空间
 malloc_size：真实分配了多少空间
 */

- (void)testNSObjectMemory {
    NSObject *x = [[NSObject alloc] init];
    size_t s1 = class_getInstanceSize([NSObject class]);
    NSLog(@"%zd", s1);
    size_t s2 = malloc_size((__bridge const void*)x);
    NSLog(@"%zd", s2);
    
    /* NSObject 的结构
     typedef struct objc_class *Class;

     @interface NSObject {
         Class isa;
     }
     NSObject 只有一个成员 isa, 是一个结构体指针, 占用 8 个字节
     
     */
    
    /* 注意: 这里是 NSObject 对象, 不包含他的子类, 子类新增 ivar 内存就不是这么多了
     对于 NSObject 系统为其分配了 16 个字节, 但是实际只用了 8 个字节装 isa
     源码:
     size_t instanceSize(size_t extraBytes) {
         size_t size = alignedInstanceSize() + extraBytes;
         // CF requires all objects be at least 16 bytes.
         if (size < 16) size = 16;
         return size;
     }
     */
}

- (void)testPersonMemory {
    Person *x = [[Person alloc] init];
    size_t s1 = class_getInstanceSize([Person class]);
    NSLog(@"%zd", s1);
    size_t s2 = malloc_size((__bridge const void*)x);
    NSLog(@"%zd", s2);
    /* 打印看到, 2 个成员变量占用了剩下了 8 个字节
     [2022-01-15 18:46:11.165] -[OCStructViewController testMemory][50行] ● 16.
     [2022-01-15 18:46:11.165] -[OCStructViewController testMemory][52行] ● 16.
     */
}

- (void)testStudentnMemory {
    Student *x = [[Student alloc] init];
    size_t s1 = class_getInstanceSize([Student class]);
    NSLog(@"%zd", s1);
    size_t s2 = malloc_size((__bridge const void*)x);
    NSLog(@"%zd", s2);
    /* 内存对其: 结构体大小必须是最大成员大小的倍数
     [2022-01-15 19:49:38.868] -[OCStructViewController testStudentnMemory][113行] ● 24.
     1. 由于父类 isa 占用 8, _age，_age1 占用剩下 8；age2 占用 4, 应该一共占用 20; 但是由于字节对齐，必须是 8 的倍数，所以是 24 字节
     
     [2022-01-15 19:49:38.868] -[OCStructViewController testStudentnMemory][115行] ● 32.
     2. 这里为什么是 32，在 OC 对象初始化的时候调用 allocWithZone 最终调用 calloc，传一个 size，其实就是传入上面的 24。但是 calloc 里不会真的分配 24，会返回 32，iOS 里堆内存的堆内存的分配都是 16 的倍数，这个也是一种对齐，但是不是上面的对齐，这个是 iOS 自己的策略，16 的倍数可能对他的操作系统更有利
     */
}

- (void)sizeofTest {
    /*
     sizeof 是编译特性，在编译的时候就把 sizeof(int) 直接变为 4
     */
    NSLog(@"%zd", sizeof(int));
}

- (void)logTest {
    NSObject *x = [[NSObject alloc] init];
    NSLog(@"%@", x);
    NSLog(@"%p", x);
    /* 打印的结果是一样的
     [2022-01-15 21:34:33.807] -[ObjMemoryController logTest][124行] ● <NSObject: 0x600001329810>.
     [2022-01-15 21:34:33.807] -[ObjMemoryController logTest][125行] ● 0x600001329810.
     */
    
    // 根据类名 找到这个 Class，没有的话就返回 null
    Class c = objc_getClass("ObjMemoryController");
    NSLog(@"%@", c);
    // 传入 id 类型， 返回他的类
    Class c1 = object_getClass(self);
    NSLog(@"%@", c1);
}


@end
