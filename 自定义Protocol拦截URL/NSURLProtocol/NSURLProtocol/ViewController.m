//
//  ViewController.m
//  NSURLProtocol
//
//  Created by liang on 2017/9/14.
//  Copyright © 2017年 walle. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *loadBtn;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionTask *task;
@end

@implementation ViewController
- (IBAction)loadBtnClick:(UIButton *)sender {
    NSURLRequest *request = nil;
    if (!self.textField.text.length) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        [self.webView loadRequest:request];
    } else {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.textField.text]];
    }
    
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(20, 300, 300, 200)];
    [self.view addSubview:web];
    [web loadRequest:request];
    
//    [self.webView loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
}


- (IBAction)downBtnClick:(UIButton *)sender {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://qf.56.com/home/v4/moreAnchor.ios?type=0&index=0&size=48"];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
   self.task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError* error) {
                                        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                    }];
    
    // 启动任务
    [self.task resume];
}




@end
