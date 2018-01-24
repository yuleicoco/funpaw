//
//  FeedbackkViewController.m
//  funpaw
//
//  Created by czx on 2018/1/23.
//  Copyright © 2018年 yulei. All rights reserved.
//

#import "FeedbackkViewController.h"

@interface FeedbackkViewController ()

@end

@implementation FeedbackkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"Feedback"];
    
    
}

-(void)setupView{
    [super setupView];
    UILabel * topLabel = [[UILabel alloc]init];
    topLabel.text = @"User comments,can send this email.";
    topLabel.textColor = YELLOW_COLOR;
    topLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topLabel.superview);
        make.top.equalTo(topLabel.superview.mas_top).offset(60);
    }];
    
    UILabel * emailLabel = [[UILabel alloc]init];
    emailLabel.text = @"support@funpaw.com";
    emailLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    emailLabel.textColor = YELLOW_COLOR;
    [self.view addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emailLabel.superview);
        make.top.equalTo(topLabel.mas_bottom).offset(24);
    }];
    
    
    
    
    
    
    
    
    
    
    
}



@end
