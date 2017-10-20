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
@end
