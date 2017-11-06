//
//  HYTestView.h
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTitleView.h"
@class HYTestModel;
@interface HYTestView : UIView<AdjustTitleViewProtocol>
@property (nonatomic, strong) HYTestModel *model;
@end
