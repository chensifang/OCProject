//
//  SessionViewController.m
//  TestProject
//
//  Created by chen on 8/26/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SessionViewController.h"

@interface SessionViewController () <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"请求挂起测试", sessionsuspend);
}

#pragma mark - ---- 请求挂起测试
- (void)sessionsuspend {

    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
//    @"https://desktop-release.notion-static.com/Notion-0.3.0.dmg"
    self.session = [NSURLSession sharedSession];
    static NSURLSessionDownloadTask *task;
    task = [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"%@", response);
        }
    }];
    [task resume];
}

@end
