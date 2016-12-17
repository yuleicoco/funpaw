//
//  ChangePasswordViewController.m
//  petegg
//
//  Created by czx on 16/4/26.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "AFHttpClient+ChangepasswordAndBlacklist.h"
@interface ChangePasswordViewController ()

{
   NSString * str;
    
}
@property (nonatomic,strong)UITextField * oldPasswordTextfield;
@property (nonatomic,strong)UITextField * newpassWordTextfield;
@property (nonatomic,strong)UITextField * surePassworeTextfield;


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"Change Password"];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
-(void)setupView{
    [super  setupView];
    

    NSArray * nameArray = @[@"Old Password:",@"New Password:",@"Confirm Password:"];
    for (int i = 0 ; i < 3; i ++) {
        UILabel * lineLabeles = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 120 *W_Hight_Zoom + 60 * i * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        lineLabeles.backgroundColor = GRAY_COLOR;
        [self.view addSubview:lineLabeles];
        
        UILabel * nameLabeles = [[UILabel alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom, 75*W_Hight_Zoom + i * 60 * W_Hight_Zoom, 130 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        nameLabeles.text = nameArray[i];
        nameLabeles.font = [UIFont systemFontOfSize:13];
        nameLabeles.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:nameLabeles];

    }
    _oldPasswordTextfield = [[UITextField alloc]initWithFrame:CGRectMake(150 * W_Wide_Zoom, 75 * W_Hight_Zoom, 220 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _oldPasswordTextfield.font = [UIFont systemFontOfSize:13];
    _oldPasswordTextfield.placeholder = @"Please enter the old password";
    _oldPasswordTextfield.tintColor = GREEN_COLOR;
    [self.view addSubview:_oldPasswordTextfield];
    
    _newpassWordTextfield = [[UITextField alloc]initWithFrame:CGRectMake(150 * W_Wide_Zoom, 135 * W_Hight_Zoom, 220 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _newpassWordTextfield.font = [UIFont systemFontOfSize:13];
    _newpassWordTextfield.placeholder = @"Please enter a new password";
    _newpassWordTextfield.tintColor = GREEN_COLOR;
    [self.view addSubview:_newpassWordTextfield];
    
    _surePassworeTextfield = [[UITextField alloc]initWithFrame:CGRectMake(150 * W_Wide_Zoom, 195 * W_Hight_Zoom, 220 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _surePassworeTextfield.font = [UIFont systemFontOfSize:13];
    _surePassworeTextfield.placeholder = @"Please enter again to confirm ";
    _surePassworeTextfield.tintColor = GREEN_COLOR;
    [self.view addSubview:_surePassworeTextfield];

    
    UIButton * sureButton = [[UIButton alloc]initWithFrame:CGRectMake(87.5 * W_Wide_Zoom, 300 * W_Hight_Zoom, 200 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
    sureButton.backgroundColor = GREEN_COLOR;
    [sureButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    sureButton.layer.cornerRadius = 5;
    [self.view addSubview:sureButton];
    [sureButton addTarget:self action:@selector(sureButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setupData{
    [super  setupData];

}
-(void)sureButtonTouch{
    
    NSString * str2 = [AccountManager sharedAccountManager].loginModel.password;
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    NSString * str1 =  [user objectForKey:@"loginV"];
    
    if ([AppUtil isBlankString:str1]) {
        
        str = str2;
        
    }else
        
    {
        str = str1;
        
    }
    
    if (![_oldPasswordTextfield.text isEqualToString:str]) {
        [[AppUtil appTopViewController] showHint:@"The old password you entered is incorrect."];
        return;
    }
    if ([str isEqualToString:_newpassWordTextfield.text]) {
        [[AppUtil appTopViewController] showHint:@"The new password cannot be consistent with the old password"];
        return;
    }
    
    if (![_newpassWordTextfield.text isEqualToString:_surePassworeTextfield.text]) {
        [[AppUtil appTopViewController] showHint:@"Two input passwords are not consistent"];
        return;
    }
    
    if ([AppUtil isBlankString:_newpassWordTextfield.text]) {
        [[AppUtil appTopViewController] showHint:@"Please enter a new password"];
        return;
    }
    [self showHudInView:self.view hint:@"Being modified..."];
    [[AFHttpClient sharedAFHttpClient]modifyPasswordWithMid:[AccountManager sharedAccountManager].loginModel.mid password:_newpassWordTextfield.text complete:^(BaseModel *model) {
        [self hideHud];
        if (model) {
            NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:@"Change success, please relogin" preferredStyle:UIAlertControllerStyleAlert];
            [userDefatluts setObject:_newpassWordTextfield.text forKey:@"loginV"];
             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
                
                NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
                for(NSString* key in [dictionary allKeys]){
                    [userDefatluts removeObjectForKey:key];
                    [userDefatluts synchronize];
                }
                [userDefatluts setObject:@"1" forKey:@"STARTFLAG"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStateChange object:@NO];
                [[AccountManager sharedAccountManager]logout];
                
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [[AppUtil appTopViewController] showHint:model.retDesc];
            
        }
        
    }];


}

@end
