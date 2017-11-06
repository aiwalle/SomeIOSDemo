//
//  HYPageConfiguration.m
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "HYPageConfiguration.h"

@implementation HYPageConfiguration
- (instancetype)init {
    self = [super init];
    if (self) {
        _titleViewHeight = 44.0;
        _titleWidth = [UIScreen mainScreen].bounds.size.width / 4;
        _titleFont = [UIFont systemFontOfSize:14.0];
        _selectedColor = [UIColor redColor];
        _normalColor = [UIColor blueColor];
        _showBottomLine = YES;
        _margin = 20.0;
        _bottomLineColor = [UIColor redColor];
        _maxScale = 1.2;
        _bottomLineWidth = 60;
        _bottomLineHeight = 2;
    }
    return self;
}

+ (instancetype)defaultConfiguration {
    return [[HYPageConfiguration alloc] init];
}
@end
