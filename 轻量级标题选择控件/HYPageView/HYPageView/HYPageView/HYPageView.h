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

@property (nonatomic, strong) HYPageConfiguration *config;

- (void)setupWithTitleModels:(NSArray *)models titleViewClass:(Class)class titleViewSize:(CGSize)size childVcs:(NSArray *)childVcs parentVC:(UIViewController *)parent;
- (void)setupWithTitles:(NSArray *)titles childVcs:(NSArray *)childVcs parentVC:(UIViewController *)parent;
@end
