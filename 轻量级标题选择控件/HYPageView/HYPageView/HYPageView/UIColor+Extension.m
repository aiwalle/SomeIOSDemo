//
//  UIColor+Extension.m
//  HYPageView
//
//  Created by liang on 2017/11/6.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
- (CGFloat)red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}
@end
