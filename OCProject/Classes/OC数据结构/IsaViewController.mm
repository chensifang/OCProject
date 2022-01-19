//
//  IsaViewController.m
//  OCProject
//
//  Created by chensifang on 2018/8/22.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "IsaViewController.h"
#import <objc/runtime.h>
#import "SPerson.h"
#import "MJClassInfo.h"

@interface IsaViewController ()

@property (nonatomic, weak) Class weakClass;

@end

@implementation IsaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"isa 地址");
    ADD_CELL(@"isa 地址测试" , testIsaAddress);
    ADD_CELL(@"isa 信息" , isaInfo);
    ADD_SECTION(@"类的结构");
    ADD_CELL(@"ClassInfo" , classInfo);
}

union isa_t {
    isa_t() { }
    isa_t(uintptr_t value) : bits(value) { }

    uintptr_t bits;

private:
    // Accessing the class requires custom ptrauth operations, so
    // force clients to go through setClass/getClass by making this
    // private.
    Class cls;

public:
    struct {
        uintptr_t nonpointer        : 1;
        uintptr_t has_assoc         : 1;
        uintptr_t has_cxx_dtor      : 1;
        uintptr_t shiftcls          : 33; /*MACH_VM_MAX_ADDRESS 0x1000000000*/
        uintptr_t magic             : 6;
        uintptr_t weakly_referenced : 1;
        uintptr_t unused            : 1;
        uintptr_t has_sidetable_rc  : 1;
        uintptr_t extra_rc          : 19;  // defined in isa.h
    };

    bool isDeallocating() {
        return extra_rc == 0 && has_sidetable_rc == 0;
    }
    void setDeallocating() {
        extra_rc = 0;
        has_sidetable_rc = 0;
    }

    void setClass(Class cls, objc_object *obj);
    Class getClass(bool authenticated);
    Class getDecodedClass(bool authenticated);
};


struct my_objc_object {
    isa_t isa;
};

struct my_objc_class {
    isa_t isa;
};

#pragma mark - 测试地址
// 测试 person 的 isa 存储的就是 Person 的地址
- (void)testIsaAddress {
    SPerson *person = SPerson.alloc.init;
    
    Class personClass = SPerson.class;
    Class personMetaClass = object_getClass(personClass);
    NSLog(@"\n对象：%p\n类：%p\n元类：%p", person, personClass, personMetaClass);

    /**
     1. 上面打印的值
     对象：0x600003320c60
     类：0x100ccb028
     元类：0x100ccb000.
     
     2. lldb 打印 isa 值
     $ p/x : 按照 16 进制打印
     $ p/x person->isa:
    (Class) $1 = 0x0100000100ccb029 SPerson
     $ p/x 0x0100000100ccb029 & 0x007ffffffffffff8ULL:
     0x0000000100ccb028
     0x007ffffffffffff8ULL 是 ISA_MASK，使用 person 的 isa 地址与上 ISA_MASK 得到 personClass 的地址，可见 person 中 isa 存储的就是 personClass 的地址
     */
    /**
     $ p/x personClass->isa : 报错，因为 Class 里的 isa 未暴露，自己写一个一样的，强转即可
     cls->isa : 0x00000001042df058 与元类 0x00000001042df058 相等，看到对象的 isa 需要与上 ISA_MASK，类的 isa 不需要
     
     */
    mj_objc_class *cls = (__bridge struct mj_objc_class*)personClass;
    NSLog(@"%p", cls->isa);
    
    
}

- (void)isaInfo {
    SPerson *person = SPerson.alloc.init;
    
    __unused mj_objc_object *isaInfo =(__bridge struct mj_objc_object*) person;
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < 1000001; i++) {
        [arr addObject:person];
    }
    const void *key;
    objc_setAssociatedObject(person, key, @1, OBJC_ASSOCIATION_ASSIGN);
    __weak id x = person;
    NSLog(@"xx");
    
}

#pragma mark - classInfo
- (void)classInfo {
    struct mj_objc_class *info = (__bridge mj_objc_class*)SPerson.class;
    class_rw_t *data = info->data();
    NSLog(@"x");
    
}


#pragma mark - ---- selector
- (void)selectorTest {
//     typedef struct objc_selector *SEL， 所以是一个结构体指针，内部成员没开源。
}

@end
