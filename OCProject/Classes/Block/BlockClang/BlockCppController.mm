//
//  BlockCpp.m
//  OCProject
//
//  Created by chen on 2019/6/18.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "BlockCppController.h"
#import "Block1.h"

@implementation BlockCppController


- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"cpp block", cppBlock);
}

#pragma mark - cpp
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

struct __Block_byref_i_0 {
    void *__isa;
    __Block_byref_i_0 *__forwarding;
    int __flags;
    int __size;
    int i;
};

struct __Block1__start_block_impl_0 {
    struct __block_impl impl;
    struct __Block1__start_block_desc_0* Desc;
    __Block_byref_i_0 *i; // by ref
    __Block1__start_block_impl_0(void *fp, struct __Block1__start_block_desc_0 *desc, __Block_byref_i_0 *_i, int flags=0) : i(_i->__forwarding) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __Block1__start_block_func_0(struct __Block1__start_block_impl_0 *__cself) {
    __Block_byref_i_0 *i = __cself->i; // bound by ref
    
    NSLog(@"%d", (i->__forwarding->i));
}
static void __Block1__start_block_copy_0(struct __Block1__start_block_impl_0*dst, struct __Block1__start_block_impl_0*src) {_Block_object_assign((void*)&dst->i, (void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);}

static void __Block1__start_block_dispose_0(struct __Block1__start_block_impl_0*src) {_Block_object_dispose((void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);}

static struct __Block1__start_block_desc_0 {
    size_t reserved;
    size_t Block_size;
    void (*copy)(struct __Block1__start_block_impl_0*, struct __Block1__start_block_impl_0*);
    void (*dispose)(struct __Block1__start_block_impl_0*);
} __Block1__start_block_desc_0_DATA = { 0, sizeof(struct __Block1__start_block_impl_0), __Block1__start_block_copy_0, __Block1__start_block_dispose_0};

static void _I_Block1_start(Block1 * self, SEL _cmd) {
    __attribute__((__blocks__(byref))) __Block_byref_i_0 i = {(void*)0,(__Block_byref_i_0 *)&i, 0, sizeof(__Block_byref_i_0), 2};
    __Block1__start_block_impl_0 temp = __Block1__start_block_impl_0((void *)__Block1__start_block_func_0, &__Block1__start_block_desc_0_DATA, (__Block_byref_i_0 *)&i, 570425344);
    void (*myBlock)(void) = (void (*)())&temp;
//    void (*myBlock)(void) = ((void (*)())&__Block1__start_block_impl_0((void *)__Block1__start_block_func_0, &__Block1__start_block_desc_0_DATA, (__Block_byref_i_0 *)&i, 570425344));
    ((void (*)(__block_impl *))((__block_impl *)myBlock)->FuncPtr)((__block_impl *)myBlock);
}

#pragma mark - cpp block
- (void)cppBlock {
    _I_Block1_start(nil, _cmd);
}

@end
