//
//  ChatUDP.m
//  OCProject
//
//  Created by chen on 6/23/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "ChatUDP.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

static int fd;
static struct sockaddr_in addr;
@implementation ChatUDP
/**
 IM 会结合 UDP，TCP 太占资源，聊天一般是用 UDP 实现的。
 发送数据的时候 TCP 有状态，知道对面是否接受到了数据，底层就是当收到信息的时候，服务器返回一个信息就是。
 用 UDP 手动实现服务器返回这一步吗，就可靠了。
 面试点：长链接短链接&长轮询和短轮询 ？
 */


- (void)buildClient {
    /* fd是一个文件描述符,是一个文件句柄?怎么理解, 套接字就是个文件 */
    fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd == -1) {
        NSLog(@"创建失败!");
    }
    
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr("172.17.1.105");
    addr.sin_port = htons(9878);
    
    /* 终端 nc -l 9878 可以收到 data */
    // nc -ul 9878
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
            socklen_t size = sizeof(addr);
            size_t result = recvfrom(fd, buf, 32, 0, (struct sockaddr *)&addr, &size);

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
    }];
    
}

- (void)threadSendData:(NSString *)content {
    const char *conC = content.UTF8String;
    /* 最后一个参数,发送方式,一般是0 */
    /** 没有连接，直接指定 ip 地址和端口发送 */
    __unused size_t result = sendto(fd, conC, strlen(conC), 0, (struct sockaddr *)&addr, sizeof(addr));
    /** 这里没有什么发送失不失败问题, result 只是发送多少字节，不代表成功了*/
}
@end
