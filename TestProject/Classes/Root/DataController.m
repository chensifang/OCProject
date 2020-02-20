//
//  DataViewController.m
//  TestProject
//
//  Created by chensifang on 2018/9/17.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "DataController.h"

@interface DataController ()

@end

@implementation DataController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"内存管理");
    [self addCellWithTitle:@"ARC 内存管理" nextVC:@"MMViewController"];
    [self addCellWithTitle:@"MRC 内存管理" nextVC:@"MRCViewController"];
    ADD_SECTION(@"OC 数据结构");
    [self addCellWithTitle:@"OC 数据结构" nextVC:@"OCStructViewController"];
    [self addCellWithTitle:@"KVO" nextVC:@"KVOViewController"];
    [self addCellWithTitle:@"Runloop" nextVC:@"RunloopViewController"];
    [self addCellWithTitle:@"Runtime" nextVC:@"RuntimeViewController"];
    [self addCellWithTitle:@"Fishhook" nextVC:@"FishhookViewController"];
    
    ADD_SECTION(@"Block");
    [self addCellWithTitle:@"ARC Block" nextVC:@"BlockViewController"];
    [self addCellWithTitle:@"MRC Block" nextVC:@"MRCBlockViewController"];
    [self addCellWithTitle:@"Cpp Block" nextVC:@"BlockCppController"];
    
    ADD_SECTION(@"Foundation");
    [self addCellWithTitle:@"Foundation" nextVC:@"FoundationViewController"];
    
    ADD_SECTION(@"Subjects");
    [self addCellWithTitle:@"Subjects" nextVC:@"SubjectViewController"];
    [self addCellWithTitle:@"性能优化" nextVC:@"OptimizationViewController"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
