//
//  AFNetViewController.m
//  TestProject
//
//  Created by chensifang on 2018/8/27.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "AFNetViewController.h"
#import <AFNetworking.h>
static NSString * const _Nullable urlString = @"http://www.cocoachina.com/cms/wap.php";
#define kSpiritUrl @"http://172.17.0.20:8088/"
@interface AFNetViewController ()
@property (nonatomic, strong) AFHTTPSessionManager *mg;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;
@end

@implementation AFNetViewController

/*
 1. 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_SECTION(@"请求测试");
    ADD_CELL(@"GET 请求测试", getRequestTest);
    ADD_CELL(@"POST 请求测试", postRequestTest);
    ADD_SECTION(@"下载测试");
    ADD_CELL(@"开始下载", downloadTest);
    ADD_CELL(@"继续下载", resume);
    ADD_CELL(@"暂停下载", suspend);
    ADD_SECTION(@"断点续传");
    ADD_CELL(@"沙盒路径", sandbox);
    ADD_CELL(@"开始下载", downloadTest);
    ADD_CELL(@"取消下载", cancel);
    ADD_CELL(@"续传下载", continueDown);
}

#pragma mark - ---- 调用堆栈测试
#pragma mark -- get 请求
- (void)getRequestTest {
    AFHTTPSessionManager *mg = [AFHTTPSessionManager manager];
    self.mg = mg;
    NSDictionary *dict = @{
                           @"tag" : @"热门",
                           @"type" : @"movie",
                           @"page_start" : @(0),
                           @"page_limit" : @(50)
                           };
    [mg GET:@"https://movie.douban.com/j/search_subjects" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功： %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败： %@", error);
    }];
}

- (void)postRequestTest {
    AFHTTPSessionManager *mg = [AFHTTPSessionManager manager];
    self.mg = mg;
    NSDictionary *dict = @{
                           @"versions_id" : @[@1,@1],
                           @"system_type" : @1
                           };
    [mg POST:@"http://svr.tuliu.com/center/front/app/util/updateVersions" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败： %@", error);
    }];
}

#pragma mark - ---- 断点续传
- (void)sandbox {
    NSLog(@"%@", NSHomeDirectory());
}
- (void)continueDown {
    AFHTTPSessionManager *mg = [AFHTTPSessionManager manager];
    self.mg = mg;
    self.downloadTask = [mg downloadTaskWithResumeData:self.resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"progress：%@",downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"targetPath: %@", targetPath);
        NSLog(@"response : %@", response);
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"targetPath: %@", filePath);
        NSLog(@"response : %@", response);
    }];
    
    [self.downloadTask resume];
}

- (void)cancel {
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
}

#pragma mark -- 下载测试，挂起 & 继续
- (void)downloadTest {
    static NSString *const downloadUrlString = @"https://github.com/tursunovic/xcode-themes/archive/master.zip";
    AFHTTPSessionManager *mg = [AFHTTPSessionManager manager];
    self.mg = mg;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadUrlString]];
    self.downloadTask = [mg downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"progress：%@",downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 不知道为什么其他方式创建路径，最后文件迁移会失败（真机没试过，模拟器失败）
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"targetPath: %@", filePath);
//        NSLog(@"response : %@", response);
    }];
    [self.downloadTask resume];
}

- (void)resume {
    if (self.downloadTask.state == NSURLSessionTaskStateSuspended) {
        [self.downloadTask resume];
    }
}

- (void)suspend {
    if (self.downloadTask.state == NSURLSessionTaskStateRunning) {
        [self.downloadTask suspend];
    }
}





@end
