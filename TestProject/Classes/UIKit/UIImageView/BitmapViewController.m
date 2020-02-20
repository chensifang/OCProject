//
//  BitmapViewController.m
//  TestProject
//
//  Created by chen on 7/4/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "BitmapViewController.h"

@interface BitmapViewController () <UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *orignImage;
@property (nonatomic, strong) NSData *orignImageData;
@end

@implementation BitmapViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.partTable = YES;
    [self loadImage];
    ADD_SECTION(@"图片基本属性");
    ADD_CELL(@"压缩", compress);
    ADD_SECTION(@"操作图片");
    ADD_CELL(@"修改像素单元" , filterImage);
    ADD_CELL(@"截屏" , shotScreen);
    ADD_CELL(@"蒙层" , blend);
    ADD_CELL(@"截图" , shot);
    NSLog(@"%@", self.view);
}

/*
 从图片文件把图片数据的像素拿出来(RGBA) ,对像素进行操作,进行一个转换(Bitmap(GPU))修改完之后，
 还原(图片的属性RGBA, RGBA (宽度，高度，色值空间，拿到宽度和高度，每一个画多少个像素，画少行))
 */
- (void)reset {
    [_imageView removeFromSuperview];
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ICON"]];
    _imageView.frame = CGRectMake(0, 0, 200, 200);
    [self.view addSubview:_imageView];
}

#pragma mark - ---- 压缩一张图片

/*
 所谓生成图片就是按照格式压缩图片文件，生成 png，jpg 都是压缩图片文件的一种方式
 */
- (void)getImageFromDevice {
    _orignImage = [UIImage imageNamed:@"ICON"];
    // 相册获取
//    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
//    vc.delegate = (id)self;
//    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    _orignImage = info[@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadImage {
    // jpg 还不能把格式放在后面参数里
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ICON.JPG" ofType:nil];
    _orignImageData = [NSData dataWithContentsOfFile:path];
    _orignImage = [UIImage imageWithData:_orignImageData];
}

- (void)compress {

    // png
    NSData *pngData = UIImagePNGRepresentation(_orignImage);
    
    // jpg
    NSData *jpgData = UIImageJPEGRepresentation(_orignImage, 0.1);
    
    __unused UIImageView *png = [[UIImageView alloc] initWithImage:[UIImage imageWithData:pngData]];
    __unused UIImageView *jpg = [[UIImageView alloc] initWithImage:[UIImage imageWithData:jpgData]];
    /*
     ● orginJPG: 21.843750 kb.
     ● png: 157.488281 kb.
     ● jpg: 55.559570 kb.
     png 比原始图片还大怎么导致的？
     */
    NSLog(@"orginJPG: %@", getKB(_orignImageData));
    NSLog(@"png: %@", getKB(pngData));
    NSLog(@"jpg: %@", getKB(jpgData));
    
    [self compressWithImage:_orignImage size:_orignImage.size];
}
#pragma mark -- 利用上下文压缩
/*
 这样通过上下文绘制的会小很多，为什么？
 */
- (UIImage *)compressWithImage:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

NSString *getKB(NSData *data) {
    NSUInteger bytes = data.length;
    float kb = bytes / 1024.f;
    return [NSString stringWithFormat:@"%f kb", kb];
}

#pragma mark - ---- 添加蒙层
- (void)blend {
    [self reset];
    UIImage *image = [UIImage imageNamed:@"ICON"];
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    UIColor *color = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, CGRectMake(0, 0, 200, 200));
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    _imageView.image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
}

#pragma mark - ---- 截图
- (void)shot {
    [self reset];
    UIGraphicsBeginImageContext(CGSizeMake(1000 , 1000));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    /* Renders the receiver and its sublayers into 'ctx'. This method
     将调用者的 layer & sublayers 的内容放入 ctx。
     */
    [self.view.layer renderInContext:ctx];
    CGImageRef lastImage = CGBitmapContextCreateImage(ctx);
    UIGraphicsEndImageContext();
    _imageView.image = [UIImage imageWithCGImage:lastImage];
    CGImageRelease(lastImage);
}

#pragma mark - ---- 截取某区域图片
- (void)shotScreen {
    [self reset];
    UIImage *image = [UIImage imageNamed:@"ICON"];
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, 200, 200);
    // 这就是画椭圆的函数
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    /* 要放在 CGContextClip 这句代码后面，表示在这个截取的上下文区域绘制 */
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _imageView.image = clipImage;
}

#pragma mark - ---- 彩色变黑白图
- (void)filterImage {
    [self reset];
    CGImageRef imageRef = _imageView.image.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bits = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPrerow = CGImageGetBytesPerRow(imageRef); // 一行多少位 width * bits。
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    /** 讲图片转换为 bitmap  */
    CGDataProviderRef providerRef = CGImageGetDataProvider(imageRef);
    CFDataRef bitmapData = CGDataProviderCopyData(providerRef);
    
    NSInteger pixLength = CFDataGetLength(bitmapData);
    /* 转换成 char 数组是为了可以修改它，同理下面的 testData */
    Byte *pixbuf = CFDataGetMutableBytePtr((CFMutableDataRef)bitmapData);
    
    // RGBA 为一个单元
    
    for (int i = 0; i < pixLength; i+=4) {
        [self imageFilterPixBuf:pixbuf offset:i];
    }
    
    
    // 修改了 bitmap 之后在新的上下文合成图片
    CGContextRef bitmap = CGBitmapContextCreate(pixbuf, width, height, bits, bitsPrerow, colorSpace, alphaInfo);
    CGImageRef lastImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *image = [UIImage imageWithCGImage:lastImageRef];
    _imageView.image = image;
    
}

- (void)imageFilterPixBuf:(Byte *)pixBuf offset:(int)offset {
    int offsetR = offset;
    int offsetG = offset + 1;
    int offsetB = offset + 2;
    int offsetA = offset + 3;
    
    int red = pixBuf[offsetR];
    int green = pixBuf[offsetG];
    int blue = pixBuf[offsetB];
    __unused int alpha = pixBuf[offsetA];
    
    // 简单修改像素值，变为平均值。 RGB 值都相等的时候就是黑白色。
    int gray = (red + green + blue)/3;
    pixBuf[offsetR] = gray;
    pixBuf[offsetG] = gray;
    pixBuf[offsetB] = gray;
}

- (void)testData {
    /* 下面的代码转换成 ASCII 码。*/
    NSString *testStr = @"1234";
    NSData *data = [testStr dataUsingEncoding:4];
    NSLog(@"%@", data); // <31323334>
    NSUInteger length = data.length;
    // typedef UInt8  Byte;
    Byte *bytes = (Byte *)[data bytes];
    for (int i = 0; i < length; i++) { // print （7,8,9,：）， ：在ASCII 码中表示10
        NSLog(@"%c", bytes[i] + 6);
    }
}


@end
