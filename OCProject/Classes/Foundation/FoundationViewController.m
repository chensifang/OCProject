//
//  FoundationViewController.m
//  OCProject
//
//  Created by chensifang on 2018/7/30.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "FoundationViewController.h"
#import "UIColor+Extension.h"
#import "SPerson.h"
#import "SFObject.h"

@interface FoundationViewController ()
@property (class) NSObject *obj;
@end

@implementation FoundationViewController
//@synthesize obj1 = _obj12;
//@dynamic obj;
- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"equal 测试" , equalTest);
    ADD_CELL(@"copy 对象做 key" , objKeyTest);
    ADD_CELL(@"通知中心" , notificationTest);
    ADD_CELL(@"class 变量属性" , classProperty);
    ADD_CELL(@"继承的成员变量问题" , memberTest);
    ADD_CELL(@"extern 测试",  testExtern);
    ADD_CELL(@"数组的 copy", copyArrayTest);
    ADD_CELL(@"数组元素是否 copy", itemIsCopy);
}

#pragma mark - ---- 集合类 copy
- (void)copyArrayTest {
    
    NSMutableString * string = [NSMutableString stringWithFormat:@"1"];
    NSMutableArray * array = [NSMutableArray arrayWithObject:string];
    NSArray * copyArry = [array copy];
    NSMutableArray * mutableCopyArray = [array mutableCopy];
    
    NSLog(@"array:%p", array);
    NSLog(@"copyArry:%p", copyArry);
    NSLog(@"mutableCopyArray:%p", mutableCopyArray);
    [array addObject:@"2"];
    [string appendString:@"1"];
    
    // 可变数组 copy 和 mutableCopy 后，改变原数组的元素的值，能同时改变到后面2数组，可见后俩数组存储的指针和原数组一样，并没有新 copy 出元素，这叫不完全深拷贝
    NSLog(@"array:%p - %@", array, array);
    NSLog(@"copyArry:%p - %@", copyArry, copyArry);
    NSLog(@"mutableCopArray:%p - %@", mutableCopyArray, mutableCopyArray);
}

- (void)itemIsCopy {
    SFObject *obj = [[SFObject alloc] init];
    NSMutableArray * array = [NSMutableArray arrayWithObject:obj];
    __unused NSArray * copyArry = [array copy];
    __unused NSMutableArray * mutableCopyArray = [array mutableCopy];
    // 结果上可以看到，深浅拷贝后的数组元素和原数组的元素是同一个内存地址，元素也没有调用 copyWithZone，可见这只是不完全深拷贝。
    
}



#pragma mark - ---- extern
- (void)testExtern {
    
}

#pragma mark - ---- 继承的成员变量问题
- (void)memberTest {
    // 一个属性能生成2个成员变量，父类一个子类一个，并且 getter & setter 实现中的成员变量不同。子类父类调用 getter & setter 结果不同
//    NSLog(@"%@", _obj12);
//    NSLog(@"%@", super.obj1);
}

#pragma mark - ---- 对象做 key
/**
 内部会调用 copy 方法，会用 isEqual 方法比较。
 */
static NSMutableDictionary *_dict;
- (void)objKeyTest {
    _dict = @{}.mutableCopy;
    SPerson *obj = SPerson.alloc.init;
    [_dict setObject:@"hello" forKey:obj];
    id xx = [_dict objectForKey:obj];
    NSLog(@"%@", xx);
}

- (void)getCopyObjKey {
    NSLog(@"%@", _dict);
}

#pragma mark - ---- class 变量
static NSObject *_obj;
- (void)classProperty {
    for (int i = 0; i < 100; i ++) {
        self.class.obj = NSObject.alloc.init;
        NSLog(@"%@", self.class.obj);
    }
}

+ (void)setObj:(NSObject *)obj {
    _obj = obj;
}

+ (NSObject *)obj {
    return _obj;
}

#pragma mark - ---- 通知
- (void)notificationTest {
    NSObject *obj = NSObject.alloc.init;
    
    /**
     post 的参数为 obj 才能让 observer 收到，
     addObserver的object 参数为 nil 可以收到参数为一切的 post 通知
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"testNotify" object:obj];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"testNotify" object:nil];
}

- (void)notify:(NSNotification *)notifyObj {
    NSLog(@"%s", __func__);
}

#pragma mark - ---- string
- (void)equalTest {
    /** isEqual 各类实现不同 */
    NSString *str1 = @"2";
    NSString *str2 = @"2";
    // 1,1,1
    NSLog(@"%d, %d, %d", str1 == str2, [str1 isEqual:str2], [str1 isEqualToString:str2]);
    
    NSString *str3 = @"22222222222222222222";
    NSString *str4 = @"22222222222222222222";
    // 1,1,1
    NSLog(@"%d, %d, %d", str3 == str4, [str3 isEqual:str4], [str3 isEqualToString:str4]);
    
    NSMutableString *str5 = [NSMutableString stringWithString:@"2"];
    NSMutableString *str6 = [NSMutableString stringWithString:@"2"];
    // 0,1,1,
    NSLog(@"%d, %d, %d", str5 == str6, [str5 isEqual:str6], [str5 isEqualToString:str6]);
    
    NSString *str7 = [NSString stringWithString:@"2"];
    NSString *str8 = [NSString stringWithString:@"2"];
    // 1,1,1
    NSLog(@"%d, %d, %d", str7 == str8, [str7 isEqual:str8], [str7 isEqualToString:str8]);
    
    UIColor *color = [UIColor whiteColor];
    UIColor *color1 = [UIColor hexColor:0xFFFFFF];
    // 0,0
    NSLog(@"%d, %d", color == color1, [color isEqual:color1]);
    
    UIColor *color2 = [UIColor whiteColor];
    UIColor *color3 = [UIColor whiteColor];
    // 1,1
    NSLog(@"%d, %d", color2 == color3, [color2 isEqual:color3]);
}
@end
