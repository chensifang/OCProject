//
//  IsaViewController.m
//  OCProject
//
//  Created by chensifang on 2018/8/22.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "IsaViewController.h"
#import <objc/runtime.h>

@interface IsaViewController ()

@end

@implementation IsaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"isa 数据结构" , testIsaRetainCount);
}

union isa_t
{
    isa_t() { }
    isa_t(uintptr_t value) : bits(value) { }
    
    Class cls;
    uintptr_t bits;
    
# if __arm64__
#   define ISA_MASK        0x0000000ffffffff8ULL
#   define ISA_MAGIC_MASK  0x000003f000000001ULL
#   define ISA_MAGIC_VALUE 0x000001a000000001ULL
    struct {
        uintptr_t nonpointer        : 1;
        uintptr_t has_assoc         : 1;
        uintptr_t has_cxx_dtor      : 1;
        uintptr_t shiftcls          : 33; // MACH_VM_MAX_ADDRESS 0x1000000000
        uintptr_t magic             : 6;
        uintptr_t weakly_referenced : 1;
        uintptr_t deallocating      : 1;
        uintptr_t has_sidetable_rc  : 1;
        uintptr_t extra_rc          : 19;
#       define RC_ONE   (1ULL<<45)
#       define RC_HALF  (1ULL<<18)
    };
    
# elif __x86_64__
#   define ISA_MASK        0x00007ffffffffff8ULL
#   define ISA_MAGIC_MASK  0x001f800000000001ULL
#   define ISA_MAGIC_VALUE 0x001d800000000001ULL
    struct {
        uintptr_t nonpointer        : 1;
        uintptr_t has_assoc         : 1;
        uintptr_t has_cxx_dtor      : 1;
        uintptr_t shiftcls          : 44; // MACH_VM_MAX_ADDRESS 0x7fffffe00000
        uintptr_t magic             : 6;
        uintptr_t weakly_referenced : 1;
        uintptr_t deallocating      : 1;
        uintptr_t has_sidetable_rc  : 1;
        uintptr_t extra_rc          : 8;
#       define RC_ONE   (1ULL<<56)
#       define RC_HALF  (1ULL<<7)
    };
    
# else
#   error unknown architecture for packed isa
# endif
};


struct my_objc_object {
    isa_t isa;
};
#pragma mark - ---- isa 引用计数
- (void)testIsaRetainCount {
    const void *key;
    objc_setAssociatedObject(self, key, @1, OBJC_ASSOCIATION_ASSIGN);
    void(^block)(void) = ^ {
        self;
        NSLog(@"%s", __func__);
    };
    __unused __weak void(^block1)(void) = block;
    __unused my_objc_object *objc = (__bridge my_objc_object *)block;
    NSLog(@"");
}

#pragma mark - ---- selector
- (void)selectorTest {
//     typedef struct objc_selector *SEL， 所以是一个结构体指针，内部成员没开源。
}

@end
