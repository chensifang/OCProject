//
//  ChatC.m
//  TestProject
//
//  Created by chen on 2018/6/22.
//  Copyright © 2018年 fourye. All rights reserved.
//

#import "ChatC.h"
#import <sys/socket.h>
#import <netinet/in.h>
/* 主要做地址的转换 */
#import <arpa/inet.h>
@implementation ChatC
static int fd;
/* ip：
 本地回环地址：127.0.0.1。
 内网地址：路由器分配的，在 wifi 设置里可以看到。
 外网地址：ip查询网，由网络运营商分配过来。
 */
- (void)buildClient {
    
    /* fd是一个文件描述符,是一个文件句柄?怎么理解, 套接字就是个文件 */
    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd == -1) {
        NSLog(@"创建失败!");
    }
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr("192.168.0.100");
    addr.sin_port = htons(62615);
    /*
     三次握手在这个阶段
     1. 发送信号给服务端,在吗(ACK)
     2. 服务端返回一个信号 在(ACK)
     3. 客户端 那我们开始吧
     */
    /**
     面试点：心跳包，检测连接是否还存在，太快占用网速和性能，曾经 qq 心跳包太快导致电信崩了。
     */
    int result = connect(fd, (struct sockaddr *)&addr, sizeof(addr));
    if (result == -1) {
        NSLog(@"连接失败!");
    } else {
        NSLog(@"连接成功");
        /* 这里就可以发送和监听数据了 */
    }
}

- (void)sendData:(NSString *)content {
    [NSThread detachNewThreadWithBlock:^{
        [self threadSendData:content];
    }];
}

- (void)reciveDataWithBlock:(void(^)(NSString *reciveData, NSUInteger length))reciveBlock {
    [NSThread detachNewThreadWithBlock:^{
        char buf[32];
        while (1) {
            /* 最后一个参数：
             1. 0表示阻塞。
             2. MSG_WAITALL 表示数据满了才不阻塞。
             */
            size_t result = recv(fd, buf, 32, 0);
//            NSLog(@"result: %zu", result);
            if (result <= 0) {
                NSLog(@"接收失败！");
                close(fd);
                break;
            }
            /* C 语言最后一位为0表示结束 */
            buf[result] = 0;
//            NSLog(@"buf: %s", buf);
            const char *cs = buf;
            [NSThread performOnThread:[NSThread mainThread] withBlock:^{
                if (reciveBlock) {
                    NSString *str = [[NSString alloc] initWithCString:cs encoding:(NSUTF8StringEncoding)];
                    reciveBlock(str, str.length);
                }
            }];
        }
        close(fd);
    }];
    
}

- (void)threadSendData:(NSString *)content {
    const char *conC = content.UTF8String;
    /* 最后一个参数,发送方式,一般是0 */
    size_t result = send(fd, conC, strlen(conC), 0);
    if (result == -1) {
        NSLog(@"发送失败!");
    } else {
        NSLog(@"发送成功");
    }
}



@end
