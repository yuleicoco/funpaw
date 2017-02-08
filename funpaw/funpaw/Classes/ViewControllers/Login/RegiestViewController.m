//
//  RegiestViewController.m
//  funpaw
//
//  Created by czx on 2017/2/8.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "RegiestViewController.h"

@interface RegiestViewController ()
@property (nonatomic,strong)UIButton * codeBtn;
@property (nonatomic,strong)UITextField * emailTextfield;
@property (nonatomic,strong)UITextField * codeTextfield;
@property (nonatomic,strong)UITextField * passwordTextfield;
@property (nonatomic,strong)UITextField * surePasswordfield;



@end

@implementation RegiestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"Sign Up"];
   // self.view.backgroundColor = LIGHT_GRAYdcdc_COLOR;
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
}

-(void)setupView{
    UIView * firstView = [[UIView alloc]init];
    firstView.backgroundColor = [UIColor whiteColor];
    firstView.layer.borderColor = [UIColor redColor].CGColor;
    firstView.layer.borderWidth = 1;
    firstView.layer.cornerRadius = 25;
    [self.view addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstView.superview).offset(15);
        make.right.equalTo(firstView.superview).offset(-15);
        make.top.equalTo(firstView.superview).offset(10);
        make.height.mas_equalTo(50);
        
    }];
    
    _emailTextfield = [[UITextField alloc]init];
    _emailTextfield.textColor =YELLOW_COLOR;
    _emailTextfield.tintColor = YELLOW_COLOR;
    _emailTextfield.placeholder = @"Enter your email";
    [_emailTextfield setValue:YELLOW_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _emailTextfield.font = [UIFont systemFontOfSize:18];
    [firstView addSubview:_emailTextfield];
    [_emailTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_emailTextfield.superview.mas_left).offset(10);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(48);
        make.centerY.mas_equalTo(_emailTextfield.superview.mas_centerY);
    }];
    

    _codeBtn = [[UIButton alloc]init];
    _codeBtn.backgroundColor = RGB(245, 145, 40);
    [_codeBtn setTitle:@"Send Code" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _codeBtn.titleLabel.numberOfLines = 2;
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _codeBtn.layer.cornerRadius = 22;
    [firstView addSubview:_codeBtn];
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_codeBtn.superview.mas_right).offset(-2.5);
        make.top.equalTo(_codeBtn.superview.mas_top).offset(2.5);
        make.bottom.equalTo(_codeBtn.superview.mas_bottom).offset(-2.5);
        make.width.mas_equalTo(65);
        
    }];
    
    UIView * secoendView = [[UIView alloc]init];
    secoendView.backgroundColor = [UIColor whiteColor];
    secoendView.layer.borderColor = [UIColor redColor].CGColor;
    secoendView.layer.borderWidth = 1;
    secoendView.layer.cornerRadius = 25;
    [self.view addSubview:secoendView];
    [secoendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secoendView.superview).offset(15);
        make.right.equalTo(secoendView.superview).offset(-15);
        make.top.equalTo(firstView.mas_bottom).offset(15);
        make.height.mas_equalTo(50);

    }];
    
    _codeTextfield = [[UITextField alloc]init];
    _codeTextfield.tintColor = YELLOW_COLOR;
    _codeTextfield.textColor = YELLOW_COLOR;
    _codeTextfield.placeholder = @"Enter your verification code";
    [_codeTextfield setValue:YELLOW_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _codeTextfield.font = [UIFont systemFontOfSize:18];
    [secoendView addSubview:_codeTextfield];
    [_codeTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_codeTextfield.superview.mas_left).offset(10);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(48);
        make.centerY.mas_equalTo(_codeTextfield.superview.mas_centerY);

    }];
    
    UIView * passView = [[UIView alloc]init];
    passView.backgroundColor =  [UIColor whiteColor];
    passView.layer.borderColor = [UIColor redColor].CGColor;
    passView.layer.borderWidth = 1;
    passView.layer.cornerRadius = 25;
    [self.view addSubview:passView];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passView.superview).offset(15);
        make.right.equalTo(passView.superview).offset(-15);
        make.top.equalTo(secoendView.mas_bottom).offset(15);
        make.height.mas_equalTo(50);

    }];
    
    _passwordTextfield = [[UITextField alloc]init];
    _passwordTextfield.tintColor = YELLOW_COLOR;
    _passwordTextfield.textColor = YELLOW_COLOR;
    _passwordTextfield.placeholder = @"Enter password(at least 6 digits)";
    [_passwordTextfield setValue:YELLOW_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    [passView addSubview:_passwordTextfield];
    [_passwordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_passwordTextfield.superview.mas_left).offset(10);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(48);
        make.centerY.mas_equalTo(_passwordTextfield.superview.mas_centerY);
        
    }];
    
    UIView * surepassView = [[UIView alloc]init];
    surepassView.backgroundColor = [UIColor whiteColor];
    surepassView.layer.borderWidth = 1;
    surepassView.layer.borderColor = [UIColor redColor].CGColor;
    surepassView.layer.cornerRadius = 25;
    [self.view addSubview:surepassView];
    [surepassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(surepassView.superview).offset(15);
        make.right.equalTo(surepassView.superview).offset(-15);
        make.top.equalTo(passView.mas_bottom).offset(15);
        make.height.mas_equalTo(50);

        
    }];
    
    _surePasswordfield = [[UITextField alloc]init];
    _surePasswordfield.textColor = YELLOW_COLOR;
    _surePasswordfield.tintColor = YELLOW_COLOR;
    _surePasswordfield.placeholder = @"Re-enter password";
    [_surePasswordfield setValue:YELLOW_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    [surepassView addSubview:_surePasswordfield];
    [_surePasswordfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_surePasswordfield.superview.mas_left).offset(10);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(48);
        make.centerY.mas_equalTo(_surePasswordfield.superview.mas_centerY);
    }];
    
    UIButton * registBtn = [[UIButton alloc]init];
    registBtn.backgroundColor = YELLOW_COLOR;
    [registBtn setTitle:@"Register" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registBtn.superview).offset(15);
        make.right.equalTo(registBtn.superview).offset(-15);
        make.top.equalTo(surepassView.mas_bottom).offset(25);
        make.height.mas_equalTo(50);


    }];
    
    
    
    
    
    
    
    
    
    




}



@end
