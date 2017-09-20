//
//  main.cpp
//  SocketClient
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
    
    
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serv_addr.sin_port = htons(1234);
    connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
    
    char buffer[40];
    read(sock, buffer, sizeof(buffer)-1);
    printf("Message form server: %s\n", buffer);
    close(sock);
    
    
    
    
    
//    std::cout << "Hello, World!\n";
    return 0;
}
