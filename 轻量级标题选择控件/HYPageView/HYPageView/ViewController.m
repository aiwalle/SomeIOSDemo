//
//  ViewController.m
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "ViewController.h"
#import "HYPageView.h"
#import "TestViewController.h"
#import "HYTestModel.h"
#import "HYTestView.h"
#import "HYPageConfiguration.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testCustomView];
    
//    [self testOnlyLabel];
}

- (void)testOnlyLabel {
    HYPageConfiguration *config = [HYPageConfiguration new];
    config.bottomLineHeight = 4;
    config.titleWidth = 80;
    
    HYPageView *pageView = [[HYPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    pageView.config = config;
    
    [self.view addSubview:pageView];
    NSArray *arr = @[@"营养保健", @"母婴用品", @"美妆护理", @"日用百货"];
    NSMutableArray *chids = [NSMutableArray array];
    for (int i =0; i < arr.count; i++) {
        TestViewController *test = [TestViewController new];
        [chids addObject:test];
    }
    
    [pageView setupWithTitles:arr childVcs:chids parentVC:self];
}

- (void)testCustomView {
    HYPageConfiguration *config = [HYPageConfiguration new];
    config.bottomLineHeight = 4;
//    config.margin = 0;
    
    
    HYPageView *pageView = [[HYPageView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20)];
    pageView.config = config;
    [self.view addSubview:pageView];
    
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i =0; i < 6; i++) {
        HYTestModel *model = [HYTestModel new];
        model.iconStr = @"wallelj";
        model.name = @"hahaha";
        [muArr addObject:model];
        
    }
    
    NSMutableArray *chids = [NSMutableArray array];
    for (int i =0; i < muArr.count; i++) {
        TestViewController *test = [TestViewController new];
        [chids addObject:test];
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    [pageView setupWithTitleModels:muArr titleViewClass:[HYTestView class] titleViewSize:CGSizeMake(width/muArr.count, 100) childVcs:chids parentVC:self];
}

@end
