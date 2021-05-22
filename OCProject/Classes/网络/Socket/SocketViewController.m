//
//  SocketViewController.m
//  OCProject
//
//  Created by chensifang on 2018/8/3.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "SocketViewController.h"
#import "ChatC.h"
#import "ChatS.h"
#import "ChatUDP.h"
#import "HttpSocket.h"

@interface SocketViewController ()
@property (nonatomic, strong) ChatC *TCP_C;
@property (nonatomic, strong) ChatS *TCP_S;
@property (nonatomic, strong) UITextView *sendDataView;
@property (nonatomic, strong) UILabel *reciveLabel;
@property (nonatomic, strong) ChatUDP *UDP_C;
@property (nonatomic, strong) ChatS *chatS;
@end

@implementation SocketViewController
- (void)reset {
    [self.chatS close];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    self.partTable = YES;
    ADD_SECTION(@"Socket 实现 HTTP");
    ADD_CELL(@"发起 Socket 请求" , startHttp);
    
    ADD_SECTION(@"TCP");
    ADD_CELL(@"建立TCP连接" , bulidTCP);
    ADD_CELL(@"发送数据" , sendTCP);
    
    ADD_SECTION(@"服务端");
    ADD_CELL(@"初始化 S 端" , bulidS);
    ADD_CELL(@"发送数据" , sendS);
    ADD_SECTION(@"UDP");
    ADD_CELL(@"初始化UDP端" , bulidUDP);
    ADD_CELL(@"发送数据" , sendUDP);
}

- (void)setUI {
    UITextView *sendDataView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth * 0.75, 100)];
    self.sendDataView = sendDataView;
    sendDataView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:sendDataView];
    
    UILabel *reciveLabel = [[UILabel alloc] init];
    reciveLabel.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    self.reciveLabel = reciveLabel;
    reciveLabel.frame = CGRectMake(20, 140, kScreenWidth * 0.75, 100);
    [self.view addSubview:reciveLabel];
    
}

#pragma mark - ---- TCP

/**
 有连接
 数据可靠
 无边界
 双工
 C/S模型
 */
- (void)bulidTCP {
    self.TCP_C = [[ChatC alloc] init];
    [self.TCP_C buildClient];
    weak(self);
    [self.TCP_C reciveDataWithBlock:^(NSString *reciveData, NSUInteger length) {
        strong(self);
        NSLog(@"客户端收到 :%@ (length: %lu)", reciveData, length);
        self.reciveLabel.text = reciveData;
    }];
}

- (void)sendTCP {
    [self.TCP_C sendData:self.sendDataView.text];
}

#pragma mark - ---- UDP
- (void)bulidUDP {
    self.UDP_C = [[ChatUDP alloc] init];
    [self.UDP_C buildClient];
    weak(self);
    [self.UDP_C reciveDataWithBlock:^(NSString *reciveData, NSUInteger length) {
        strong(self);
        NSLog(@"reciveData :%@ (length: %lu)", reciveData, length);
        self.reciveLabel.text = reciveData;
    }];
}

- (void)sendUDP {
    [self.UDP_C sendData:self.sendDataView.text];
}

#pragma mark - ---- S
- (void)bulidS {
    self.chatS = ChatS.new;
    [self.chatS buildServer];
}

- (void)sendS {
    [self.chatS sendS:self.sendDataView.text];
}

#pragma mark - ---- HTTP
- (void)startHttp {
//    [HttpSocket netLoadBlock];
    [HttpSocket startHttpPost];
}

@end
