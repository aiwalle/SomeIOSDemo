//
//  HYTestView.m
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "HYTestView.h"
#import "HYTestModel.h"
@interface HYTestView()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;

@end
@implementation HYTestView
- (void)setModel:(HYTestModel *)model {
    _model = model;
    self.iconImageView.image = [UIImage imageNamed:model.iconStr];
    self.nameLabel.text = model.name;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _iconImageView = [UIImageView new];
    _iconImageView.backgroundColor = [UIColor lightGrayColor];
    _iconImageView.image = [UIImage imageNamed:@"wallelj"];
    _iconImageView.layer.cornerRadius = 5.0;
    _iconImageView.layer.masksToBounds = YES;
    _nameLabel = [UILabel new];
    _nameLabel.backgroundColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:17.0];
    [self addSubview:_iconImageView];
    [self addSubview:_nameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height / 10 * 7);
    _nameLabel.frame = CGRectMake(0, CGRectGetMaxY(_iconImageView.frame), self.bounds.size.width, self.bounds.size.height / 10 * 3);
}

- (void)adjustTitleViewAppearanceWithScale:(CGFloat)scale {
    
    self.nameLabel.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1];
    CGFloat minScale = 1.0;
    CGFloat trueScale = minScale + (1.2 - minScale) * scale;
    if (scale >= 1.0) {
        self.nameLabel.font = [UIFont boldSystemFontOfSize:17.0];
    }
    
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}
    

@end
