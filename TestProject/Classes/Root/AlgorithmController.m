//
//  AlgorithmController.m
//  TestProject
//
//  Created by chensifang on 2018/9/17.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "AlgorithmController.h"

@interface AlgorithmController ()

@end

@implementation AlgorithmController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"基础算法");
    
    [self addCellWithTitle:@"算法入口" nextVC:@"MainAlgorithmController"];
    [self addCellWithTitle:@"基础算法" nextVC:@"AlgorithmViewController"];
    ADD_SECTION(@"栈");
    [self addCellWithTitle:@"栈算法" nextVC:@"StackViewController"];
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
