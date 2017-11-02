//
//  LJTitleView.h
//  LJPageView
//
//  Created by liang on 2017/11/1.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJPageContentView.h"
@class LJTitleView;

@protocol LJTitleViewDelegate <NSObject>

- (void)titleView:(LJTitleView *)titleView currentIndex:(NSInteger)index;
@end

@protocol adjustTitleViewProtocol <NSObject>
@required
/** 如果使用自定义标题视图，那么这两个方法用来适配对应视图的样式*/
- (void)adjustTitleViewAppearanceWithOrigin;
- (void)adjustTitleViewAppearanceWithTarget;
@end

@interface LJTitleView : UIView 
@property (nonatomic, weak) id<LJTitleViewDelegate> delegate;
- (void)configWithTitles:(NSArray *)titles;
- (void)configWithModels:(NSArray *)models customViewClass:(Class)class viewSize:(CGSize)size;
@end
