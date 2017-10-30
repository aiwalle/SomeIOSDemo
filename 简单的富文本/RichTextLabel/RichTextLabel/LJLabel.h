//
//  LJLabel.h
//  RichTextLabel
//
//  Created by liang on 2017/10/20.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJLabel : UILabel
// 设定行间距，行间距默认为0
- (void)labelText:(NSString *)text lineSpacing:(CGFloat)l_spacing;

// 行间距与段间距
- (void)labelText:(NSString *)text sectionSpacing:(CGFloat)s_spacing lineSpacing:(CGFloat)l_spacing;

// 返回设置好颜色，字号的富文本字符串
+ (NSAttributedString *)attributedTextArray:(NSArray *)texts textColors:(NSArray *)colors textfonts:(NSArray *)fonts;
// 返回设置好颜色，字号，行间距的富文本字符串
+ (NSAttributedString *)attributedTextArray:(NSArray *)texts textColors:(NSArray *)colors textfonts:(NSArray *)fonts lineSpacing:(CGFloat)l_spacing;

// 返回对应宽度的富文本字符串尺寸
+ (CGSize)sizeLabelWidth:(CGFloat)width attributedText:(NSAttributedString *)attributted;

// 返回对应宽度，文字，字号的字符串尺寸
+ (CGSize)sizeLabelWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font;

// 返回对应宽度，文字，字号，行间距的字符串尺寸
+ (CGSize)sizeLabelWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)l_spacing;

@end
