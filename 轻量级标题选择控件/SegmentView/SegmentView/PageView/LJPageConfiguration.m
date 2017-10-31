//
//  LJPageConfiguration.m
//  SegmentView
//
//  Created by liang on 2017/10/30.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "LJPageConfiguration.h"

@implementation LJPageConfiguration
- (instancetype)init {
    self = [super init];
    if (self) {
        _titleViewHeight = 44.0;
        _titleWidth = [UIScreen mainScreen].bounds.size.width / 4;
        _titleFont = [UIFont systemFontOfSize:14.0];
        _selectedColor = [UIColor redColor];
        _normalColor = [UIColor darkGrayColor];
        _showBottomLine = YES;
        _margin = 0.0;
        
    }
    return self;
}
/*
 @property (nonatomic, assign) CGFloat titleViewHeight;
 @property (nonatomic, strong) UIFont *titleFont;
 @property (nonatomic, strong) UIColor *selectedColor;
 @property (nonatomic, strong) UIColor *normalColor;
 @property (nonatomic, strong) UIView *customView;
 @property (nonatomic, assign) BOOL showBottomLine;
 @property (nonatomic, assign) CGFloat margin;
 @property (nonatomic, assign) CGFloat titleWidth;
 */

+ (instancetype)defaultConfiguration {
    return [[LJPageConfiguration alloc] init];
}
@end
