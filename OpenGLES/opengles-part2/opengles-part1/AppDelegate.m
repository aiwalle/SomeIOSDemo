//
//  AppDelegate.m
//  opengles-part1
//
//  Created by liang on 2017/10/12.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "AppDelegate.h"
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
@interface AppDelegate ()<GLKViewDelegate, GLKViewControllerDelegate>{
    
    float _curRed;
    BOOL _increasing;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    _increasing = YES;
//    _curRed = 0.0;
//    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    GLKView *view = [[GLKView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    view.context = context;
//    view.delegate = self;
//    
//    GLKViewController *viewController = [[GLKViewController alloc] initWithNibName:nil bundle:nil];
//    viewController.view = view;
//    viewController.delegate = self;
//    viewController.preferredFramesPerSecond = 60;
//    
//    self.window.rootViewController = viewController;
//    
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    return YES;
}

//- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
//
//    glClearColor(_curRed, 0.0, 0.0, 1.0);
//    NSLog(@"_curRed-%f", _curRed);
//    glClear(GL_COLOR_BUFFER_BIT);
//}
//
//- (void)glkViewControllerUpdate:(GLKViewController *)controller {
//    if (_increasing) {
//        _curRed += 0.01 * controller.timeSinceLastUpdate;
//    } else {
//        _curRed -= 0.01 * controller.timeSinceLastUpdate;
//    }
//    
//    if (_curRed >= 1.0) {
//        _curRed = 1.0;
//        _increasing = NO;
//    }
//    if (_curRed <= 0.0) {
//        _curRed = 0.0;
//        _increasing = YES;
//    }
//}

@end
