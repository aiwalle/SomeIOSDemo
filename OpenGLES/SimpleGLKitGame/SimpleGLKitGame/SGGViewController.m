//
//  SGGViewController.m
//  SimpleGLKitGame
//
//  Created by liang on 2017/10/13.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "SGGViewController.h"
#import "SGGSprite.h"
//#import <>
@interface SGGViewController ()
@property (nonatomic, strong) EAGLContext *context;
@property (strong) GLKBaseEffect *effect;
@property (strong) SGGSprite *player;
@end
@implementation SGGViewController
@synthesize context = _context;
@synthesize player = _player;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, 736, 0, 414, 0, 0);
    self.effect.transform.projectionMatrix = projectionMatrix;
    self.player = [[SGGSprite alloc] initWithFile:@"Player.png" effect:self.effect];
//    glClear(<#GLbitfield mask#>)
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - GLKViewDelegate

//- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
//    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);
//}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    [self.player render];
}

- (void)update {
}

@end
