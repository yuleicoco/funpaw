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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    




}



@end
