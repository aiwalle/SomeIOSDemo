//
//  LJPageContentView.m
//  LJPageView
//
//  Created by liang on 2017/11/1.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "LJPageContentView.h"
//#import "LJTitleView.h"
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth  [UIScreen mainScreen].bounds.size.width
@interface LJPageContentView()<UIScrollViewDelegate, LJTitleViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, strong) NSArray *childVcs;
@end

@implementation LJPageContentView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder  {
    
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _startOffsetX = 0;
    
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.bounces = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_contentScrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentScrollView.frame = self.bounds;
}

- (void)addChildVcs:(NSArray *)vcs parentVc:(UIViewController *)parentVc {
    self.childVcs = vcs;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    for (UIViewController *vc in vcs) {
        // 不添加view就不会调用viewdidload
        NSInteger index = [vcs indexOfObject:vc];
        [parentVc addChildViewController:vc];
        vc.view.frame = CGRectMake(screenW * index, 0, screenW, self.bounds.size.height);
        [_contentScrollView addSubview:vc.view];
        _contentScrollView.contentSize = CGSizeMake(screenW * vcs.count, self.bounds.size.height);
    }
}

- (void)titleView:(LJTitleView *)titleView currentIndex:(NSInteger)index {
    CGFloat offsetX = index * DeviceWidth;
    CGFloat offsetY = _contentScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [_contentScrollView setContentOffset:offset animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    CGFloat progress = 0;
    CGFloat contentWidth = self.contentScrollView.bounds.size.width;
    
    if (offsetX > self.startOffsetX) {
//        NSLog(@"1111offset====%f", offsetX);
//        NSLog(@"1111startset===%f", self.startOffsetX);
//        sourceIndex = (offsetX - 2.0) / contentWidth;
        sourceIndex = offsetX / contentWidth;
        
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childVcs.count) {
            targetIndex = self.childVcs.count - 1;
        }
        
        progress = (offsetX - self.startOffsetX) / contentWidth;
        if ((offsetX - self.startOffsetX) == contentWidth ) {
            targetIndex = sourceIndex;
        }
        
    } else {
//        NSLog(@"2222offset====%f", offsetX);
//        NSLog(@"2222startset===%f", self.startOffsetX);
        
        targetIndex = offsetX / contentWidth;
        sourceIndex = targetIndex + 1;
        progress = (self.startOffsetX - offsetX) / contentWidth;
    }
    
    if ([self.delegate respondsToSelector:@selector(contentView:sourceIndex:targetIndex:progress:)]) {
        [self.delegate contentView:self sourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.startOffsetX = scrollView.contentOffset.x;
}

@end
