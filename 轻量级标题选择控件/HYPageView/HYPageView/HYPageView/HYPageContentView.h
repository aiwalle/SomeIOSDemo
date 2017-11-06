//
//  HYPageContentView.h
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYPageContentView;
@protocol HYPageContentViewDelegate <NSObject>
- (void)updateIndexSubView:(NSInteger)index scale:(CGFloat)scale;
- (void)updateBottomLineWithOffsetScale:(CGFloat)offsetScale leftIndex:(NSInteger)left rightIndex:(NSInteger)right offsetX:(CGFloat)offsetX;
- (void)updateTitleScrollviewWithIndex:(NSInteger)index;

@end

@interface HYPageContentView : UIView
@property (nonatomic, weak) id<HYPageContentViewDelegate> delegate;
- (void)addChildVcs:(NSArray *)vcs parentVc:(UIViewController *)parentVc;
@end
