//
//  NSString+Extension.m
//  RichTextLabel
//
//  Created by liang on 2017/10/20.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "NSString+Extension.h"
#import "SDWebImageDownloader.h"
@implementation NSString (Extension)
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

// 返回指定行数，字体的文字高度
// warning: font有个lineHeight可以直接返回行高 😢
//+ (CGFloat)heightForRowNumber:(int)number font:(UIFont *)font {
//    CGSize size = [@"test" sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
//    CGFloat oneLineHeight = size.height;
//    // 确保高度能完全够用，在计算高度时+2
//    return oneLineHeight * number + 2;
//}

+ (CGFloat)heightForRowNumber:(int)number font:(UIFont *)font {
    CGFloat oneLineHeight = font.lineHeight;
    return oneLineHeight * number + 2;
}

+ (NSAttributedString *)changeLineSpaceForString:(NSString *)str WithSpace:(float)space {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return [attributedString copy];
}

+ (NSAttributedString *)changeWordSpaceForString:(NSString *)str WithSpace:(float)space {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return [attributedString copy];
}

+ (NSAttributedString *)changeSpaceForString:(NSString *)str withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return [attributedString copy];
    
}

+ (NSAttributedString *)attributedStringWithImge:(NSString *)imageName contentString:(NSString *)str font:(UIFont *)font{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    UIImage *img = [UIImage imageNamed:imageName];
    //计算图片大小，与文字同高，按比例设置宽度
    CGFloat imgH = font.pointSize;
    CGFloat imgW = (img.size.width / img.size.height) * imgH;
    //计算文字padding-top ，使图片垂直居中
    CGFloat textPaddingTop = (font.lineHeight - font.pointSize) / 2;
    attach.bounds = CGRectMake(0, -textPaddingTop-1, imgW, imgH);
    
    attach.image = img;
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    [attributedString appendAttributedString:imgStr];
    [attributedString appendAttributedString:textAttrStr];
    return [attributedString copy];
}

+ (NSAttributedString *)setText:(NSString *)text frontImages:(NSArray<UIImage *> *)images imageSpan:(CGFloat)span font:(UIFont *)font
{
    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
    
    for (UIImage *img in images) {//遍历添加标签
        
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = img;
        //计算图片大小，与文字同高，按比例设置宽度
        CGFloat imgH = font.pointSize;
        CGFloat imgW = (img.size.width / img.size.height) * imgH;
        //计算文字padding-top ，使图片垂直居中
        CGFloat textPaddingTop = (font.lineHeight - font.pointSize) / 2;
        attach.bounds = CGRectMake(0, -textPaddingTop-1 , imgW, imgH);
        
        NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
        [textAttrStr appendAttributedString:imgStr];
        //标签后添加空格
        [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    
    //设置显示文本
    [textAttrStr appendAttributedString:[[NSAttributedString alloc]initWithString:text]];
    
    //设置间距
    if (span != 0) {
        /*由于图片也会占用一个单位长度,所以带上空格数量，需要 *2 */
        [textAttrStr addAttribute:NSKernAttributeName value:@(span)
                            range:NSMakeRange(0, images.count * 2)];
    }
    //设置字号
    [textAttrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, textAttrStr.length)];
    return [textAttrStr copy];
}

+ (void)attributedStringWithImageURL:(NSURL *)url contentString:(NSString *)str imageSpan:(CGFloat)span textFont:(UIFont *)font complete:(downloadCompleteBlock)block{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        if (finished && error == nil) {
            NSAttributedString *atStr = [NSString setText:str frontImages:@[image] imageSpan:span font:font];
            if (block) {
                block(atStr);
            } else {
#ifdef DEBUG
                NSLog(@"error-%@", error.description);
#endif
            }
        }
    }];
}

@end
