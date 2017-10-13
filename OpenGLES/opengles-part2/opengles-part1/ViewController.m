//
//  ViewController.m
//  opengles-part1
//
//  Created by liang on 2017/10/12.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()<GLKViewDelegate>{
    
    float _curRed;
    BOOL _increasing;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _increasing = YES;
    _curRed = 0.0;
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *view = [[GLKView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.context = context;
    view.delegate = self;
    [self.view addSubview:view];
    self.view.backgroundColor = [UIColor whiteColor];
    
    view.enableSetNeedsDisplay = NO;
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)render:(CADisplayLink *)displayLink {
    GLKView *view = [self.view.subviews objectAtIndex:0];
    [view display];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    if (_increasing) {
        _curRed += 0.01;
    } else {
        _curRed -= 0.01;
    }
    
    if (_curRed >= 1.0) {
        _curRed = 1.0;
        _increasing = NO;
    }
    if (_curRed <= 0.0) {
        _curRed = 0.0;
        _increasing = YES;
    }
    
    glClearColor(_curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}



@end
