//
//  KVOViewController.m
//  TestProject
//
//  Created by chen on 7/11/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "KVOViewController.h"
#import "KVOPerson.h"
#import "MJClassInfo.h"
#import <objc/runtime.h>

@interface KVOViewController ()
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSMutableArray *arrayM;
@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"手动 KVO" , manualKVO);
    ADD_CELL(@"KVO isa混写" , swizzilingTest);
    ADD_CELL(@"KVC 触发 KVO" , fromKVC);
    ADD_CELL(@"KVC 直接成员变量触发 KVO" , _fromKVC);
    ADD_CELL(@"setter 触发 KVO" , hitKVO);
    [self addObserver:self forKeyPath:@"string" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    ADD_CELL(@"KVO观察数组元素" , observerArray);
}

- (void)setString:(NSString *)string {
    _string = string;
}


#pragma mark - ---- 观察数组
- (void)observerArray {
    self.arrayM = @[].mutableCopy;
    [self addObserver:self forKeyPath:@"arr" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    [self.arrayM addObject:@"obj"];
    [self.arrayM removeObject:@"obj"];
}

- (NSMutableArray *)arrayM {
    /* 必须用这个操作数组元素才能监听到 */
    return [self mutableArrayValueForKey:@"arrayM"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%s", __func__);
}

#pragma mark - ---- 触发 KVO
- (void)hitKVO {
    self.string = @"哈哈哈哈";
}

#pragma mark - ---- fromKVC
/*
 打上信号断点后，需要注意的，有疑问的几点:
 1. 只有第一次触发 KVO 的时候才会调用 willChange & didChange，但是每次都会调用 _NSSetObjectValueAndNotify
    调用顺序是 will，change，_NSSetObjectValueAndNotify，setString：
 2. 第一次以后，只会调用 _NSSetObjectValueAndNotify & setString。这里很奇怪，可能跟网上的博客不太一样。
 
 上面的结论是在家里电脑上测试的，在公司电脑测试结果是每次都会调用 will & did
 */
- (void)fromKVC {
//    self.string = @"haha";
    [self setValue:@"haha" forKey:@"string"];
}

// 触发不了 KVO
- (void)_fromKVC {
//    self.string = @"haha";
    NSLog(@"string: %@", _string);
    [self setValue:@"haha" forKey:@"_string"];
    NSLog(@"string: %@", _string);
}


#pragma mark - ---- KVO isa_swizziling
- (void)swizzilingTest {
    static KVOPerson *person;
    person = [[KVOPerson alloc] init];
    mj_objc_object *cls = (__bridge mj_objc_class *)(person);
    __unused BOOL is = class_isMetaClass((__bridge Class)cls->isa) ;
}

#pragma mark - ---- 手动触发 KVO
- (void)manualKVO {
    [self addObserver:self forKeyPath:@"string" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    /* 一定得2个一起才能手动触发回调 */
    [self willChangeValueForKey:@"string"];
    [self didChangeValueForKey:@"string"];
}



@end
