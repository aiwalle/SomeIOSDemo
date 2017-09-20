//
//  main.cpp
//  SocketServer
//
//  Created by liang on 2017/9/20.
//  Copyright © 2017年 walle. All rights reserved.
//

#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(int argc, const char * argv[]) {
    // 创建socket
    int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serv_addr.sin_port = htons(1234);
    bind(serv_sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
    
    listen(serv_sock, 20);
    
    struct sockaddr_in cInt_addr;
    socklen_t cInt_addr_size = sizeof(cInt_addr);
    int cInt_socket = accept(serv_sock, (struct sockaddr *)&cInt_addr, &cInt_addr_size);
    
    char str[] = "Hello World!";
    write(cInt_socket, str, sizeof(str));
    
    close(cInt_socket);
    close(serv_sock);
    printf("启动成功");
    
//    std::cout << "Hello, World!\n";
    return 0;
}
