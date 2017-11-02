//
//  LJTestTitleView.h
//  SegmentView
//
//  Created by liang on 2017/10/31.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LJPageView.h"
#import "LJTitleView.h"
@class LJModel;
@interface LJTestTitleView : UIView<adjustTitleViewProtocol>
@property (nonatomic, strong) LJModel *model;
@end
