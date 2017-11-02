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
@property (nonatomic, strong) NSArray *childVcs;
@property (nonatomic, assign) BOOL isDrag;
@property (nonatomic, assign) BOOL isClick;
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
//        NSInteger index = [vcs indexOfObject:vc];
        [parentVc addChildViewController:vc];
//        [parentVc beginAppearanceTransition:YES animated:YES];
//        if (!index) {
//            vc.view.frame = CGRectMake(screenW * index, 0, screenW, self.bounds.size.height);
//            [self.contentScrollView addSubview:vc.view];
////            [vc didMoveToParentViewController:parentVc];
//        }

        self.contentScrollView.contentSize = CGSizeMake(screenW * vcs.count, self.bounds.size.height);
    }
    
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentWidth = scrollView.bounds.size.width;
    
    CGFloat offsetX = fmod(scrollView.contentOffset.x, contentWidth);
    if (!self.isClick) {
        if (offsetX > contentWidth / 4 && offsetX < contentWidth * 3 /4) {
            NSUInteger maxIndex = scrollView.contentSize.width / contentWidth - 1;
            NSUInteger index = 0;
            if (offsetX > contentWidth / 2) {
                index = scrollView.contentOffset.x /contentWidth;
            } else {
                index = scrollView.contentOffset.x /contentWidth + 1;
            }
            if (index > maxIndex) {
                index = maxIndex;
            }
            UIViewController *newVC = self.childVcs[index];
            if (!newVC.view.superview) {
                newVC.view.frame = CGRectMake(contentWidth * index, 0, scrollView.bounds.size.width, scrollView.bounds.size.height);
                [self.contentScrollView addSubview:newVC.view];
            };
        }
    }
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSInteger leftIndex = (NSInteger)value;
    NSInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    
    
    if ([self.delegate respondsToSelector:@selector(updateIndexSubView:scale:)]) {
        [self.delegate updateIndexSubView:leftIndex scale:scaleLeft];
    }
    
    if (!leftIndex && scrollView.contentOffset.x <= 0) {
        return;
    }
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.childVcs.count) {
        if ([self.delegate respondsToSelector:@selector(updateIndexSubView:scale:)]) {
            [self.delegate updateIndexSubView:rightIndex scale:scaleRight];
        }
        
        CGFloat offsetScale = offsetX / contentWidth;
        if ([self.delegate respondsToSelector:@selector(updateBottomLineWithOffsetScale:leftIndex:rightIndex:offsetX:)]) {
            [self.delegate updateBottomLineWithOffsetScale:offsetScale leftIndex:leftIndex rightIndex:rightIndex offsetX:offsetX];
        }
        
    }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat contentWidth = scrollView.bounds.size.width;
    NSInteger index = scrollView.contentOffset.x / contentWidth;
    if (index <= 0) {
        index = 0;
    }
    
    if ([self.delegate respondsToSelector:@selector(updateTitleScrollviewWithIndex:)]) {
        [self.delegate updateTitleScrollviewWithIndex:index];
    }
    
    UIViewController *newVC = self.childVcs[index];
    self.isClick = NO;
    if (newVC.view.superview) return;
    newVC.view.frame = scrollView.bounds;
    [self.contentScrollView addSubview:newVC.view];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    self.isClick = NO;
}

#pragma mark - ****************LJTitleViewDelegate
- (void)titleView:(LJTitleView *)titleView currentIndex:(NSInteger)index {
    self.isClick = YES;
    
    CGFloat offsetX = index * DeviceWidth;
    CGFloat offsetY = _contentScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [_contentScrollView setContentOffset:offset animated:YES];
}

@end
