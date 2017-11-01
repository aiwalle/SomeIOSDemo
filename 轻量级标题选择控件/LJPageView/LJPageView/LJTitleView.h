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

@interface LJTitleView : UIView 
@property (nonatomic, weak) id<LJTitleViewDelegate> delegate;
- (void)configWithTitles:(NSArray *)titles;
@end
