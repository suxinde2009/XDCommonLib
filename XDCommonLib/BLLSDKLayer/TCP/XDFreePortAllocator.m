//
//  XDFreePortAllocator.m
//  XDCommonLib
//
//  Created by suxinde on 16/9/19.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import "XDFreePortAllocator.h"
#import <arpa/inet.h>

@interface XDFreePortAllocator ()

@property (nonatomic, assign) NSInteger lastPort;

@end

@implementation XDFreePortAllocator

+ (instancetype)sharedInstance {
    static XDFreePortAllocator *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[XDFreePortAllocator alloc] init];
        __sharedInstance.lastPort = 0;
    });
    return __sharedInstance;
}

- (NSInteger)allocatePort:(NSError **)error {
    self.lastPort = freePort();
    if (self.lastPort == -1) {
        if (error) {
            *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Socket error when allocating TCP Port"}];
        }
        return 0;
    }
    if (self.lastPort == -2) {
        if (error) {
            *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:-2 userInfo:@{NSLocalizedDescriptionKey: @"Port already in use: EADDRINUSE"}];
        }
        return 0;
    }
    if (self.lastPort == -3) {
        if (error) {
            *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:-3 userInfo:@{NSLocalizedDescriptionKey: @"Could not bind to process."}];
        }
        return 0;
    }
    if (self.lastPort == -4) {
        if (error) {
            *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:-4 userInfo:@{NSLocalizedDescriptionKey: @"Error: getsockname"}];
        }
        return 0;
    }
    return self.lastPort;
}

#pragma mark - Private C Methods
int freePort () {
    int port = 0;
    int fd = -1;
    int len = 0;
    port = -1;
    
#ifndef AF_IPV6
    struct sockaddr_in sin;
    memset(&sin, 0, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_port = htons(0);
    sin.sin_addr.s_addr = htonl(INADDR_ANY);
    
    fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    if(fd < 0){
        printf("socket() error:%s\n", strerror(errno));
        return -1;
    }
    
    // 设置套接字选项避免地址使用错误
    int on = 1;
    if((setsockopt(fd,SOL_SOCKET,SO_REUSEADDR,&on,sizeof(on)))<0)
    {
        perror("setsockopt failed");
        return -1;
    }
    
    if(bind(fd, (struct sockaddr *)&sin, sizeof(sin)) != 0)
    {
        printf("bind() error:%s\n", strerror(errno));
        close(fd);
        return -1;
    }
    
    len = sizeof(sin);
    if(getsockname(fd, (struct sockaddr *)&sin, &len) != 0)
    {
        printf("getsockname() error:%s\n", strerror(errno));
        close(fd);
        return -1;
    }
    
    port = sin.sin_port;
    if(fd != -1) {
        close(fd);
    }
    
#else
    struct sockaddr_in6 sin6;
    memset(&sin6, 0, sizeof(sin6));
    sin.sin_family = AF_INET6;
    sin.sin_port = htons(0);
    sin6.sin_addr.s_addr = htonl(IN6ADDR_ANY);
    
    fd = socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);
    
    if(fd < 0){
        printf("socket() error:%s\n", strerror(errno));
        return -1;
    }
    
    if(bind(fd, (struct sockaddr *)&sin6, sizeof(sin6)) != 0)
    {
        printf("bind() error:%s\n", strerror(errno));
        close(fd);
        return -1;
    }
    
    len = sizeof(sin6);
    if(getsockname(fd, (struct sockaddr *)&sin6, &len) != 0)
    {
        printf("getsockname() error:%s\n", strerror(errno));
        close(fd);
        return -1;
    }
    
    port = sin6.sin6_port;
    
    if(fd != -1)
        close(fd);
    
#endif
    return port;

}


@end
