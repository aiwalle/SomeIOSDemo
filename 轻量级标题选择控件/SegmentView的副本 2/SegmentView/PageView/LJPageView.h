//
//  LJPageView.h
//  SegmentView
//
//  Created by liang on 2017/10/30.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LJPageConfiguration;

@protocol adjustTitleViewProtocol <NSObject>
@required
/** 如果使用自定义标题视图，那么这两个方法用来适配对应视图的样式*/
- (void)adjustTitleViewAppearanceWithOrigin;
- (void)adjustTitleViewAppearanceWithTarget;
@end

@interface LJPageView : UIView
@property (nonatomic, strong) LJPageConfiguration *configuration;

/**
 一般情况下的标题视图

 @param titles 标题数组
 */
- (void)configWithTitles:(NSArray *)titles;

/**
 自定义的标题视图和模型

 @param model 模型数组
 @param class 视图的类(这里暂时只支持纯代码实现的视图)
 @param size 视图的尺寸
 */
- (void)configWithModels:(NSArray *)model customViewClass:(Class)class viewSize:(CGSize)size;
@end
