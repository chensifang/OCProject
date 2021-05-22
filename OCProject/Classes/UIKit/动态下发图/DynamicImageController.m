//
//  DynamicImageController.m
//  OCProject
//
//  Created by chen on 2020/6/10.
//  Copyright © 2020 fourye. All rights reserved.
//

#import "DynamicImageController.h"

@interface DynamicImageController ()

@end

@implementation DynamicImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"图片 to 二进制", toData);
}

- (void)toData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ICON" ofType:@"JPG"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:data];
    NSLog(@"%@", data);
    
}

@end
