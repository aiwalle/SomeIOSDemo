//
//  HYPageView.h
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYPageConfiguration;
@interface HYPageView : UIView
/** 配置对象，具体可以看里面的内容*/
@property (nonatomic, strong) HYPageConfiguration *config;

/**
 设置PageView的展示内容（自定义标题视图）

 @param models 标题视图对应的Model集合
 @param class 标题视图的类
 @param size 标题视图的尺寸
 @param childVcs 子控制器集合
 @param parent 父控制器
 */
- (void)setupWithTitleModels:(NSArray *)models titleViewClass:(Class)class titleViewSize:(CGSize)size childVcs:(NSArray *)childVcs parentVC:(UIViewController *)parent;


/**
 设置PageView的展示内容（UILabel标题视图）

 @param titles 标题字符串集合
 @param childVcs 子控制器集合
 @param parent 父控制器
 */
- (void)setupWithTitles:(NSArray *)titles childVcs:(NSArray *)childVcs parentVC:(UIViewController *)parent;
@end
