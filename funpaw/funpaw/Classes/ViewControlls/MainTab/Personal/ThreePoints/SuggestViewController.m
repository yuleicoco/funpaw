//
//  SuggestViewController.m
//  petegg
//
//  Created by czx on 16/5/4.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "SuggestViewController.h"
#import "AFHttpClient+ChangepasswordAndBlacklist.h"

@interface SuggestViewController ()<UITextViewDelegate>
@property (nonatomic,strong)UITextView * topTextfield;
@property (nonatomic,strong)UITextField * downTextfield;
@property (nonatomic,strong)UILabel * placeholderLabel;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"Feedback"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)setupView{
    [super setupView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showBarButton:NAV_RIGHT title:@"Send" fontColor:[UIColor blackColor]];
    _topTextfield = [[UITextView alloc]initWithFrame:CGRectMake(20 * W_Wide_Zoom, 70 * W_Hight_Zoom, 335 * W_Wide_Zoom, 120 * W_Hight_Zoom)];
    _topTextfield.backgroundColor = LIGHT_GRAY_COLOR;
    _topTextfield.textAlignment = NSTextAlignmentLeft;
    _topTextfield.font = [UIFont systemFontOfSize:13];
    _topTextfield.delegate = self;
    [self.view addSubview:_topTextfield];
    
    
    _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 * W_Wide_Zoom, 68 * W_Hight_Zoom, 160 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
    _placeholderLabel.textColor = [UIColor grayColor];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.text = @"Please input feedback";
    _placeholderLabel.font = _topTextfield.font;
    _placeholderLabel.layer.cornerRadius = 5;
    [self.view addSubview:_placeholderLabel];
    
    UILabel * kuangLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * W_Wide_Zoom, 205 * W_Hight_Zoom, 315 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
    kuangLabel.layer.cornerRadius = 5;
    kuangLabel.backgroundColor = [UIColor whiteColor];
    kuangLabel.layer.borderWidth = 1;
    kuangLabel.layer.borderColor = LIGHT_GRAY_COLOR.CGColor;
    [self.view addSubview:kuangLabel];
    
    _downTextfield = [[UITextField alloc]initWithFrame:CGRectMake(35 * W_Wide_Zoom, 205 * W_Hight_Zoom, 315 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _downTextfield.placeholder = @"QQ, email or phone.";
    _downTextfield.font = [UIFont systemFontOfSize:13];
    _downTextfield.textColor = [UIColor blackColor];
    _downTextfield.tintColor = GREEN_COLOR;
    [self.view addSubview:_downTextfield];
    
    UILabel * tixingLabel = [[UILabel alloc]initWithFrame:CGRectMake(32 * W_Wide_Zoom, 240 * W_Hight_Zoom, 315 * W_Wide_Zoom, 60 * W_Hight_Zoom)];
    tixingLabel.text = @"Your contact will help us to communicate and solve the problem, only the staff can see!";
    tixingLabel.numberOfLines = 2;
    tixingLabel.textColor = [UIColor blackColor];
    tixingLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tixingLabel];
    
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeholderLabel.text = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (_topTextfield.text.length == 0) {
        _placeholderLabel.text = @"Please input feedback";
    }else{
        _placeholderLabel.text = @"";
    }


}


-(void)doRightButtonTouch{
    if ([AppUtil isBlankString:_topTextfield.text]) {
        [[AppUtil appTopViewController] showHint:@"Please input feedback"];
        return;
    }
    if ([AppUtil isBlankString:_downTextfield.text]) {
        [[AppUtil appTopViewController] showHint:@"Please input feedback"];
        return;
    }
    
    [self showHudInView:self.view hint:@"Sending..."];
    [[AFHttpClient sharedAFHttpClient]addFeedbackWithMid:[AccountManager sharedAccountManager].loginModel.mid fconcent:_topTextfield.text fphone:_downTextfield.text complete:^(BaseModel *model) {
        if (model) {
            [self hideHud];
            [[AppUtil appTopViewController] showHint:model.retDesc];
            [self.navigationController popViewControllerAnimated:YES];
        }else
            
        {
            
            [self hideHud];
        }
    }];
    





}



@end
