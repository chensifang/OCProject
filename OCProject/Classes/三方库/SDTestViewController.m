//
//  SDTestViewController.m
//  OCProject
//
//  Created by chen on 8/2/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SDTestViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <NSData+ImageContentType.h>
#import <SDWebImage/UIImage+GIF.h>

@interface SDTestViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *imageView2;
@end

@implementation SDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
    ADD_CELL(@"SD 显示 Gif", loadGif);
    ADD_CELL(@"测试调用堆栈" , testCall);
    ADD_CELL(@"获取图片类型" , getImageType);
    
}

#pragma mark - ---- SDWebImage 怎么显示 gif 的 ？
/**
 1. SD 只是做了从 gif 中获取到每一帧的图片，以及每张图片的时长（用到了 ImageIO），最后用系统 animatedImageWithImages 来播放。
 */
- (void)loadGif {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ja" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    /*
     为什么不用系统的方法，因为系统的方法可以加载 Gif image，但是无法 分解为 images，下面 images 是 nil,
     要用系统的 UIImageView 的方法加载 gif，必须把 gif 拆分成 images。
     */
    //    UIImage *orginGif = [UIImage imageWithData:data scale:1];
    //    UIImage *images = orginGif.images;
    UIImage *image = [UIImage sd_imageWithGIFData:data];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0,kScreenWidth, self.topHeight);
    [self.view addSubview:imageView];
}


#pragma mark - ---- 获取图片类型
/*
 图片 data 的第一个字节标识着图片的类型。
 */
- (void)getImageType {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ja.gif" ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    SDImageFormat type = [NSData sd_imageFormatForImageData:imageData];
    NSString *log;
    switch (type) {
        case SDImageFormatJPEG:
            log = @"JPEG";
            break;
        case SDImageFormatPNG:
            log = @"PNG";
            break;
        case SDImageFormatGIF:
            log = @"GIF";
            break;
        default:
            break;
    }
    NSLog(@"图片格式 %@",log);
}

#pragma mark - ---- 调用堆栈测试
- (void)testCall {
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533228196678&di=888abed44dfde822e2b24e3540626f83&imgtype=0&src=http%3A%2F%2Fimg2.ph.126.net%2Fa6bHlU2zA6piHPQMiNFIcg%3D%3D%2F1135188581091556157.jpg"];
    NSURL *url2 = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536383024138&di=9b08e0d64fe4e967e3f04fbe0cba8669&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0117e2571b8b246ac72538120dd8a4.jpg%401280w_1l_2o_100sh.jpg"];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(230, 20, 200, 200)];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.imageView2];
    
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"thumb.png"] options:(SDWebImageRefreshCached | SDWebImageDelayPlaceholder | SDWebImageForceTransition | SDWebImageLowPriority) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"拿到图片1");
    }];
    [self.imageView2 sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"thumb.png"] options:(SDWebImageRefreshCached | SDWebImageDelayPlaceholder | SDWebImageForceTransition | SDWebImageHighPriority) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"拿到图片2");
    }];

    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.imageView.bottom, 50, 50)];
//    [self.imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        NSLog(@"拿到图片2");
//    }];
//    [self.view addSubview:imageView];
    /* com.apple.main-thread */
    NSLog(@"%s",  dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
}

@end
