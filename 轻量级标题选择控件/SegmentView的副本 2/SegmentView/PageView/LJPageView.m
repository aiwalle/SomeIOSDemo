//
//  LJPageView.m
//  SegmentView
//
//  Created by liang on 2017/10/30.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "LJPageView.h"
#import "LJPageConfiguration.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "LJTestTitleView.h"
@interface LJPageView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titlesArr;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *selectedView;
@end

@implementation LJPageView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder  {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _titlesArr = [NSMutableArray array];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollView];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor redColor];
    [self addSubview:_bottomLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
}

- (void)configWithModels:(NSArray *)models customViewClass:(Class)class viewSize:(CGSize)size {
    if (models.count <= 0) {
        return;
    }
    
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[class class]]) {
            [subview removeFromSuperview];
        }
    }

    // 1.获取模型对应的类名
    NSObject *obj = models.firstObject;
    const char *objCls = class_getName([obj class]);
    NSString *objClassName = [NSString stringWithUTF8String:objCls];
    NSLog(@"objName-%@", objClassName);
    
    // 2.获取传入class对应的属性列表
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList(class, &outCount);
    NSString *propertyNameStr = @"";
    BOOL hasClassProperty = NO;
    for (int i = 0; i < outCount; i++) {
        Ivar var = vars[i];
        const char *className = ivar_getTypeEncoding(var);
        NSString *classNameStr = [NSString stringWithUTF8String:className];
        
        const char *propertyName = ivar_getName(var);
        propertyNameStr = [NSString stringWithUTF8String:propertyName];
        // 3.如果属性对应的类和第一步模型获得的类相同，关联成功
        if ([classNameStr containsString:objClassName]) {
            hasClassProperty = YES;
            break;
        }
        NSLog(@"nameStr-%@", classNameStr);
    }
    
    if (!hasClassProperty) {
        NSLog(@"%@不包含%@类型的属性", NSStringFromClass(class), objClassName);
        return;
    }
    
    
    CGFloat viewW = self.bounds.size.width / 4;
    for (int i = 0; i < models.count; i++) {
        NSObject *theModel = models[i];
        
        // 5.创建class对应的实例对象
        id classObj = [[class alloc] init];
        NSString *property = [propertyNameStr substringFromIndex:1];
        
        // 6.生成对应的方法名
        NSString *methodName = [NSString stringWithFormat:@"set%@%@:",[property substringToIndex:1].uppercaseString,[property substringFromIndex:1]];
        SEL setter = sel_registerName(methodName.UTF8String);
        if ([classObj respondsToSelector:setter]) {
            ((void (*) (id,SEL,id)) objc_msgSend) (classObj, setter, theModel);
        }
        
        UIView *subView = (UIView *)classObj;
        
        CGFloat viewY = (self.bounds.size.height - size.height) * 0.5;
        CGFloat viewH = size.height;
        CGFloat viewX = viewW * i;
        subView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        [self.scrollView addSubview:subView];
        
//        subView.backgroundColor = i == 0 ? [UIColor redColor] : [UIColor blackColor];
        if (i == 0) {
            self.selectedView = subView;
            self.bottomLine.frame = CGRectMake(subView.frame.origin.x, CGRectGetMaxY(subView.frame)+2, subView.frame.size.width, 2);
        }
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [subView addGestureRecognizer:tapGes];
        [self.titlesArr addObject:subView];
    }
    self.scrollView.contentSize = CGSizeMake(viewW * models.count, 0);
    free(vars);
    
    [self updateAllTitleViewSetting];
}


- (void)configWithTitles:(NSArray *)titles {
    if (titles.count <= 0) {
        return;
    }
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }
    }
    
    for (int i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
        UILabel *label = [UILabel new];
        label.text = title;
        label.tag = i;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = i == 0 ? [UIColor redColor] : [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.userInteractionEnabled = YES;
        [self.scrollView addSubview:label];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tapGes];
        [self.titlesArr addObject:label];
    }
    
    CGFloat labelW = self.bounds.size.width / 4;
    for (UILabel *label in self.titlesArr) {
        NSInteger index = [self.titlesArr indexOfObject:label];
        CGFloat labelH = label.font.lineHeight + 2;
        CGFloat labelY = (self.bounds.size.height - labelH) * 0.5;
        label.frame = CGRectMake(labelW * index, labelY, labelW, labelH);
        
        if (index == 0) {
            self.selectedView = label;
            self.bottomLine.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+2, label.frame.size.width, 2);
        }
    }
    
    if (titles.count > 4) {
        self.scrollView.contentSize = CGSizeMake(titles.count * labelW, self.bounds.size.height);
    }
    
    [self updateAllTitleLabelSetting];
}

- (void)updateAllTitleViewSetting {
    if (!self.configuration) {
        self.configuration = [LJPageConfiguration new];
    }
    
    for (int i = 0; i < self.titlesArr.count; i++) {
        UIView *view = self.titlesArr[i];

        CGFloat viewW = view.frame.size.width;
        CGFloat viewX = self.configuration.margin + (self.configuration.margin + viewW) * i;
        CGFloat viewH = view.frame.size.height;
        CGFloat viewY = (self.bounds.size.height - viewH) * 0.5;
        view.frame = CGRectMake(viewX, viewY, viewW, viewH);
        
        if (i == 0) {
            if ([view conformsToProtocol:@protocol(adjustTitleViewProtocol)]) {
                [(id<adjustTitleViewProtocol>)view adjustTitleViewAppearanceWithTarget];
            }
            self.bottomLine.frame = CGRectMake(view.frame.origin.x, CGRectGetMaxY(view.frame)+2, view.frame.size.width, 2);
        } else {
            if ([view conformsToProtocol:@protocol(adjustTitleViewProtocol)]) {
                [(id<adjustTitleViewProtocol>)view adjustTitleViewAppearanceWithOrigin];
            }
        }
        if (i == (self.titlesArr.count - 1)) {
            UILabel *lastview = self.titlesArr[i];
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastview.frame) + self.configuration.margin, self.bounds.size.height);
        }
    }
    
    self.bottomLine.backgroundColor = self.configuration.selectedColor;
    self.bottomLine.hidden = !self.configuration.showBottomLine;
}

- (void)updateAllTitleLabelSetting {
    if (!self.configuration) {
        self.configuration = [LJPageConfiguration new];
    }
    
    for (int i = 0; i < self.titlesArr.count; i++) {
        UILabel *label = self.titlesArr[i];
        label.font = self.configuration.titleFont;
        
        CGFloat labelW = label.frame.size.width;
        if (self.configuration.titleWidth) {
            labelW = self.configuration.titleWidth;
        }
        CGFloat labelX = self.configuration.margin + (self.configuration.margin + labelW) * i;
        CGFloat labelH = self.configuration.titleViewHeight;
        CGFloat labelY = (self.bounds.size.height - labelH) * 0.5;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        label.textColor = label.tag == 0 ? self.configuration.selectedColor : self.configuration.normalColor;
        if (i == 0) {
            self.bottomLine.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+2, label.frame.size.width, 2);
        }
        if (i == (self.titlesArr.count - 1)) {
            UILabel *lastLabel = self.titlesArr[i];
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame) + self.configuration.margin, self.bounds.size.height);
        }
    }
    
    self.bottomLine.backgroundColor = self.configuration.selectedColor;
    self.bottomLine.hidden = !self.configuration.showBottomLine;
}

#pragma mark - ****************Action
- (void)titleLabelClick:(UITapGestureRecognizer *)tapGes {
    // 这里写的不好
    if ([tapGes.view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)tapGes.view;
        UILabel *originLabel = (UILabel *)self.selectedView;
        originLabel.textColor = self.configuration.normalColor;
        label.textColor = self.configuration.selectedColor;
        self.selectedView = label;
    } else {
        UIView *targetView = tapGes.view;
        UIView *originView = self.selectedView;
        if ([tapGes.view conformsToProtocol:@protocol(adjustTitleViewProtocol)]) {
            [(id<adjustTitleViewProtocol>)originView adjustTitleViewAppearanceWithOrigin];
            [(id<adjustTitleViewProtocol>)targetView adjustTitleViewAppearanceWithTarget];
        }
        
        self.selectedView = targetView;
    }

    [UIView animateWithDuration:0.25 animations:^{
        CGFloat labelFrameX = self.selectedView.frame.origin.x - self.scrollView.contentOffset.x;
        self.bottomLine.frame = CGRectMake(labelFrameX, self.bottomLine.frame.origin.y, self.bottomLine.frame.size.width, self.bottomLine.frame.size.height);
    }];
    CGFloat offsetX = self.selectedView.frame.origin.x - self.scrollView.frame.size.width * 0.5 + self.selectedView.frame.size.width * 0.5;

    if (offsetX > 0) {
        if (offsetX >= (self.scrollView.contentSize.width - self.scrollView.frame.size.width)) {
            offsetX = (self.scrollView.contentSize.width - self.scrollView.frame.size.width);
        }
        CGPoint point = CGPointMake(offsetX, 0);
        [self.scrollView setContentOffset:point animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - ****************UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX >= self.scrollView.contentSize.width - self.scrollView.frame.size.width || offsetX <= 0) {
        return;
    }

    CGRect rect = CGRectMake(self.selectedView.frame.origin.x - offsetX, self.bottomLine.frame.origin.y, self.bottomLine.frame.size.width, self.bottomLine.frame.size.height);
    self.bottomLine.frame = rect;
}


@end
