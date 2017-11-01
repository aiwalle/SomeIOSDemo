//
//  LJTitleView.m
//  LJPageView
//
//  Created by liang on 2017/11/1.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "LJTitleView.h"
#import "UIView+YYAdd.h"
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth  [UIScreen mainScreen].bounds.size.width
@interface LJTitleView()<UIScrollViewDelegate, LJPageContentViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titlesArr;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *selectedView;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation LJTitleView
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
    _titlesArr = [NSMutableArray array];
    _currentIndex = 0;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollView];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor redColor];
    [self addSubview:_bottomLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
}

- (void)configWithTitles:(NSArray *)titles {
    if (titles.count <= 0) {
        return;
    }
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }
    }
    
    for (int i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
        UILabel *label = [UILabel new];
        label.text = title;
        label.tag = i;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = i == 0 ? [UIColor redColor] : [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.userInteractionEnabled = YES;
        [self.scrollView addSubview:label];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tapGes];
        [self.titlesArr addObject:label];
    }
    
    CGFloat labelW = self.bounds.size.width / 4;
    for (UILabel *label in self.titlesArr) {
        NSInteger index = [self.titlesArr indexOfObject:label];
        CGFloat labelH = label.font.lineHeight + 2;
        CGFloat labelY = (self.bounds.size.height - labelH) * 0.5;
        label.frame = CGRectMake(labelW * index, labelY, labelW, labelH);
        
        if (index == 0) {
            self.selectedView = label;
            self.bottomLine.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+2, label.frame.size.width, 2);
//            self.selectedView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }
    }
    
    if (titles.count > 4) {
        self.scrollView.contentSize = CGSizeMake(titles.count * labelW, self.bounds.size.height);
    }
    
//    [self updateAllTitleLabelSetting];
}
    
- (void)titleLabelClick:(UITapGestureRecognizer *)tapGes {
    if (![tapGes.view isKindOfClass:[UILabel class]]) {
        return;
    }
    if (tapGes.view.tag == self.currentIndex) {
        return;
    }
    
    
    UILabel *label = (UILabel *)tapGes.view;
//    UILabel *originLabel = (UILabel *)self.selectedView;
//    originLabel.transform = CGAffineTransformIdentity;
//    originLabel.textColor = [UIColor blackColor];
//    label.textColor = [UIColor redColor];
    self.selectedView = label;
    self.currentIndex = label.tag;
    
    if ([self.delegate respondsToSelector:@selector(titleView:currentIndex:)]) {
        [self.delegate titleView:self currentIndex:self.currentIndex];
    }
    
    // 这里是快速偏移
    [UIView animateWithDuration:0.25 animations:^{
//        self.selectedView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        CGFloat labelFrameX = self.selectedView.frame.origin.x - self.scrollView.contentOffset.x;
        self.bottomLine.frame = CGRectMake(labelFrameX, self.bottomLine.frame.origin.y, self.bottomLine.frame.size.width, self.bottomLine.frame.size.height);
    }];
    
    CGFloat offsetX = self.selectedView.frame.origin.x - self.scrollView.frame.size.width * 0.5 + self.selectedView.frame.size.width * 0.5;

    if (offsetX > 0) {
        if (offsetX >= (self.scrollView.contentSize.width - self.scrollView.frame.size.width)) {
            offsetX = (self.scrollView.contentSize.width - self.scrollView.frame.size.width);
        }
        CGPoint point = CGPointMake(offsetX, 0);
        [self.scrollView setContentOffset:point animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - ****************UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX >= self.scrollView.contentSize.width - self.scrollView.frame.size.width || offsetX <= 0) {
        return;
    }
    
    CGRect rect = CGRectMake(self.selectedView.frame.origin.x - offsetX, self.bottomLine.frame.origin.y, self.bottomLine.frame.size.width, self.bottomLine.frame.size.height);
    self.bottomLine.frame = rect;
}




#pragma mark - ****************LJPageContentViewDelegate
- (void)contentView:(LJPageContentView *)contentView sourceIndex:(NSInteger)source targetIndex:(NSInteger)target progress:(CGFloat)progress {
    UILabel *sourceLabel = self.titlesArr[source];
    UILabel *targetLabel = self.titlesArr[target];
    NSLog(@"progress==%f", progress);
    
    NSLog(@"sour==%ld, target==%ld", sourceLabel.tag, targetLabel.tag);
    if (targetLabel == sourceLabel || progress <= 0) {
        return;
    }
    
    targetLabel.textColor = [UIColor colorWithRed:progress green:0 blue:0 alpha:1];
    
    CGFloat nextPro = 1-progress;
    sourceLabel.textColor = [UIColor colorWithRed:nextPro green:0 blue:0 alpha:1];
    
}


@end
