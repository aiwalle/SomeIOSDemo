//
//  LJTestTitleView.m
//  SegmentView
//
//  Created by liang on 2017/10/31.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "LJTestTitleView.h"
#import "LJModel.h"
@interface LJTestTitleView()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation LJTestTitleView
- (void)setModel:(LJModel *)model {
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _iconImageView = [UIImageView new];
//    _iconImageView.backgroundColor = [UIColor lightGrayColor];
    _nameLabel = [UILabel new];
//    _nameLabel.backgroundColor = [UIColor greenColor];
    [self addSubview:_iconImageView];
    [self addSubview:_nameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height / 10 * 7);
    _nameLabel.frame = CGRectMake(0, CGRectGetMaxY(_iconImageView.frame), self.bounds.size.width, self.bounds.size.height / 10 * 3);
}

- (void)adjustTitleViewAppearanceWithOrigin {
    self.iconImageView.backgroundColor = [UIColor purpleColor];
    self.nameLabel.textColor = [UIColor blackColor];
}

- (void)adjustTitleViewAppearanceWithTarget {
    self.iconImageView.backgroundColor = [UIColor orangeColor];
    self.nameLabel.textColor = [UIColor redColor];
}

@end
