//
//  LJPageConfiguration.h
//  SegmentView
//
//  Created by liang on 2017/10/30.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJPageConfiguration : NSObject
@property (nonatomic, assign) CGFloat titleViewHeight;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat titleWidth;
+ (instancetype)defaultConfiguration;
@end
