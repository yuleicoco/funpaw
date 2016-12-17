//
//  ReDataViewController.m
//  petegg
//
//  Created by czx on 16/4/5.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "ReDataViewController.h"

@interface ReDataViewController ()
@property (nonatomic,strong)UITextField * textFieldes;
//@property (nonatomic,strong)UIButton * securityButton;
@property (nonatomic,strong)NSString * registCode;
@end

@implementation ReDataViewController
{
     NSString * totalrecords;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"Forget Password"];

}
-(void)setupView{
    [super setupView];
    NSArray * namearray = @[@"Email:"];
    NSArray * placeArray = @[@"Please enter your email"];
    
    for (int i = 0 ; i < namearray.count; i++ ) {
        
        UILabel * writingLabeles = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 70 * W_Hight_Zoom + 50 * W_Hight_Zoom * i, 70 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
        writingLabeles.text = namearray[i];
        writingLabeles.textAlignment = NSTextAlignmentRight;
        writingLabeles.font = [UIFont systemFontOfSize:15];
        writingLabeles.textColor = [UIColor blackColor];
        [self.view addSubview:writingLabeles];
        
        UILabel * lineLabeles = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 110 * W_Hight_Zoom + 50 * i * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        lineLabeles.backgroundColor = GRAY_COLOR;
        [self.view addSubview:lineLabeles];
//        
        _textFieldes = [[UITextField alloc]initWithFrame:CGRectMake(90 * W_Wide_Zoom,  70 * W_Hight_Zoom + i * 50 * W_Hight_Zoom, 200 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
        _textFieldes.placeholder = placeArray[i];
        [_textFieldes setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [_textFieldes setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _textFieldes.tag = i + 36;
//        if (_textFieldes.tag == 36 || _textFieldes.tag == 37) {
            _textFieldes.keyboardType = UIKeyboardTypeEmailAddress;
//        }
        
        
//        if (_textFieldes.tag == 38 || _textFieldes.tag == 39) {
//            _textFieldes.secureTextEntry = YES;
//        }
        
        [self.view addSubview:_textFieldes];
        
    }

    
//    _securityButton = [[UIButton alloc]initWithFrame:CGRectMake(250 * W_Wide_Zoom, 120 * W_Hight_Zoom, 110 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
//    _securityButton.backgroundColor = GREEN_COLOR;
//    [_securityButton setTitle:@"Get verification code" forState:UIControlStateNormal];
//    _securityButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    _securityButton.layer.cornerRadius = 5;
//    [_securityButton addTarget:self action:@selector(passwordCode:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_securityButton];
//    
//    
//    for (NSInteger i = 0 ; i<2; i++) {
//        UIButton * showBtn =[[UIButton alloc]initWithFrame:CGRectMake(320 * W_Wide_Zoom, 176 * W_Hight_Zoom +i*50 * W_Hight_Zoom, 18 * W_Wide_Zoom, 18 * W_Hight_Zoom)];
//        [showBtn setImage:[UIImage imageNamed:@"showPs.png"] forState:UIControlStateNormal];
//        [showBtn setImage:[UIImage imageNamed:@"noshowpass.png"] forState:UIControlStateSelected];
//        showBtn.selected = YES;
//        showBtn.tag = 1200 +i;
//        [showBtn addTarget:self action:@selector(showPs:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:showBtn];
//        
//        
//    }
    
    //完成
    UIButton * registBtn =[[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 250 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    registBtn.backgroundColor =GREEN_COLOR;
    registBtn.layer.cornerRadius =  6;
    registBtn.tag = 10000;
    registBtn.center = self.view.center;
    [registBtn setTitle:@"Complete" forState:UIControlStateNormal];
    registBtn.titleLabel.font =[UIFont systemFontOfSize:16];
    [registBtn addTarget:self action:@selector(registBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
}

//-(void)showPs:(UIButton *)sender{
//    UITextField * text2 =  (UITextField *)[self.view viewWithTag:38];
//    UITextField * text3 =  (UITextField *)[self.view viewWithTag:39];
//    
//    UIButton * btn1 = (UIButton *)[self.view viewWithTag:1200];
//    UIButton * btn2 = (UIButton *)[self.view viewWithTag:1201];
//    
//    btn1.selected = !btn1.selected;
//    btn2.selected = !btn2.selected;
//
//    if (sender.selected == YES) {
//        text2.secureTextEntry = YES;
//        text3.secureTextEntry = YES;
//    }else{
//        text2.secureTextEntry = NO;
//        text3.secureTextEntry = NO;
//    }
//}


-(void)setupData{
    [super setupData];
}


- (void)registBtn:(UIButton *)sender
{
    UITextField * text =  (UITextField *)[self.view viewWithTag:36];
//    UITextField * text1 =  (UITextField *)[self.view viewWithTag:37];
//    UITextField * text2 =  (UITextField *)[self.view viewWithTag:38];
//    UITextField * text3 =  (UITextField *)[self.view viewWithTag:39];
    if ([AppUtil isBlankString:text.text]) {
        [[AppUtil appTopViewController] showHint:@"Please enter your email"];
        return;
    }
    
    if (![AppUtil isValidateEmail:text.text]) {
        [[AppUtil appTopViewController] showHint:@"Please enter the email in the correct format."];
        return;
    }
//    if ([AppUtil isBlankString:text1.text]) {
//        [[AppUtil appTopViewController] showHint:@"Please enter the verification code"];
//        return;
//    }
//    if ([AppUtil isBlankString:text2.text]) {
//        [[AppUtil appTopViewController] showHint:@"Please enter a password"];
//        return;
//    }
//    if (![text2.text isEqualToString:text3.text]) {
//        [[AppUtil appTopViewController] showHint:@"The password you entered is not consistent for the two time."];
//        return;
//    }
//    
//    if (![text1.text isEqualToString:_registCode]) {
//        [[AppUtil appTopViewController] showHint:@"Please enter the correct verification code"];
//        return;
//    }
//    
//    if (![text.text isEqualToString:totalrecords]) {
//        [[AppUtil appTopViewController] showHint:@"Cell phone number error"];
//        return;
//    }

    
    
    [self showHudInView:self.view hint:@"Being modified..."];
    
    NSString * str =@"clientAction.do?method=json&classes=appinterface&common=forgetPassword";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    [dic setValue:text.text forKey:@"email"];
    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
        [self hideHud];
        if ([json[@"jsondata"][@"retCode"] isEqualToString:@"0000"]) {
            [[AppUtil appTopViewController] showHint:@"Send reset password message successfully"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
             [[AppUtil appTopViewController] showHint:json[@"jsondata"][@"retDesc"]];
        }
        NSLog(@"====%@",json);
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}



//- (void)passwordCode:(UIButton *)sender
//{
//    UITextField * text =  (UITextField *)[self.view viewWithTag:36];
//    if ([AppUtil isBlankString:text.text]) {
//        [[AppUtil appTopViewController] showHint:@"Please enter your account number"];
//        return;
//    }
//    if (![AppUtil isValidateMobile:text.text]) {
//        [[AppUtil appTopViewController] showHint:@"Please enter the phone number in the correct format."];
//        return;
//    }
//    [self proveCode];
    
    
    
//}

//-(void)timeOut{
//    __block int timeout=60; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);     dispatch_source_set_event_handler(_timer, ^{
//        if(timeout<=0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_securityButton setTitle:@"Send verification code" forState:UIControlStateNormal];
//                _securityButton.userInteractionEnabled = YES;
//                _securityButton.backgroundColor = GREEN_COLOR;
//            });
//        }else{
//            int seconds = timeout % 60;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //  NSLog(@"————————%@",strTime);
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationDuration:1];
//                [_securityButton setTitle:[NSString stringWithFormat:@"%@ sec to send back",strTime] forState:UIControlStateNormal];
//                [UIView commitAnimations];
//                _securityButton.userInteractionEnabled = NO;
//                _securityButton.backgroundColor = [UIColor grayColor];
//            });
//            timeout--;
//        }
//    });
//    dispatch_resume(_timer);
//
//}





//- (void)proveCode
//{
//    UITextField * text =  (UITextField *)[self.view viewWithTag:36];
//    
//    
//    
//    NSString * str =@"clientAction.do?method=json&classes=appinterface&common=check";
//    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
//    [dic setValue:text.text forKey:@"phone"];
//    [dic setValue:@"modifypassword" forKey:@"type"];
//    
//    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
//        
//        if ([json[@"jsondata"][@"retCode"] isEqualToString:@"0000"]) {
//            _registCode =json[@"jsondata"][@"content"];
//            totalrecords = json[@"jsondata"][@"totalrecords"];
//            [self timeOut];
//        }else{
//            [[AppUtil appTopViewController] showHint:json[@"jsondata"][@"retDesc"]];
//            UIButton * btn =  (UIButton *)[self.view viewWithTag:10000];
//            btn.enabled = NO;
//        }
//        
//        
//    } failure:^(NSError *error) {
//    }];
//    
//}




@end
