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
        _titleFont = [UIFont systemFontOfSize:14.0];
        _selectedColor = [UIColor redColor];
        _normalColor = [UIColor darkGrayColor];
        _showBottomLine = YES;
    }
    return self;
}

+ (instancetype)defaultConfiguration {
    return [[LJPageConfiguration alloc] init];
}
@end
