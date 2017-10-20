//
//  NSString+Extension.h
//  RichTextLabel
//
//  Created by liang on 2017/10/20.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)
// 这个返回的是在指定的空间内，文字所能显示需要的size，如果文字尺寸超出了给定的尺寸，就返回能显示部分完全的尺寸，例如文本为: abc，现在给定的size只能完全显示ab，c显示不全，那么返回的尺寸就是ab的尺寸
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
// 单行宽度
- (CGFloat)widthForFont:(UIFont *)font;
// 给定宽度的高度
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;
// 返回指定行数，字体的文字高度

// warning: font有个lineHeight可以直接返回行高 😢
+ (CGFloat)heightForRowNumber:(int)number font:(UIFont *)font;
// 改变字符串的行间距，返回一个富文本字符串
+ (NSAttributedString *)changeLineSpaceForString:(NSString *)str WithSpace:(float)space;
// 改变字符串的字间距，返回一个富文本字符串
+ (NSAttributedString *)changeWordSpaceForString:(NSString *)str WithSpace:(float)space;
// 改变字符串的行间距和字间距，返回一个富文本字符
+ (NSAttributedString *)changeSpaceForString:(NSString *)str withLineSpace:(float)lineSpace WordSpace:(float)wordSpac;

+ (NSAttributedString *)attributedStringWithImge:(NSString *)imageName contentString:(NSString *)str font:(UIFont *)font;

+ (NSAttributedString *)setText:(NSString *)text frontImages:(NSArray<UIImage *> *)images imageSpan:(CGFloat)span font:(UIFont *)font;
@end
