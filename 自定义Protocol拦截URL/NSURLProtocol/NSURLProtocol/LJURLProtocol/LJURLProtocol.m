//
//  LJURLProtocol.m
//  NSURLProtocol
//
//  Created by liang on 2017/9/14.
//  Copyright © 2017年 walle. All rights reserved.
//

#import "LJURLProtocol.h"

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface LJURLProtocol()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLResponse *urlResponse;
@property (nonatomic, strong) NSMutableData *receivedData;
@end

@implementation LJURLProtocol
// 这个方法询问是否需要自己来处理请求
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    // 获取对应请求协议头
    NSString *scheme = request.URL.scheme;
    // 如果是http或者https的请求才进行处理
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        // 给请求设定了一个对应的key/value，如果有值，说明该请求已经被处理过，返回NO，使用系统默认的方式进行处理
        if ([self propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        // 如果没值，说明没有被我们自定义处理过，返回YES来自己处理
        return YES;
    }
    return NO;
}

// 这个方法来修改request，上面返回YES的请求会走到这个方法
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    mutableRequest = [self redirectHostInRequset:mutableRequest];
    return mutableRequest;
}

+ (NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request {
    // 如果请求根地址为空，直接返回请求不处理
    if (request.URL.host.length == 0) {
        return request;
    }
    // 获取请求地址和主域名
    NSString *originURLString = request.URL.absoluteString;
    NSString *originHostString = request.URL.host;
    NSRange hostRange = [originURLString rangeOfString:originHostString];
    if (hostRange.location == NSNotFound) {
        return request;
    }
    
    if ([originURLString rangeOfString:@"56.com"].location != NSNotFound) {
        return request;
    }
    
    // 替换请求地址
    NSString *ip = @"cn.bing.com";
    NSString *urlStr = [originURLString stringByReplacingCharactersInRange:hostRange withString:ip];
    NSURL *url = [NSURL URLWithString:urlStr];
    request.URL = url;
    return request;
}

// 询问缓存情况
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

/*
 0x6000000526f0  第一次加载web
 protocol 的内存地址
 
 0x60800024d140 第二次请求数据
 protocol 的内存地址
 
 由此可得 这个protocol 不是一个单例对象
 
 当加载多个资源的时候，会多开线程
 */

// 开始下载，在这里我们要开始数据的任务
- (void)startLoading {
    NSMutableURLRequest *request = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:request];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSLog(@"threadstartLoading--%@", [NSThread currentThread]);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    self.dataTask = [session dataTaskWithRequest:request];
    [self.dataTask resume];
}

- (void)stopLoading {
    [self.dataTask cancel];
    self.dataTask = nil;
    self.receivedData = nil;
    self.urlResponse = nil;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.urlResponse = response;
    self.receivedData = [NSMutableData data];
    completionHandler(NSURLSessionResponseAllow);
    
    NSLog(@"threadcompletionHandler--%@", [NSThread currentThread]);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [self.receivedData appendData:data];
    NSLog(@"threaddidReceiveData--%@", [NSThread currentThread]);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error != nil) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

@end
