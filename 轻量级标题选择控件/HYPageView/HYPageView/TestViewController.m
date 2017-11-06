//
//  TestViewController.m
//  HYPageView
//
//  Created by liang on 2017/11/3.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "TestViewController.h"
#import "ViewController.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectMake(0, 50, 100, 40)];
        [self.view addSubview:swi];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    [self.view addSubview:swi];
    [swi addTarget:self action:@selector(heasdf) forControlEvents:UIControlEventValueChanged];
}

- (void)heasdf {
    
    [self presentViewController:[ViewController new] animated:YES completion:nil];
}


@end
