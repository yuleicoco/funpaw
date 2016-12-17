//
//  NewPremissViewController.m
//  petegg
//
//  Created by czx on 16/4/28.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "NewPremissViewController.h"
#import "ZdFriendViewController.h"
#import "AFHttpClient+PremissClient.h"
@interface NewPremissViewController ()
@property (nonatomic,strong)UITextField * ruleNameTextfield;
@property (nonatomic,strong)UITextField * priceTextfield;
@property (nonatomic,strong)UITextField * tsnumTextfield;
@property (nonatomic,strong)UIImageView * gouImage;
@property (nonatomic,strong)UIButton * allbodyBtn;
@property (nonatomic,strong)UIButton * friendBtn;
@property (nonatomic,strong)UIButton * zdBtn;




@end

@implementation NewPremissViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"新建访问规则"];
     self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
}
-(void)setupView{
    [super setupView];
    [self initChangeView];
}
-(void)initChangeView{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 64 * W_Hight_Zoom, 375 * W_Wide_Zoom, 150 * W_Hight_Zoom)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    NSArray * nameArray = @[@"规则名称:",@"访问定价:",@"访问投食:"];
    for (int i = 0 ; i < 3 ; i++ ) {
        UILabel * lineLabe = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom,  50 + i * 50 * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        lineLabe.backgroundColor = [UIColor lightGrayColor];
        lineLabe.alpha = 0.4;
        [topView addSubview:lineLabe];
        
        UILabel * nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(15 * W_Wide_Zoom, 15  + i * 50 * W_Hight_Zoom, 100 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        nameLabe.text = nameArray[i];
        nameLabe.textColor = [UIColor blackColor];
        nameLabe.font = [UIFont systemFontOfSize:14];
        [topView addSubview:nameLabe];
        
    }
    UILabel * rightLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(330 * W_Wide_Zoom,  65 * W_Hight_Zoom, 50 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
    rightLabel1.text = @"逗币";
    rightLabel1.textColor = [UIColor blackColor];
    rightLabel1.font = [UIFont systemFontOfSize:14];
    [topView addSubview:rightLabel1];
    
    UILabel * rightLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(330 * W_Wide_Zoom,  115 * W_Hight_Zoom, 50 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
    rightLabel2.text = @"次";
    rightLabel2.textColor = [UIColor blackColor];
    rightLabel2.font = [UIFont systemFontOfSize:14];
    [topView addSubview:rightLabel2];
    
    _ruleNameTextfield = [[UITextField alloc]initWithFrame:CGRectMake(100 * W_Wide_Zoom, 15 * W_Hight_Zoom, 200 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
    _ruleNameTextfield.tintColor = GREEN_COLOR;
    _ruleNameTextfield.placeholder = @"请输入规则名称";
    _ruleNameTextfield.font = [UIFont systemFontOfSize:14];
    [topView addSubview: _ruleNameTextfield];
    
    
    _priceTextfield = [[UITextField alloc]initWithFrame:CGRectMake(100 * W_Wide_Zoom, 65 * W_Hight_Zoom, 200 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
    _priceTextfield.tintColor = GREEN_COLOR;
    _priceTextfield.placeholder = @"请输入访问定价";
    _priceTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _priceTextfield.font = [UIFont systemFontOfSize:14];
    [topView addSubview: _priceTextfield];

    
    _tsnumTextfield = [[UITextField alloc]initWithFrame:CGRectMake(100 * W_Wide_Zoom, 115 * W_Hight_Zoom, 200 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
    _tsnumTextfield.tintColor = GREEN_COLOR;
    _tsnumTextfield.placeholder = @"请输入偷食数量";
    _tsnumTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _tsnumTextfield.font = [UIFont systemFontOfSize:14];
    [topView addSubview: _tsnumTextfield];
    
    UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 230 * W_Hight_Zoom, 375 * W_Wide_Zoom, 80 * W_Hight_Zoom)];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    
    UILabel * shezhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 * W_Wide_Zoom, 10 * W_Hight_Zoom, 200 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
    shezhiLabel.text = @"设置谁能访问我的设备:";
    shezhiLabel.textColor = [UIColor blackColor];
    shezhiLabel.font = [UIFont systemFontOfSize:14];
    [downView addSubview:shezhiLabel];
    
    
    
    _gouImage = [[UIImageView alloc]initWithFrame:CGRectMake(65 * W_Wide_Zoom , 11 * W_Hight_Zoom, 14 * W_Wide_Zoom, 14 * W_Hight_Zoom)];
    _gouImage.image = [UIImage imageNamed:@"xuan_guize.png"];
    
    _allbodyBtn = [[UIButton alloc]initWithFrame:CGRectMake(33.5 * W_Wide_Zoom, 40 * W_Hight_Zoom, 80 * W_Wide_Zoom, 25 * W_Hight_Zoom)];
    _allbodyBtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    [_allbodyBtn setTitle:@"所有人" forState:UIControlStateNormal];
    _allbodyBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [_allbodyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downView addSubview:_allbodyBtn];
    _allbodyBtn.selected = YES;
    [_allbodyBtn addSubview:_gouImage];
    [_allbodyBtn addTarget:self action:@selector(allButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _friendBtn = [[UIButton alloc]initWithFrame:CGRectMake(147 * W_Wide_Zoom, 40 * W_Hight_Zoom, 80 * W_Wide_Zoom, 25 * W_Hight_Zoom)];
    _friendBtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    [_friendBtn setTitle:@"好友" forState:UIControlStateNormal];
    _friendBtn.selected = NO;
    _friendBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [_friendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downView addSubview:_friendBtn];
    
    [_friendBtn addTarget:self action:@selector(friendButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    
    _zdBtn = [[UIButton alloc]initWithFrame:CGRectMake(260.5 * W_Wide_Zoom, 40 * W_Hight_Zoom, 80 * W_Wide_Zoom, 25 * W_Hight_Zoom)];
    _zdBtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    [_zdBtn setTitle:@"指定好友" forState:UIControlStateNormal];
    _zdBtn.selected = NO;
    _zdBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [_zdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downView addSubview:_zdBtn];
    [_zdBtn addTarget:self action:@selector(zdButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * sureButton = [[UIButton alloc]initWithFrame:CGRectMake(30 * W_Wide_Zoom, 400 * W_Hight_Zoom, 315 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
    sureButton.backgroundColor = GREEN_COLOR;
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 5;
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:sureButton];
    [sureButton addTarget:self action:@selector(setRuleButtonTOuch) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)setRuleButtonTOuch{
   
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSString * objectStr = @"";
    NSString * friendstr = @"";
    if (_allbodyBtn.selected == YES) {
        objectStr = @"all";
    }else if (_friendBtn.selected == YES){
        objectStr = @"friend";
    }else if (_zdBtn.selected == YES){
        objectStr = @"zd";
        NSUserDefaults * FriendUserDefaults = [NSUserDefaults standardUserDefaults];
        array  = [FriendUserDefaults objectForKey:@"friendesId"];
        friendstr =  [array componentsJoinedByString:@","];
        
    }
    [self showHudInView:self.view hint:@"正在创建..."];
    [[AFHttpClient sharedAFHttpClient]ruleSetWithMid:[AccountManager sharedAccountManager].loginModel.mid rulesname:_ruleNameTextfield.text object:objectStr friends:friendstr price:_priceTextfield.text tsnum:_tsnumTextfield.text complete:^(BaseModel *model) {
        [self hideHud];
        [[AppUtil appTopViewController] showHint:model.retDesc];
        [self.navigationController popViewControllerAnimated:YES];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"premissshuaxin" object:nil];
    }];

        

}





-(void)allButtonTouch{
    [_gouImage removeFromSuperview];
    [_allbodyBtn addSubview:_gouImage];
    _allbodyBtn.selected = YES;
    _friendBtn.selected = NO;
    _zdBtn.selected = NO;
    
    
}

-(void)friendButtonTouch{
    [_gouImage removeFromSuperview];
    [_friendBtn addSubview:_gouImage];
    _allbodyBtn.selected = NO;
    _friendBtn.selected = YES;
    _zdBtn.selected = NO;
}

-(void)zdButtonTouch{
    [_gouImage removeFromSuperview];
    [_zdBtn addSubview:_gouImage];
    _allbodyBtn.selected = NO;
    _friendBtn.selected = NO;
    _zdBtn.selected = YES;
    ZdFriendViewController * adVc = [[ZdFriendViewController alloc]init];
    [self.navigationController pushViewController:adVc animated:YES];
    
    
}




-(void)setupData{
    [super setupData];

}



@end
