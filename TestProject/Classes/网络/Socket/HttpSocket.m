//
//  HttpEOC.m
//  Chats
//
//  Created by EOC on 2017/6/4.
//  Copyright © 2017年 sunyong. All rights reserved.
//

#import "HttpSocket.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@implementation HttpSocket


+ (void)netLoadBlock
{
    NSURL *url = [NSURL URLWithString:URLPath];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    NSString *bodyStr = @"versions_id=1&system_type=1";
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        
        if (error) {
            NSLog(@"%@", error);
        }  else {
            NSDictionary *infoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@", infoDict);
        }
    }];
    
    [task resume];
}

+ (void)startHttpPost{//这个是用socket来发起表单请求
    
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd == -1) {
        printf("socket fail");
        return ;
    }
    // 1.2.连接服务器
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(80); // 端口
    addr.sin_addr.s_addr = inet_addr("121.41.96.64");
    
    
    int r =  connect(fd,  (struct sockaddr *)&addr, sizeof(addr));
    if (r == -1) {
        printf("connect fail\n");
        return ;
    }else{
        printf("connect ok\n");
    }
    
    /*
     http
     一 方法名，请求内容，http协议版本 /r/n
     二 主机名 格式Host: 主机
     三 连接状态：Connection:  Close(短链接)/keep-alive（长链接）
     四 接收的数据类型 Accept:
     五 指定浏览器类型： User-Agent:
     
     六 表单
     Range：bytes = 起始位置 - 终止位置
     
     Accept: image/gif, image/jpeg,  application/
     */
    char buf[4096];
    bzero(buf, 4096);
    sprintf(buf,
            "POST /center/front/app/util/updateVersions HTTP/1.1\r\n"//地址:/center/front/app/util/updateVersions
            "Host: svr.tuliu.com\r\n"//请求的IP地址也就是域名
            "Accept: */*\r\n"
            "Accept-Language: cn\r\n"
            "User-Agent: Mozilla/5.0\r\n"
            /** 更改这个参数可以决定长连接，下面这个断开了会后打印 */
            "Connection: Close\r\n"
            "Content-Type: application/x-www-form-urlencoded\r\n"
            "Content-Length: 27\r\n"
            "\r\n" // 请求头和请求体之间的分隔符
            "versions_id=1&system_type=1"//参数
            "\r\n");
    
    
//    strcat(buf, "POST /center/front/app/util/updateVersions HTTP/1.1\r\n");
//    strcat(buf, "Host: svr.tuliu.com\r\n");
    
    // 发送
    r =  (int)send(fd, buf, strlen(buf), 0);
    if (r < 0) {
        NSLog(@"send error");
    }
    NSLog(@"send success");
    
    // 接收
    char recvbuf [4096];
    while (1) {
        
        bzero(recvbuf, 4096);
        ssize_t lenght = recv(fd, recvbuf, 4096, 0);
        if (lenght <= 0) {
            
            NSLog(@"断开了：length:%d", (int)lenght);
            break;
            
        }
        recvbuf[lenght] = 0;
        
        NSLog(@"=====================");
        NSLog(@"%@", [[NSString alloc] initWithCString:recvbuf encoding:NSUTF8StringEncoding]);// abcd0dgege
        NSLog(@"=====================");
    }
}


@end
