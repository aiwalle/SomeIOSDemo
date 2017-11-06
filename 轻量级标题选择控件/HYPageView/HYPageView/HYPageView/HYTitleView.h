//
//  HYTitleView.h
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPageConfiguration.h"
@class HYTitleView;

@protocol HYTitleViewDelegate <NSObject>

- (void)titleView:(HYTitleView *)titleView currentIndex:(NSInteger)index;
@end

@protocol AdjustTitleViewProtocol <NSObject>
@required
- (void)adjustTitleViewAppearanceWithScale:(CGFloat)scale;
@end

@interface HYTitleView : UIView
@property (nonatomic, strong) HYPageConfiguration *configuration;
@property (nonatomic, weak) id<HYTitleViewDelegate> delegate;
- (void)configWithTitles:(NSArray *)titles;
- (void)configWithModels:(NSArray *)models customViewClass:(Class)class viewSize:(CGSize)size;
@end
