//
//  ViewController.m
//  SegmentView
//
//  Created by liang on 2017/10/30.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "ViewController.h"
#import "LJPageView.h"
#import "LJPageConfiguration.h"
#import "LJTestTitleView.h"
#import "LJModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [self onlyTextLabel];
    [self customTitleView];
}

- (void)onlyTextLabel {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    NSArray *arr = @[@"营养保健", @"母婴用品", @"美妆护理", @"日用百货", @"嘻嘻哈哈", @"什么东西", @"测试标题"];
    LJPageView *pageView = [[LJPageView alloc] initWithFrame:CGRectMake(0, 100, screenW, 100)];
    LJPageConfiguration *config = [LJPageConfiguration new];
    config.titleViewHeight = 35;
    config.titleFont = [UIFont systemFontOfSize:20];
    config.selectedColor = [UIColor purpleColor];
    config.normalColor = [UIColor blueColor];
    config.showBottomLine = YES;
    config.margin = 40;
    config.titleWidth = 120;
    pageView.configuration = config;
    
    [pageView configWithTitles:arr];
    [self.view addSubview:pageView];
}

- (void)customTitleView {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    LJPageView *pageView = [[LJPageView alloc] initWithFrame:CGRectMake(0, 100, screenW, 100)];
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i =0; i < 6; i++) {
        LJModel *model = [LJModel new];
        model.iconStr = @"123";
        model.name = @"hahhahaha";
        [muArr addObject:model];
        
    }
    [pageView configWithModels:muArr customViewClass:[LJTestTitleView class] viewSize:CGSizeMake(70, 100)];
    [self.view addSubview:pageView];
}

@end
