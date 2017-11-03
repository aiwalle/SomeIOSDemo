//
//  LJTitleView.m
//  LJPageView
//
//  Created by liang on 2017/11/1.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "LJTitleView.h"
#import "UIView+YYAdd.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "LJTestTitleView.h"
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth  [UIScreen mainScreen].bounds.size.width
@interface LJTitleView()<UIScrollViewDelegate, LJPageContentViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titlesArr;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation LJTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _titlesArr = [NSMutableArray array];
    _currentIndex = 0;
    
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
            self.selectedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
    }
    
    if (titles.count > 4) {
        self.scrollView.contentSize = CGSizeMake(titles.count * labelW, self.bounds.size.height);
    }
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
    
    
    //    CGFloat viewW = self.bounds.size.width / 4;
    
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
        
        //        subView.backgroundColor = i == 0 ? [UIColor redColor] : [UIColor blackColor];
        if (i == 0) {
            self.selectedView = subView;
            self.bottomLine.frame = CGRectMake(subView.frame.origin.x, CGRectGetMaxY(subView.frame)+2, subView.frame.size.width, 2);
            self.selectedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [subView addGestureRecognizer:tapGes];
        [self.titlesArr addObject:subView];
    }
    self.scrollView.contentSize = CGSizeMake(viewW * models.count, 0);
    free(vars);
    
    [self updateAllTitleViewSetting];
}

- (void)updateAllTitleViewSetting {
//    if (!self.configuration) {
//        self.configuration = [LJPageConfiguration new];
//    }
    
    CGFloat gurationMargin = 10;
    
    for (int i = 0; i < self.titlesArr.count; i++) {
        UIView *view = self.titlesArr[i];
        
        CGFloat viewW = view.frame.size.width;
        CGFloat viewX = gurationMargin + (gurationMargin + viewW) * i;
        CGFloat viewH = view.frame.size.height;
        CGFloat viewY = (self.bounds.size.height - viewH) * 0.5;
        view.frame = CGRectMake(viewX, viewY, viewW, viewH);
        
        if (i == 0) {
            if ([view conformsToProtocol:@protocol(adjustTitleViewProtocol)]) {
                [(id<adjustTitleViewProtocol>)view adjustTitleViewAppearanceWithScale:1.0];
            }
            self.bottomLine.frame = CGRectMake(view.frame.origin.x, CGRectGetMaxY(view.frame)+2, view.frame.size.width, 2);
        } else {
            if ([view conformsToProtocol:@protocol(adjustTitleViewProtocol)]) {
                [(id<adjustTitleViewProtocol>)view adjustTitleViewAppearanceWithScale:0.0];
            }
        }
        if (i == (self.titlesArr.count - 1)) {
            UILabel *lastview = self.titlesArr[i];
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastview.frame) + gurationMargin, self.bounds.size.height);
        }
    }
    
    self.bottomLine.backgroundColor = [UIColor redColor];
//    self.bottomLine.hidden = !self.configuration.showBottomLine;
}

//
//- (void)titleLabelClick:(UITapGestureRecognizer *)tapGes {
//    if (![tapGes.view isKindOfClass:[UILabel class]]) {
//        return;
//    }
//    if (tapGes.view.tag == self.selectedView.tag) {
//        return;
//    }
//
//    UILabel *label = (UILabel *)tapGes.view;
//    self.selectedView = label;
//    self.currentIndex = label.tag;
//
//    if ([self.delegate respondsToSelector:@selector(titleView:currentIndex:)]) {
//        [self.delegate titleView:self currentIndex:self.currentIndex];
//    }
//}

- (void)titleLabelClick:(UITapGestureRecognizer *)tapGes {
//    if ([tapGes.view isKindOfClass:[UILabel class]]) {
//        UILabel *label = (UILabel *)tapGes.view;
//        UILabel *originLabel = (UILabel *)self.selectedView;
////        originLabel.textColor = self.configuration.normalColor;
////        label.textColor = self.configuration.selectedColor;
//        self.selectedView = label;
//    } else {
//        UIView *targetView = tapGes.view;
//        UIView *originView = self.selectedView;
//        if ([tapGes.view conformsToProtocol:@protocol(adjustTitleViewProtocol)]) {
//            [(id<adjustTitleViewProtocol>)originView adjustTitleViewAppearanceWithOrigin];
//            [(id<adjustTitleViewProtocol>)targetView adjustTitleViewAppearanceWithTarget];
//        }
    
    
    UIView *targetView = tapGes.view;
//    UIView *originView = self.selectedView;
    self.selectedView = targetView;
    self.currentIndex = targetView.tag;
//    }
    
    if ([self.delegate respondsToSelector:@selector(titleView:currentIndex:)]) {
        [self.delegate titleView:self currentIndex:self.currentIndex];
    }
}

#pragma mark - ****************UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX >= self.scrollView.contentSize.width - self.scrollView.frame.size.width || offsetX <= 0) {
        return;
    }
    self.bottomLine.centerX = self.selectedView.centerX - offsetX;
}


// 更新某个子控件的样式
//- (void)updateIndexSubView:(NSInteger)index scale:(CGFloat)scale{
//    UILabel *label = self.titlesArr[index];
//
//    label.textColor = [UIColor colorWithRed:0.373 + (0.980 - 0.373) * scale green:0.396 - (0.396 - 0.271) * scale blue:0.459 - (0.459 - 0.196) * scale alpha:1];
//    CGFloat minScale = 1.0;
//    CGFloat trueScale = minScale + (1.2 - minScale) * scale;
//    label.transform = CGAffineTransformMakeScale(trueScale, trueScale);
//    if (scale == 1.0) {
//        self.selectedView = label;
//    }
//}

// 更新某个子控件的样式
- (void)updateIndexSubView:(NSInteger)index scale:(CGFloat)scale{
    UIView *view = self.titlesArr[index];
    
//    label.textColor = [UIColor colorWithRed:0.373 + (0.980 - 0.373) * scale green:0.396 - (0.396 - 0.271) * scale blue:0.459 - (0.459 - 0.196) * scale alpha:1];
//    CGFloat minScale = 1.0;
//    CGFloat trueScale = minScale + (1.2 - minScale) * scale;
//    label.transform = CGAffineTransformMakeScale(trueScale, trueScale);
    
    if (scale >= 1.0) {
        NSLog(@"scale---==%f", scale);
    }
    
//    [view setBackgroundColor:[UIColor colorWithRed:0.373 + (0.980 - 0.373) * scale green:0.396 - (0.396 - 0.271) * scale blue:0.459 - (0.459 - 0.196) * scale alpha:1]];
//    CGFloat minScale = 1.0;
//    CGFloat trueScale = minScale + (1.2 - minScale) * scale;
//    view.transform = CGAffineTransformMakeScale(trueScale, trueScale);
    
    if ([view respondsToSelector:@selector(adjustTitleViewAppearanceWithScale:)]) {
        [(id<adjustTitleViewProtocol>)view adjustTitleViewAppearanceWithScale:scale];
    }
    
    
    if (scale == 1.0) {
        self.selectedView = view;
    }
    
    
}

// 更新底部红线的样式
//- (void)updateBottomLineWithOffsetScale:(CGFloat)offsetScale leftIndex:(NSInteger)left rightIndex:(NSInteger)right offsetX:(CGFloat)offsetX{
//    UILabel *leftLabel = self.titlesArr[left];
//    UILabel *rightLabel = self.titlesArr[right];
//    
//    CGFloat margin = ABS(leftLabel.centerX - rightLabel.centerX);
//    CGFloat scaleMargin = margin * offsetScale;
//
//    if (offsetX > 0) {
//        self.bottomLine.centerX = leftLabel.centerX + scaleMargin - self.scrollView.contentOffset.x;
//    } else if (offsetX < 0) {
//        self.bottomLine.centerX = rightLabel.centerX + scaleMargin - self.scrollView.contentOffset.x;
//    }
//}

- (void)updateBottomLineWithOffsetScale:(CGFloat)offsetScale leftIndex:(NSInteger)left rightIndex:(NSInteger)right offsetX:(CGFloat)offsetX{
    UIView *leftLabel = self.titlesArr[left];
    UIView *rightLabel = self.titlesArr[right];
    
    CGFloat margin = ABS(leftLabel.centerX - rightLabel.centerX);
    CGFloat scaleMargin = margin * offsetScale;
    
    if (offsetX > 0) {
        self.bottomLine.centerX = leftLabel.centerX + scaleMargin - self.scrollView.contentOffset.x;
    } else if (offsetX < 0) {
        self.bottomLine.centerX = rightLabel.centerX + scaleMargin - self.scrollView.contentOffset.x;
    }
}

//// 同步设置标题的偏移
//- (void)updateTitleScrollviewWithIndex:(NSInteger)index {
//    UILabel *label = self.titlesArr[index];
//    CGFloat offsetX = label.centerX - self.scrollView.width * 0.5;
//    CGFloat offsetMax = self.scrollView.contentSize.width - self.scrollView.width;
//    if (offsetX < 0 || index == 0) {
//        offsetX = 0;
//    } else if (offsetX > offsetMax) {
//        offsetX = offsetMax;
//    }
//    CGPoint offset = CGPointMake(offsetX, 0);
//    if (self.scrollView.contentSize.width > self.scrollView.width) {
//        [self.scrollView setContentOffset:offset animated:YES];
//    }
//    [self.titlesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (idx != index) {
//            [self updateIndexSubView:idx scale:0.0];
//        }
//    }];
//}


// 同步设置标题的偏移
- (void)updateTitleScrollviewWithIndex:(NSInteger)index {
    UIView *label = self.titlesArr[index];
    CGFloat offsetX = label.centerX - self.scrollView.width * 0.5;
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
    [self.titlesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != index) {
            [self updateIndexSubView:idx scale:0.0];
        }
    }];
}

@end
