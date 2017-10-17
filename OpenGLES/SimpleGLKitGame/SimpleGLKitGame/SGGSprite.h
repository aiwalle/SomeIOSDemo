//
//  SGGSprite.h
//  SimpleGLKitGame
//
//  Created by liang on 2017/10/13.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface SGGSprite : NSObject
- (instancetype)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect;
- (void)render;
@end
