//
//  HelloGLKitViewController.m
//  opengles-part1
//
//  Created by liang on 2017/10/12.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "HelloGLKitViewController.h"
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
@interface HelloGLKitViewController (){
    
    float _curRed;
    BOOL _increasing;
}
@property (strong, nonatomic) EAGLContext *context;
@end

@implementation HelloGLKitViewController
@synthesize context = _context;
- (void)viewDidLoad {
    [super viewDidLoad];
    // 如果进入后台，是否继续
    self.pauseOnWillResignActive = NO;
    // 进入前台是否继续
    self.resumeOnDidBecomeActive = YES;
    
    
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(_curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
}

#pragma mark - GLKViewControllerDelegate

- (void)update {
    if (_increasing) {
        _curRed += 1.0 * self.timeSinceLastUpdate;
    } else {
        _curRed -= 1.0 * self.timeSinceLastUpdate;
    }
    if (_curRed >= 1.0) {
        _curRed = 1.0;
        _increasing = NO;
    }
    if (_curRed <= 0.0) {
        _curRed = 0.0;
        _increasing = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.paused = !self.paused;
}

@end
