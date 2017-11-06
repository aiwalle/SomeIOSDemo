//
//  HYTitleView.m
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "HYTitleView.h"
#import "UIView+YYAdd.h"
#import "UIColor+Extension.h"
#import "HYPageConfiguration.h"
#import "HYPageContentView.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth  [UIScreen mainScreen].bounds.size.width
@interface HYTitleView()<UIScrollViewDelegate, HYPageContentViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titleViewsArr;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation HYTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _titleViewsArr = [NSMutableArray array];
    _currentIndex = 0;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
//    _scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollView];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor redColor];
    [self addSubview:_bottomLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
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
        //
        label.textColor = i == 0 ? [UIColor redColor] : [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.userInteractionEnabled = YES;
        [self.scrollView addSubview:label];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tapGes];
        [self.titleViewsArr addObject:label];
    }
    
    CGFloat labelW = self.bounds.size.width / 4;
    for (UILabel *label in self.titleViewsArr) {
        NSInteger index = [self.titleViewsArr indexOfObject:label];
        CGFloat labelH = label.font.lineHeight + 2;
        CGFloat labelY = (self.bounds.size.height - labelH) * 0.5;
        label.frame = CGRectMake(labelW * index, labelY, labelW, labelH);
        
        if (index == 0) {
            self.selectedView = label;
            
        }
    }
    // 待修改
    if (titles.count > 4) {
        self.scrollView.contentSize = CGSizeMake(titles.count * labelW, self.bounds.size.height);
    }
    
//    self.selectedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    self.bottomLine.top = self.selectedView.bottom + 2;
    self.bottomLine.size = CGSizeMake(self.selectedView.width, 2);
    self.bottomLine.centerX = self.selectedView.centerX;
    
    [self updateAllTitleLabelSetting];
}

/** 更新所有普通标题的配置*/
- (void)updateAllTitleLabelSetting {
    if (!self.configuration) {
        self.configuration = [HYPageConfiguration new];
    }
    
    for (int i = 0; i < self.titleViewsArr.count; i++) {
        UILabel *label = self.titleViewsArr[i];
        // 字体
        label.font = self.configuration.titleFont;
        
        CGFloat labelW = label.frame.size.width;
        // 文字宽度
        if (self.configuration.titleWidth) {
            labelW = self.configuration.titleWidth;
        }
        // 文字间距
        CGFloat labelX = self.configuration.margin + (self.configuration.margin + labelW) * i;
        CGFloat labelH = self.configuration.titleViewHeight;
        CGFloat labelY = (self.bounds.size.height - labelH) * 0.5;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        // 选中颜色和正常颜色
        label.textColor = label.tag == 0 ? self.configuration.selectedColor : self.configuration.normalColor;

        if (i == 0) {
            self.bottomLine.top = self.selectedView.bottom + 2;
            self.bottomLine.height = self.configuration.bottomLineHeight;
            label.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
        if (i == (self.titleViewsArr.count - 1)) {
            UILabel *lastLabel = self.titleViewsArr[i];
            
            CGFloat contentX =  (lastLabel.width + self.configuration.margin) * self.titleViewsArr.count + self.configuration.margin;
            self.scrollView.contentSize = CGSizeMake(contentX, self.bounds.size.height);
        }
    }
    // 底线宽度
    self.bottomLine.width = self.configuration.bottomLineWidth;
    self.bottomLine.centerX = self.selectedView.centerX;
    // 底线颜色
    self.bottomLine.backgroundColor = self.configuration.bottomLineColor;
    // 底线是否显示
    self.bottomLine.hidden = !self.configuration.showBottomLine;
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
//    NSLog(@"objName-%@", objClassName);
    
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
    }
    
    if (!hasClassProperty) {
        NSString *errorStr = [NSString stringWithFormat:@"%@不包含%@类型的属性,请检查该类", NSStringFromClass(class), objClassName];
        NSAssert(!hasClassProperty, errorStr);
        return;
    }
    
    CGFloat viewW = size.width;
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
        subView.tag = i;
        
        CGFloat viewY = (self.bounds.size.height - size.height) * 0.5;
        CGFloat viewH = size.height;
        CGFloat viewX = viewW * i;
        subView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        [self.scrollView addSubview:subView];
        
        if (i == 0) {
            self.selectedView = subView;
        }
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [subView addGestureRecognizer:tapGes];
        [self.titleViewsArr addObject:subView];
    }
    self.scrollView.contentSize = CGSizeMake(viewW * models.count, 0);
    free(vars);
    
    [self updateAllTitleViewSetting];
}

- (void)updateAllTitleViewSetting {
    if (!self.configuration) {
        self.configuration = [HYPageConfiguration defaultConfiguration];
    }
    // 间距
    CGFloat margin = self.configuration.margin;
    
    for (int i = 0; i < self.titleViewsArr.count; i++) {
        UIView *view = self.titleViewsArr[i];
        
        CGFloat viewW = view.frame.size.width;
        CGFloat viewX = margin + (margin + viewW) * i;
        CGFloat viewH = view.frame.size.height;
        CGFloat viewY = (self.bounds.size.height - viewH) * 0.5;
        view.frame = CGRectMake(viewX, viewY, viewW, viewH);
        
        if (i == 0) {
            self.selectedView = view;
            if ([view conformsToProtocol:@protocol(AdjustTitleViewProtocol)]) {
                [(id<AdjustTitleViewProtocol>)view adjustTitleViewAppearanceWithScale:1.0];
            }
            
            self.bottomLine.top = self.selectedView.bottom - self.configuration.bottomLineHeight - 2;
            self.bottomLine.height = self.configuration.bottomLineHeight;
            
        } else {
            if ([view conformsToProtocol:@protocol(AdjustTitleViewProtocol)]) {
                [(id<AdjustTitleViewProtocol>)view adjustTitleViewAppearanceWithScale:0.0];
            }
        }
        if (i == (self.titleViewsArr.count - 1)) {
            UIView *lastview = self.titleViewsArr[i];
            CGFloat contentX =  (lastview.width + self.configuration.margin) * self.titleViewsArr.count + self.configuration.margin;
            self.scrollView.contentSize = CGSizeMake(contentX, self.bounds.size.height);
        }
    }
    
    // 底线宽度
    self.bottomLine.width = self.configuration.bottomLineWidth;
    self.bottomLine.centerX = self.selectedView.centerX;
    // 底线颜色
    self.bottomLine.backgroundColor = self.configuration.bottomLineColor;
    // 底线是否显示
    self.bottomLine.hidden = !self.configuration.showBottomLine;
}

#pragma mark - ****************UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX >= self.scrollView.contentSize.width - self.scrollView.frame.size.width || offsetX <= 0) {
        return;
    }
    self.bottomLine.centerX = self.selectedView.centerX - offsetX;
}

#pragma mark - ****************Action
- (void)titleLabelClick:(UITapGestureRecognizer *)tapGes {
    UIView *targetView = tapGes.view;
    self.selectedView = targetView;
    
    if ([self.delegate respondsToSelector:@selector(titleView:currentIndex:)]) {
        [self.delegate titleView:self currentIndex:self.selectedView.tag];
    }
}

#pragma mark - ****************LJPageContentViewDelegate
// 更新某个子控件的样式
- (void)updateIndexSubView:(NSInteger)index scale:(CGFloat)scale{
    UIView *view = self.titleViewsArr[index];
    if (scale == 1.0) {
        self.selectedView = view;
    }
    
    if ([view isMemberOfClass:[UILabel class]]) {
        CGFloat normalRed = self.configuration.normalColor.red;
        CGFloat normalGreen = self.configuration.normalColor.green;
        CGFloat normalBlue = self.configuration.normalColor.blue;

        CGFloat selectedRed = self.configuration.selectedColor.red;
        CGFloat selectedGreen = self.configuration.selectedColor.green;
        CGFloat selectedBlue = self.configuration.selectedColor.blue;

        
        CGFloat red = normalRed + (selectedRed - normalRed) * scale;
        CGFloat green = normalGreen + (selectedGreen - normalGreen) * scale;
        CGFloat blue = normalBlue + (selectedBlue - normalBlue) * scale;
        
        UILabel *label = (UILabel *)view;
        label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        
        CGFloat minScale = 1.0;
        CGFloat trueScale = minScale + (self.configuration.maxScale - minScale) * scale;
        label.transform = CGAffineTransformMakeScale(trueScale, trueScale);
    }
    
    if ([view conformsToProtocol:@protocol(AdjustTitleViewProtocol)]) {
        [(id<AdjustTitleViewProtocol>)view adjustTitleViewAppearanceWithScale:scale];
    }
}

// 更新底部红线的样式
- (void)updateBottomLineWithOffsetScale:(CGFloat)offsetScale leftIndex:(NSInteger)left rightIndex:(NSInteger)right offsetX:(CGFloat)offsetX{
    UIView *leftView = self.titleViewsArr[left];
    UIView *rightView = self.titleViewsArr[right];
    
    CGFloat margin = ABS(leftView.centerX - rightView.centerX);
    CGFloat scaleMargin = margin * offsetScale;
    
    if (offsetX > 0) {
        self.bottomLine.centerX = leftView.centerX + scaleMargin - self.scrollView.contentOffset.x;
    } else if (offsetX < 0) {
        self.bottomLine.centerX = rightView.centerX + scaleMargin - self.scrollView.contentOffset.x;
    }
}

// 同步设置标题的偏移
- (void)updateTitleScrollviewWithIndex:(NSInteger)index {
    UIView *view = self.titleViewsArr[index];
    CGFloat offsetX = view.centerX - self.scrollView.width * 0.5;
    CGFloat offsetMax = self.scrollView.contentSize.width - self.scrollView.width;
    if (offsetX < 0 || index == 0) {
        offsetX = 0;
    } else if (offsetX > offsetMax) {
        offsetX = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetX, 0);
    if (self.scrollView.contentSize.width > self.scrollView.width) {
        [self.scrollView setContentOffset:offset animated:YES];
    }
    [self.titleViewsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != index) {
            [self updateIndexSubView:idx scale:0.0];
        }
    }];
}
    
    


@end
