//
//  MRCBlockViewController.m
//  TestProject
//
//  Created by chensifang on 2018/9/12.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "MRCBlockViewController.h"
#import "MRCPerson.h"

@interface MRCBlockViewController ()

@end

@implementation MRCBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ADD_SECTION(@"MRC blcok");
    ADD_CELL(@"MRC block 循环引用1",  retainCircle);
    ADD_CELL(@"MRC block 循环引用2",  retainCircle1);
}

#pragma mark - ---- MRC block
- (void)retainCircle {
    __block MRCPerson *person = [[MRCPerson alloc] init];
    person.myBlock = ^{
        NSLog(@"%@", person);
    };
    [person release];
}

- (void)retainCircle1 {
    __unsafe_unretained MRCPerson *person = [[MRCPerson alloc] init];
    person.myBlock = ^{
        NSLog(@"%@", person);
    };
    [person release];
}


@end
