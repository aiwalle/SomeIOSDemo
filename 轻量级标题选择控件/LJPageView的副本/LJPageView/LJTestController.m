
//
//  LJTestController.m
//  LJPageView
//
//  Created by liang on 2017/11/1.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "LJTestController.h"
#import "ViewController.h"
@interface LJTestController ()

@end

@implementation LJTestController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectMake(0, 50, 100, 40)];
//    [self.view addSubview:swi];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    [self.view addSubview:swi];
    [swi addTarget:self action:@selector(heasdf) forControlEvents:UIControlEventValueChanged];
}

- (void)heasdf {
//    [self presentViewController:[LJTestController new] animated:YES completion:nil];
    [self.parentViewController.navigationController pushViewController:[ViewController new] animated:YES];
////    self.presentingViewController
//    
//    self.parentViewController
}

@end
