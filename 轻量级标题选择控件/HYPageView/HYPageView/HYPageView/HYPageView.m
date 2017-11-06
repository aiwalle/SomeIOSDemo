//
//  HYPageView.m
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "HYPageView.h"
#import "HYTitleView.h"
#import "HYPageContentView.h"
@interface HYPageView()
@property (nonatomic, strong) HYTitleView *titleView;
@property (nonatomic, strong) HYPageContentView *pageContentView;
@end

@implementation HYPageView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _titleView = [[HYTitleView alloc] init];
    [self addSubview:_titleView];
    
    _pageContentView = [[HYPageContentView alloc] init];
    [self addSubview:_pageContentView];
    
    _titleView.delegate = (id<HYTitleViewDelegate>)_pageContentView;
    _pageContentView.delegate = (id<HYPageContentViewDelegate>)_titleView;
    _titleView.frame = CGRectMake(0, 0, self.frame.size.width, 120);
    _pageContentView.frame = CGRectMake(0, 120, self.frame.size.width, self.frame.size.height - 120);
    
}

- (void)setupWithTitleModels:(NSArray *)models titleViewClass:(Class)class titleViewSize:(CGSize)size childVcs:(NSArray *)childVcs parentVC:(UIViewController *)parent{
    self.titleView.configuration = self.config;
    
    [self.titleView configWithModels:models customViewClass:class viewSize:size];
    
    [self.pageContentView addChildVcs:childVcs parentVc:parent];
    
}

- (void)setupWithTitles:(NSArray *)titles childVcs:(NSArray *)childVcs parentVC:(UIViewController *)parent {
    self.titleView.configuration = self.config;
    
    [self.titleView configWithTitles:titles];
    
    [self.pageContentView addChildVcs:childVcs parentVc:parent];
}

@end


