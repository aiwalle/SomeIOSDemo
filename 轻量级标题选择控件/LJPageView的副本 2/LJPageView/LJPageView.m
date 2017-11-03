//
//  LJPageView.m
//  LJPageView
//
//  Created by liang on 2017/11/1.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "LJPageView.h"
#import "LJTitleView.h"
#import "LJPageContentView.h"
#import "LJTestController.h"
#import "LJModel.h"
#import "LJTestTitleView.h"
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth  [UIScreen mainScreen].bounds.size.width
@interface LJPageView()
@property (nonatomic, strong) LJTitleView *titleView;
@property (nonatomic, strong) LJPageView *pageContentView;
@end

@implementation LJPageView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
//    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
//    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
//    NSArray *arr = @[@"营养保健", @"母婴用品", @"美妆护理", @"日用百货", @"嘻嘻哈哈", @"什么东西", @"测试标题"];
//    LJTitleView *titleView = [[LJTitleView alloc] initWithFrame:CGRectMake(0, 100, screenW, 100)];
//    [titleView configWithTitles:arr];
//    [self addSubview:titleView];
    
    
    
    
    
    
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    LJTitleView *titleView = [[LJTitleView alloc] initWithFrame:CGRectMake(0, 100, screenW, 150)];
    titleView.backgroundColor = [UIColor greenColor];
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i =0; i < 6; i++) {
        LJModel *model = [LJModel new];
        model.iconStr = @"wallelj";
        model.name = @"hahaha";
        [muArr addObject:model];
        
    }
    [titleView configWithModels:muArr customViewClass:[LJTestTitleView class] viewSize:CGSizeMake(70, 100)];
    [self addSubview:titleView];
    
    
    
    
    
    
    NSMutableArray *chids = [NSMutableArray array];
    for (int i =0; i < muArr.count; i++) {
        LJTestController *test = [LJTestController new];
        [chids addObject:test];
    }
    LJPageContentView *contentView = [[LJPageContentView alloc] initWithFrame:CGRectMake(0, 250, screenW, screenH - 100)];
    [self addSubview:contentView];
    [contentView addChildVcs:chids parentVc:self.parVc];
    
    
    
    titleView.delegate = (id<LJTitleViewDelegate>)contentView;
    contentView.delegate = (id<LJPageContentViewDelegate>)titleView;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupSubviews];
}

- (void)customTitleView {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    LJTitleView *titleView = [[LJTitleView alloc] initWithFrame:CGRectMake(0, 100, screenW, 100)];
    titleView.backgroundColor = [UIColor greenColor];
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i =0; i < 6; i++) {
        LJModel *model = [LJModel new];
        model.iconStr = @"wallelj";
        model.name = @"hahha";
        [muArr addObject:model];
        
    }
    [titleView configWithModels:muArr customViewClass:[LJTestTitleView class] viewSize:CGSizeMake(70, 100)];
    [self addSubview:titleView];
}

@end
