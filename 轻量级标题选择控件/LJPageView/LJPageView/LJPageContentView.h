//
//  LJPageContentView.h
//  LJPageView
//
//  Created by liang on 2017/11/1.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJTitleView.h"
@class LJPageContentView;
@protocol LJPageContentViewDelegate <NSObject>
- (void)contentView:(LJPageContentView *)contentView sourceIndex:(NSInteger)source targetIndex:(NSInteger)target progress:(CGFloat)progress;

@end

@interface LJPageContentView : UIView 
@property (nonatomic, weak) id<LJPageContentViewDelegate> delegate;
- (void)addChildVcs:(NSArray *)vcs parentVc:(UIViewController *)parentVc;
@end
