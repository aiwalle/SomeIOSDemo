//
//  HYPageConfiguration.h
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPageConfiguration : NSObject
#pragma mark - ****************通用配置
/** 是否显示底线*/
@property (nonatomic, assign) BOOL showBottomLine;
/** 底线颜色*/
@property (nonatomic, strong) UIColor *bottomLineColor;
/** 相邻的距离*/
@property (nonatomic, assign) CGFloat margin;
/** 底线宽度*/
@property (nonatomic, assign) CGFloat bottomLineWidth;
/** 底线高度*/
@property (nonatomic, assign) CGFloat bottomLineHeight;
/** 标题视图的高度*/
@property (nonatomic, assign) CGFloat titleViewHeight;
#pragma mark - ****************顶部为标题视图时的配置
/** 最大缩放比例*/
@property (nonatomic, assign) CGFloat maxScale;
/** 标题的字体*/
@property (nonatomic, strong) UIFont *titleFont;
/** 选中的颜色*/
@property (nonatomic, strong) UIColor *selectedColor;
/** 正常的颜色*/
@property (nonatomic, strong) UIColor *normalColor;
/** 标题的宽度*/
@property (nonatomic, assign) CGFloat titleWidth;


/** 使用默认配置*/
+ (instancetype)defaultConfiguration;
@end
