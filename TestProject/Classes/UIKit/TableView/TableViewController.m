//
//  TableViewController.m
//  TestProject
//
//  Created by chen on 7/27/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "TableViewController.h"
#import "TableView.h"

@interface TableViewController ()
@property (nonatomic, strong) TableView *tableView;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.partTable = YES;
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300 - 10)];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"baseCell"];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kRandomColor;
}

@end
