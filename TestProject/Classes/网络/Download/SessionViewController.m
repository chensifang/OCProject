//
//  SessionViewController.m
//  TestProject
//
//  Created by chensifang on 2018/8/27.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SessionViewController.h"

@interface SessionViewController () <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@end

@implementation SessionViewController
/*
 1. 下载是一直发 http 请求还是只发一次？
    只一次
 2. dataTask 挂起是断开还是不断开？
    不断开，挂起后直到超时才断开。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"dataTask 挂起测试", dataTask);
    ADD_CELL(@"suspend", suspend);
    ADD_CELL(@"resume", resume);
    ADD_CELL(@"cancel", cancel);
}

- (void)dataTask {
    NSString *url = @"https://desktop-release.notion-static.com/Notion-0.3.0.dmg";
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 200;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:NSOperationQueue.alloc.init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSLog(@"%@", request.allHTTPHeaderFields);

    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    self.task = task;
    [task resume];
}
- (void)suspend {
    [self.task suspend];
}
- (void)resume {
    [self.task resume];
}
- (void)cancel {
    [self.task cancel];
}

#pragma mark - delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"%@", downloadTask.currentRequest);
    
    NSLog(@"下载完成");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"进度 ==> %f, 线程：%@", (totalBytesWritten / (float)totalBytesExpectedToWrite), [NSThread currentThread]);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%@", error);
}

@end
