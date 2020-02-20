//
//  ChatS.m
//  TestProject
//
//  Created by chen on 6/23/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "ChatS.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/_select.h>
#include <sys/select.h>

static int serverfd;
/* 容器，相当于一个数组，存放着所有的套接字，一个客户端连上S就为其创建一个套接字文件，2个就创建2个。都放在这个容器里面。 */
static fd_set allfd;
/* fd1和fd2有变化的时候，可以用select函数监听到变化，把变化放到个容器里。 */
static fd_set changefds;
/* allfd 中最大的值 */
static int maxfd = -1;
/* 变化中的最大值 */
@implementation ChatS
- (void)buildServer {
    /* fd是一个文件描述符,是一个文件句柄?怎么理解, 套接字就是个文件 */
    serverfd = socket(AF_INET, SOCK_STREAM, 0);
    if (serverfd == -1) {
        NSLog(@"创建失败!");
        return;
    }
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr("192.168.0.100");// 为什么要换，不能用本地回环地址吗？
    addr.sin_port = htons(62615);
    // 2. bind
    __block int r = bind(serverfd, (struct sockaddr *)&addr, sizeof(addr));
    if (r == -1) {
        NSLog(@"绑定失败");
        return;
    } else {
        NSLog(@"绑定成功！");
    }
    
    // 3.监听
    /* 一次能处理的任务数，最大监听数为20个，超过20就会被拒绝 */
    r = listen(serverfd, 20);
    if (r == -1) {
        NSLog(@"监听失败");
        
        return;
    } else {
        NSLog(@"监听成功");
    }
    [NSThread detachNewThreadWithBlock:^{
        while (1) {
            // 置空
            FD_ZERO(&changefds);
            // 第一次的时候，当我们创建服务端时，本地只有 serverfd 这么一个套接字
            FD_SET(serverfd,&changefds); // 添加服务端 fd 到 changefds 里面
            maxfd = maxfd<serverfd?serverfd:maxfd;
            for (int i = 0; i <= maxfd; i++) {
                if (FD_ISSET(i, &allfd)) {
                    FD_SET(i,&changefds); // 添加客户端 fd 到 changefds 里面
                    maxfd = maxfd<i?i:maxfd;
                }
            }
            /*
             阻塞, select, 轮询套接字的状态
             当客户端有响应的时候（发消息或者建立连接），阻塞就解除
             有变化的 fd 就保留在 changefds 中,其余的从 changefds 移除。
             
             */
            r = select(maxfd + 1, &changefds,0,0,0);
            NSLog(@"套接字状态有变化！");
            
            /** 如果serverfd还存在 changefds 容器里，说明serverfd有状态，这个状态代表有客户端套接字连接了  */
            if (FD_ISSET(serverfd, &changefds)) {
                NSLog(@"有人来连接了");
                // 接受连接（会给客户端生成一个对应的套接字 fd）
                int fd = accept(serverfd, 0, 0);
                if (fd == -1) {
                    NSLog(@"连接失败");
                    break;
                }
                maxfd = maxfd < fd ? fd : maxfd;
                FD_SET(fd, &allfd);
            }
            
            // 处理客户端的事情，没有提供直接读取 fd_set changefds 容器里的内容
            char buf[256];
            for (int i = 0; i <= maxfd; i++) {
                if (FD_ISSET(i, &changefds) && FD_ISSET(i, &allfd)) {
                    r = (int)recv(i, buf, 255, 0);
                    if (r <= 0) {
                        NSLog(@"有人退出了");
                        // 把这个套接字从 allfd 中移除
                        FD_CLR(i, &allfd);
                        break;
                    }
                    buf[r] = 0;
                    NSLog(@"来自客户端的数据：%s", buf);
                }
            }
        }
        close(serverfd);
    }];
    
}

- (void)close {
    close(serverfd);
}

- (void)sendS:(NSString *)content {
    [NSThread detachNewThreadWithBlock:^{
        [self threadSendData:content];
    }];
}

- (void)reciveData {
    char buf[32];
    while (1) {
        /* 最后一个参数：
         1. 0表示阻塞。
         2. MSG_WAITALL 表示数据满了才不阻塞。
         */
        size_t result = recv(serverfd, buf, 32, MSG_WAITALL);
        NSLog(@"result: %zu", result);
        if (result <= 0) {
            NSLog(@"接收失败！");
            close(serverfd);
            break;
        }
        /* C 语言最后一位为0表示结束 */
        buf[result] = 0;
        NSLog(@"buf: %s", buf);
    }
    close(serverfd);
}

- (void)threadSendData:(NSString *)content {
    // 广播数据 （对每一个连接上的客户端发送数据）
    char buf[32];
    sprintf(buf, "%s", @"来自服务端".UTF8String);
    for (int j = 0; j <= maxfd; j++) {
        if (FD_ISSET(j, &allfd)) {
            NSLog(@"向客户端发送数据: %s", buf);
            __unused int r = (int)send(j, buf, strlen(buf), 0);
        }
    }
}
@end
