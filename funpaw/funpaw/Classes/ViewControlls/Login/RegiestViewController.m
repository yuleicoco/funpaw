//
//  RegiestViewController.m
//  petegg
//
//  Created by czx on 16/4/5.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "RegiestViewController.h"
#import "CompletionViewController.h"
#import "AgreementViewController.h"
#import "UIView+TapBlocks.h"
#import "AFHttpClient+LoginAndRegister.h"

@interface RegiestViewController ()
{
    
    NSString * registCode;
    NSString * totalrecords;
    
}
@property (nonatomic,strong)UITextField * textFieldes;

//@property (nonatomic,strong)UIButton * securityButton;

@end

@implementation RegiestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
     [self setNavTitle: NSLocalizedString(@"regist", nil)];
    
}


- (void)setupView{
    
    [super setupView];
    
    NSArray * namearray = @[@"Email:", @"Password:"];
    NSArray * placeArray = @[@"Please enter your Email", @"Please enter a password"];
    
    for (int i = 0 ; i < namearray.count; i++ ) {
        
        UILabel * writingLabeles = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 70 * W_Hight_Zoom + 50 * W_Hight_Zoom * i, 80 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
        writingLabeles.text = namearray[i];
        writingLabeles.textAlignment = NSTextAlignmentRight;
        writingLabeles.font = [UIFont systemFontOfSize:15];
        writingLabeles.textColor = [UIColor blackColor];
        [self.view addSubview:writingLabeles];
        
        UILabel * lineLabeles = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 110 * W_Hight_Zoom + 50 * i * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        lineLabeles.backgroundColor = GRAY_COLOR;
        [self.view addSubview:lineLabeles];
        
        _textFieldes = [[UITextField alloc]initWithFrame:CGRectMake(90 * W_Wide_Zoom,  70 * W_Hight_Zoom + i * 50 * W_Hight_Zoom, 200 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
        _textFieldes.placeholder = placeArray[i];
        [_textFieldes setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
         // _textFieldes.secureTextEntry = YES;
        [_textFieldes setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _textFieldes.tag = i + 33;
        if (_textFieldes.tag == 33 ) {
            _textFieldes.keyboardType = UIKeyboardTypeEmailAddress;
        }
        
        if (_textFieldes.tag == 34 ) {
            _textFieldes.secureTextEntry = YES;
        }
        
        [self.view addSubview:_textFieldes];
        
    }
    
    for (NSInteger i = 0 ; i<1; i++) {
        UIButton * showBtn =[[UIButton alloc]initWithFrame:CGRectMake(320 * W_Wide_Zoom, 126 * W_Hight_Zoom +i*50 * W_Hight_Zoom, 18 * W_Wide_Zoom, 18 * W_Hight_Zoom)];
            [showBtn setImage:[UIImage imageNamed:@"showPs.png"] forState:UIControlStateNormal];
        [showBtn setImage:[UIImage imageNamed:@"noshowpass.png"] forState:UIControlStateSelected];
        showBtn.selected = YES;
            showBtn.tag = 1000 +i;
        [showBtn addTarget:self action:@selector(showPs:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:showBtn];
    }
    
    
//    _securityButton = [[UIButton alloc]initWithFrame:CGRectMake(250 * W_Wide_Zoom, 120 * W_Hight_Zoom, 110 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
//    _securityButton.backgroundColor = GREEN_COLOR;
//    [_securityButton setTitle:@"Get verify code" forState:UIControlStateNormal];
//    _securityButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    _securityButton.layer.cornerRadius = 5;
//    [_securityButton addTarget:self action:@selector(passwordCode:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_securityButton];
    
    
    
    //注册
    
    UIButton * registBtn =[[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 250 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    registBtn.backgroundColor =GREEN_COLOR;
    registBtn.layer.cornerRadius =  6;
    registBtn.tag = 10000;
    registBtn.center = self.view.center;
    [registBtn setTitle:@"Register" forState:UIControlStateNormal];
    registBtn.titleLabel.font =[UIFont systemFontOfSize:16];
    [registBtn addTarget:self action:@selector(registBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    
    UILabel * labelXieyi =[[UILabel alloc]initWithFrame:CGRectMake(62.5 * W_Wide_Zoom, 360 * W_Hight_Zoom, 250 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    labelXieyi.numberOfLines = 0;
    labelXieyi.font =[UIFont systemFontOfSize:12];
    [self.view addSubview:labelXieyi];
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"Click on the 'Register' button on behalf of the read and agree Registration Agreement"];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[attriString.string rangeOfString:@"Registration Agreement"]];
    labelXieyi.attributedText = attriString;
    labelXieyi.userInteractionEnabled = YES;
    
    [labelXieyi addTapGestureWithBlock:^{
        [self zhuceixiyi];
    }];
    
//    UIButton * xieyiBtn =[[UIButton alloc]initWithFrame:CGRectMake(270 * W_Wide_Zoom, 360 * W_Hight_Zoom, 100 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
//    [xieyiBtn setTitle:@"Agreement" forState:UIControlStateNormal];
//    xieyiBtn.titleLabel.font =[UIFont systemFontOfSize:12];
//    [xieyiBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [xieyiBtn addTarget:self action:@selector(zhuceixiyi) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:xieyiBtn];
//    
}


/**
 *  注册协议
 */

- (void)zhuceixiyi
{
    
    AgreementViewController * agreeVC =[[AgreementViewController alloc]init];
    [self.navigationController pushViewController:agreeVC animated:YES];
    
    
}

- (void)setupData
{
    [super setupData];
    
    
}



/**
 *   验证码
 */


//- (void)passwordCode:(UIButton *)sender
//{
//    UITextField * text =  (UITextField *)[self.view viewWithTag:33];
//    if ([AppUtil isBlankString:text.text]) {
//        [[AppUtil appTopViewController] showHint:@"Please enter your Email"];
//        return;
//    }
//    if (![AppUtil isValidateMobile:text.text]) {
//        [[AppUtil appTopViewController] showHint:@"Please enter the correct format of Email"];
//        return;
//    }
//    
////    [self proveCode];
//    
//    
//    
//}



/**
 *  注册
 */


- (void)registBtn:(UIButton *)sender
{
   
     UITextField * text =  (UITextField *)[self.view viewWithTag:33];
     UITextField * text1 =  (UITextField *)[self.view viewWithTag:34];
//     UITextField * text2 =  (UITextField *)[self.view viewWithTag:35];
//     UITextField * text3 =  (UITextField *)[self.view viewWithTag:36];
    
    if ([AppUtil isBlankString:text.text]) {
        [[AppUtil appTopViewController] showHint:@"Please enter your Email"];
        return;
    }
    if (![AppUtil isValidateEmail:text.text]) {
        [[AppUtil appTopViewController] showHint:@"Email format is not correct"];
        return;
    }
//    if ([AppUtil isBlankString:text1.text]) {
//        [[AppUtil appTopViewController] showHint:@"Please enter the verification code"];
//        return;
//    }
    if ([AppUtil isBlankString:text1.text]) {
        [[AppUtil appTopViewController] showHint:@"Please enter a password"];
        return;
    }
//    if (![text2.text isEqualToString:text3.text]) {
//        [[AppUtil appTopViewController] showHint:@"Two input passwords are not consistent"];
//        return;
//    }
//    if (![text1.text isEqualToString:registCode]) {
//        [[AppUtil appTopViewController] showHint:@"Please enter the correct verification code"];
//        return;
//    }
//    
//    if (![text.text isEqualToString:totalrecords]) {
//        [[AppUtil appTopViewController] showHint:@"Cell phone number error"];
//        return;
//    }

    [self showHudInView:self.view hint:@"Registering"];
    
    [[AFHttpClient sharedAFHttpClient] registerWithEmail:text.text password:text1.text complete:^(BaseModel *model) {
        
        [self hideHud];
        
        if (model) {
//            [[AppUtil appTopViewController]showHint:@"Registration is successful, please go to email activation"];
//            [self.navigationController popViewControllerAnimated:YES];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Tip" message:@"Registration is successful, please go to email to activate" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        
        }
    }];

    
}

/**
 *  密码显示
 */

- (void)showPs:(UIButton *)sender {

    
    UIButton * btn1 = (UIButton *)[self.view viewWithTag:1000];
//    UIButton * btn2 = (UIButton *)[self.view viewWithTag:1001];
    UITextField * textFL =(UITextField *)[self.view viewWithTag:34];
//    UITextField * textFL2 =(UITextField *)[self.view viewWithTag:36];
    btn1.selected = !btn1.selected;
//    btn2.selected = !btn2.selected;
    
    if (sender.selected == YES) {
        textFL.secureTextEntry = YES;
//        textFL2.secureTextEntry = YES;
    }else{
        textFL.secureTextEntry = NO;
//        textFL2.secureTextEntry = NO;
    }
   
    
    
    
}


/**
 *  验证码
 */

//- (void)proveCode
//{
//    
//    UITextField * text =  (UITextField *)[self.view viewWithTag:33];
//    NSString * str =@"clientAction.do?method=json&classes=appinterface&common=check";
//    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
//    [dic setValue:text.text forKey:@"phone"];
//    [dic setValue:@"register" forKey:@"type"];
//    
//    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
//        
//        if ([json[@"jsondata"][@"retCode"] isEqualToString:@"0000"]) {
//            registCode =json[@"jsondata"][@"content"];
//            totalrecords = json[@"jsondata"][@"totalrecords"];
////             [self timeout];
//        }else{
//            NSString * str =[NSString stringWithFormat:@"%@",json[@"jsondata"][@"retDesc"]];
//            UIButton * btn =  (UIButton *)[self.view viewWithTag:10000];
//            btn.enabled = NO;
//             [[AppUtil appTopViewController] showHint:str];
//           // [self showSuccessHudWithHint:str];
//            
//        }
////        if ([json[@"jsondata"][@"retDesc"] isEqualToString:@"此手机号码已注册"]) {
////          
////            
////        }
//          } failure:^(NSError *error) {
//    }];
//    
//}


/**
 *  显示
 */
//- (void)timeout
//{
//    
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
//                NSLog(@"————————%@",strTime);
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

@end

