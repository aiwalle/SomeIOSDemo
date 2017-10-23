//
//  NSString+Extension.h
//  RichTextLabel
//
//  Created by liang on 2017/10/20.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 图片下载完成的block*/
typedef void(^downloadCompleteBlock)(NSAttributedString *attStr);
@interface NSString (Extension)
/**
 在指定的空间内，文字所能显示需要的尺寸

 @param font 字号
 @param size 给定尺寸
 @param lineBreakMode 换行方式
 @return 需要的尺寸
 @warning:如果文字尺寸超出了给定的尺寸，就返回能显示部分完全的尺寸，例如文本为: abc，现在给定的尺寸只能完全显示ab，c显示不全，那么返回的尺寸就是能完全显示ab的尺寸
 */
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/**
 单行文本的宽度

 @param font 字号
 @return 单行文本宽度
 */
- (CGFloat)widthForFont:(UIFont *)font;

/**
 给定宽度的文字高度

 @param font 字号
 @param width 给定宽度
 @return 文本高度
 */
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

/**
 返回指定行数，字号的文字高度

 @param number 行数
 @param font 字号
 @return 文本高度
 @warning: font有个lineHeight可以直接返回单行行高
 */
+ (CGFloat)heightForRowNumber:(int)number font:(UIFont *)font;

/**
 改变字符串的行间距，返回一个富文本字符串

 @param str 文本内容
 @param space 行间距
 @return 富文本
 */
+ (NSAttributedString *)changeLineSpaceForString:(NSString *)str WithSpace:(float)space;

/**
 改变字符串的字间距，返回一个富文本字符串

 @param str 文本内容
 @param space 字间距
 @return 富文本
 */
+ (NSAttributedString *)changeWordSpaceForString:(NSString *)str WithSpace:(float)space;

/**
 改变字符串的行间距和字间距，返回一个富文本字符

 @param str 文本内容
 @param lineSpace 行间距
 @param wordSpac 字间距
 @return 富文本
 */
+ (NSAttributedString *)changeSpaceForString:(NSString *)str withLineSpace:(float)lineSpace WordSpace:(float)wordSpac;

/**
 通过图片名(本地)，字符串内容，字号，返回富文本字符串

 @param imageName 图片名(本地)
 @param str 文本内容
 @param font 字号
 @return 富文本(图片都放在最前面)
 */
+ (NSAttributedString *)attributedStringWithImge:(NSString *)imageName contentString:(NSString *)str font:(UIFont *)font;

/**
 通过图片数组(本地)，字符串内容，图片和字符串的间距，字号，返回富文本字符串

 @param text 文本内容
 @param images 图片数组
 @param span 图片和文字间距
 @param font 字号
 @return 富文本(图片都放在最前面)
 */
+ (NSAttributedString *)setText:(NSString *)text frontImages:(NSArray<UIImage *> *)images imageSpan:(CGFloat)span font:(UIFont *)font;

/**
 通过图片URL生成富文本

 @param url 图片地址
 @param str 文本内容
 @param span 图片和文本间距
 @param font 字号
 @param block 返回富文本的回调，主线程
 */
+ (void)attributedStringWithImageURL:(NSURL *)url contentString:(NSString *)str imageSpan:(CGFloat)span textFont:(UIFont *)font complete:(downloadCompleteBlock)block;
@end
