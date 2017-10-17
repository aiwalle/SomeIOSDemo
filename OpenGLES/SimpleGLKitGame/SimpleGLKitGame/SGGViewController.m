//
//  SGGViewController.m
//  SimpleGLKitGame
//
//  Created by liang on 2017/10/13.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "SGGViewController.h"
@interface SGGViewController ()
@property (nonatomic, strong) EAGLContext *context;
@end
@implementation SGGViewController
@synthesize context = _context;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)update {
}

@end
