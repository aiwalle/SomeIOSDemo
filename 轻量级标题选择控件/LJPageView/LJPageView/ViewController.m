//
//  ViewController.m
//  LJPageView
//
//  Created by liang on 2017/11/1.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "ViewController.h"
#import "LJTitleView.h"
#import "LJPageView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self onlyTextLabel];
    [self page];
}


- (void)onlyTextLabel {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    NSArray *arr = @[@"营养保健", @"母婴用品", @"美妆护理", @"日用百货", @"嘻嘻哈哈", @"什么东西", @"测试标题"];
    LJTitleView *titleView = [[LJTitleView alloc] initWithFrame:CGRectMake(0, 100, screenW, 100)];
//    LJPageConfiguration *config = [LJPageConfiguration new];
//    config.titleViewHeight = 35;
//    config.titleFont = [UIFont systemFontOfSize:20];
//    config.selectedColor = [UIColor purpleColor];
//    config.normalColor = [UIColor blueColor];
//    config.showBottomLine = YES;
//    config.margin = 40;
//    config.titleWidth = 120;
//    pageView.configuration = config;
    
    [titleView configWithTitles:arr];
    [self.view addSubview:titleView];
}

- (void)page {
    LJPageView *Page = [[LJPageView alloc] initWithFrame:self.view.bounds];
    Page.parVc = self;
    [self.view addSubview:Page];
}

@end
