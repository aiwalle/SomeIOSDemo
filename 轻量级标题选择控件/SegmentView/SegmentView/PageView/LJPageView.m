//
//  LJPageView.m
//  SegmentView
//
//  Created by liang on 2017/10/30.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "LJPageView.h"
#import "LJPageConfiguration.h"
@interface LJPageView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titlesArr;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *selectedLabel;
@end

@implementation LJPageView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
//    _scrollView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_scrollView];
    
    _bottomLine = [UIView new];
//    _bottomLine.backgroundColor = [UIColor redColor];
    [self addSubview:_bottomLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
}

- (void)updateAllSetting {
    self.bottomLine.backgroundColor = self.configuration.selectedColor;
    for (UILabel *label in self.titlesArr) {
        label.font = self.configuration.titleFont;
        CGFloat labelH = label.font.lineHeight + 2;
        CGFloat labelY = (self.bounds.size.height - labelH) * 0.5;
        label.frame = CGRectMake(label.frame.origin.x, labelY, label.frame.size.width, labelH);
        label.textColor = label.tag == 0 ? self.configuration.selectedColor : self.configuration.normalColor;
        if (label.tag == 0) {
            self.bottomLine.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+2, label.frame.size.width, 2);
        }
        
    }
    self.bottomLine.hidden = !self.configuration.showBottomLine;
    
}

- (void)configWithTitles:(NSArray *)titles {
    if (titles.count <= 0) {
        return;
    }
    for (UILabel *label in self.subviews) {
        if ([[label class] isMemberOfClass:[UILabel class]]) {
            [label removeFromSuperview];
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
        label.backgroundColor = [UIColor blueColor];
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
            self.selectedLabel= label;
            self.bottomLine.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+2, label.frame.size.width, 2);
        }
    }
    
    if (titles.count > 4) {
        self.scrollView.contentSize = CGSizeMake(titles.count * labelW, self.bounds.size.height);
    }
}

- (void)titleLabelClick:(UITapGestureRecognizer *)tapGes {
    UILabel *label = (UILabel *)tapGes.view;
    
    self.selectedLabel.textColor = [UIColor blackColor];
    label.textColor = [UIColor redColor];
    self.selectedLabel = label;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat labelFrameX = self.selectedLabel.frame.origin.x - self.scrollView.contentOffset.x;
        self.bottomLine.frame = CGRectMake(labelFrameX, self.bottomLine.frame.origin.y, self.bottomLine.frame.size.width, self.bottomLine.frame.size.height);
    }];
    CGFloat offsetX = self.selectedLabel.frame.origin.x - self.scrollView.frame.size.width * 0.5 + self.selectedLabel.frame.size.width * 0.5;

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX >= self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
        return;
    }
    
    if (offsetX <= 0) {
        return;
    }

    CGRect rect = CGRectMake(self.selectedLabel.frame.origin.x - offsetX, self.bottomLine.frame.origin.y, self.bottomLine.frame.size.width, self.bottomLine.frame.size.height);
    self.bottomLine.frame = rect;
}


@end
