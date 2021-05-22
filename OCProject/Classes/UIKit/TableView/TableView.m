//
//  TableView.m
//  OCProject
//
//  Created by chen on 7/27/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "TableView.h"

@implementation TableView

- (instancetype)initWithFrame:(CGRect)frame {
    self= [super initWithFrame:frame];
    self.delegate = self;
    self.dataSource = self;
    return self;
}


#pragma mark - ---- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%s", __func__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%s", __func__);
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseCell" forIndexPath:indexPath];
    NSLog(@"返回cell： %zd", indexPath.row);
    cell.backgroundColor = kRandomColor;
    
    return cell;
}

- (double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"返回 height : %zd", indexPath.row);
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
}

@end
