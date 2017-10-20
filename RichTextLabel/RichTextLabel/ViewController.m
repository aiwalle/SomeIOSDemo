//
//  ViewController.m
//  RichTextLabel
//
//  Created by liang on 2017/10/20.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "ViewController.h"
#import "LJLabel.h"
#import "NSString+Extension.h"
@interface ViewController ()
//@property (nonatomic, strong) UILabel *label;
@property (weak, nonatomic) IBOutlet LJLabel *label;
@property (nonatomic, strong) NSString *str;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    self.str = @"这是一个矛盾的时代，一方面互联网带来了无数的机会，塑造了不少的新贵，每一个行业都在被改变或等待被颠覆；另一方面，中产阶级无比焦虑，缺乏安全感，媒体天天营造上升通道被关闭的悲凉氛\n围。我相信我们正在经历新的技术革命和新的文艺复兴，我们无比兴奋，却又无比焦虑。我们好似有无限机会，又不知道如何抓住它们。我们缺的不是信息，而是认知不是信息，而是认知不是信息，而是认知";
//    [self.label labelText:self.str sectionSpacing:10 lineSpacing:0];
    
//    [self.label labelText:self.str lineSpacing:0];
    
//    CGSize size1 = [self.str sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(HUGE, HUGE) mode:0];
//    CGFloat width = [self.str widthForFont:0];
//    CGFloat height = [self.str heightForFont:0 width:HUGE];
    
//    CGFloat height = [NSString heightForRowNumber:1 font:[UIFont systemFontOfSize:17]];
//
//
//
//    NSAttributedString *atStr = [NSString attributedStringWithImge:@"orthogon_1701" contentString:@"这里是一段标题这里是一段标题这里是一段标题这里是一段标题这里是一段标题这里是一段标题" font:[UIFont systemFontOfSize:17]];
//    self.oneLabel.attributedText = atStr;
    
    
    UIImage *image = [UIImage imageNamed:@"orthogon_1701"];
    
    NSAttributedString *atStr = [NSString setText:@"我相信我如何。我" frontImages:@[image, image] imageSpan:0 font:[UIFont systemFontOfSize:33]];
    self.oneLabel.attributedText = atStr;
    
}

- (IBAction)btn1:(id)sender {
//    [self.label labelText:@"这是一个矛盾的时代，一方面互联网带来了无数的机会，塑造了不少的新贵，每一个行业都在被改变或等待被颠覆；另一方面，中产阶级无比焦虑，缺乏安全感，媒体天天营造上升通道被关闭的悲凉氛围。我相信我们正在经历新的技术革命和新的文艺复兴，我们无比兴奋，却又无比焦虑。我们好似有无限机会，又不知道如何抓住它们。我们缺的不是信息，而是认知" lineSpacing:0];
    
    [self.label labelText:self.str sectionSpacing:0 lineSpacing:0];
}

- (IBAction)btn2:(id)sender {
//    [self.label labelText:@"这是一个矛盾的时代，一方面互联网带来了无数的机会，塑造了不少的新贵，每一个行业都在被改变或等待被颠覆；另一方面，中产阶级无比焦虑，缺乏安全感，媒体天天营造上升通道被关闭的悲凉氛围。我相信我们正在经历新的技术革命和新的文艺复兴，我们无比兴奋，却又无比焦虑。我们好似有无限机会，又不知道如何抓住它们。我们缺的不是信息，而是认知" lineSpacing:20];
    
    [self.label labelText:self.str sectionSpacing:10 lineSpacing:0];
}

- (IBAction)btn3:(id)sender {
//    [self.label labelText:@"这是一个矛盾的时代，一方面互联网带来了无数的机会，塑造了不少的新贵，每一个行业都在被改变或等待被颠覆；另一方面，中产阶级无比焦虑，缺乏安全感，媒体天天营造上升通道被关闭的悲凉氛围。我相信我们正在经历新的技术革命和新的文艺复兴，我们无比兴奋，却又无比焦虑。我们好似有无限机会，又不知道如何抓住它们。我们缺的不是信息，而是认知" lineSpacing:-10];
    
    [self.label labelText:self.str sectionSpacing:20 lineSpacing:0];
}


@end
