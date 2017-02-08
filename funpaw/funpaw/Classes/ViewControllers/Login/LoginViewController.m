//
//  LoginViewController.m
//  funpaw
//
//  Created by czx on 2017/2/7.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic,strong)UITextField * accountTextfield;
@property (nonatomic,strong)UITextField * passwordTextfield;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
    UIButton * test = [[UIButton alloc]initWithFrame:CGRectMake(100, 40, 100, 100)];
    test.backgroundColor = [UIColor blueColor];
    [self.view addSubview:test];
    [test addTarget:self action:@selector(dowewerwfwafa) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)dowewerwfwafa{

    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStateChange object:@YES];

}


-(void)setupView{
    UIImageView * backImage = [[UIImageView alloc]init];
    backImage.image = [UIImage imageNamed:@"egg_login.jpg"];
    [self.view addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(backImage.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];

    UIView * centerView = [[UIView alloc]init];
    centerView.backgroundColor = RGB(245, 145, 40);
    centerView.alpha = 0.8;
    [self.view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.superview).offset(200);
        make.left.equalTo(centerView.superview).offset(20);
        make.right.equalTo(centerView.superview).offset(-20);
        make.bottom.equalTo(centerView.superview).offset(-200);
        
        
    }];
    
    UIView * topKuang = [[UIView alloc]init];
    topKuang.layer.borderColor = [UIColor whiteColor].CGColor;
    topKuang.layer.borderWidth = 1;
    topKuang.layer.cornerRadius = 25;
    [self.view addSubview:topKuang];
    [topKuang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_top).offset(40);
        make.left.equalTo(centerView.mas_left).offset(15);
        make.right.equalTo(centerView.mas_right).offset(-15);
        make.height.mas_equalTo(50);
        
    }];
    
    _accountTextfield = [[UITextField alloc]init];
    _accountTextfield.font = [UIFont systemFontOfSize:18];
    _accountTextfield.placeholder = @"ACCOUNT NAME/EMAL";
    _accountTextfield.tintColor = [UIColor whiteColor];
    _accountTextfield.textColor = [UIColor whiteColor];
    [_accountTextfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_accountTextfield];
    [_accountTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topKuang.mas_left).offset(15);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(topKuang.mas_top);
        make.height.mas_equalTo(50);
        
    }];
    
    UIView * downKuang = [[UIView alloc]init];
    downKuang.layer.borderWidth = 1;
    downKuang.layer.borderColor = [UIColor whiteColor].CGColor;
    downKuang.layer.cornerRadius = 25;
    [self.view addSubview:downKuang];
    [downKuang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topKuang.mas_bottom).offset(15);
        make.left.equalTo(centerView.mas_left).offset(15);
        make.right.equalTo(centerView.mas_right).offset(-15);
        make.height.mas_equalTo(50);

        
    }];
    
    
    
    
    
    
    
    
    
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}


@end
