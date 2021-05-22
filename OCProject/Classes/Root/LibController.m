//
//  LibController.m
//  OCProject
//
//  Created by chensifang on 2018/9/17.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "LibController.h"

@interface LibController ()

@end

@implementation LibController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"三方库");
    [self addCellWithTitle:@"SDWebImage" nextVC:@"SDTestViewController"];
    [self addCellWithTitle:@"AFNetworking" nextVC:@"AFNetViewController"];
    [self addCellWithTitle:@"RACViewController" nextVC:@"RACViewController"];
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
