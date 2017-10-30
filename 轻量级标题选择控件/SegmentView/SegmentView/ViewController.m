//
//  ViewController.m
//  SegmentView
//
//  Created by liang on 2017/10/30.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "ViewController.h"
#import "LJPageView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    NSArray *arr = @[@"营养保健", @"母婴用品", @"美妆护理", @"日用百货", @"嘻嘻哈哈", @"什么东西", @"测试标题"];
    LJPageView *pageView = [[LJPageView alloc] initWithFrame:CGRectMake(0, 100, screenW, 40)];
    [pageView configWithTitles:arr];
    [self.view addSubview:pageView];
}


@end
