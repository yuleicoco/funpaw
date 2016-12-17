//
//  ReportViewController.m
//  petegg
//
//  Created by czx on 16/5/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "ReportViewController.h"
#import "AFHttpClient+ChangepasswordAndBlacklist.h"
#import "JubaoxuzhiViewController.h"

@interface ReportViewController ()
@property (nonatomic,strong)UIButton *button1;
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong)NSMutableString * dongdongstr;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"举报"];
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    [self showBarButton:NAV_RIGHT title:@"提交" fontColor:[UIColor blackColor]];
}
-(void)setupView{
    [super setupView];
    self.datas =[[NSMutableArray alloc]initWithObjects:@"色情低俗",@"广告骚扰",@"诱导分享",@"谣言",@"政治敏感",@"违法(暴力恐怖，违禁品等)",@"其他(收集隐私信息等)",nil];
    for (int i = 0 ; i < 7 ; i++) {
        UIButton * touchBtn = [[UIButton alloc]initWithFrame:CGRectMake(30 * W_Wide_Zoom, 80 * W_Hight_Zoom + i * 30 * W_Hight_Zoom, 15 * W_Wide_Zoom, 15 * W_Hight_Zoom)];
        [touchBtn setImage:[UIImage imageNamed:@"quan_guize.png"] forState:UIControlStateNormal];
        [touchBtn setImage:[UIImage imageNamed:@"xuanquan_guize.png"] forState:UIControlStateSelected];
        touchBtn.tag = 900001 + i;
        [touchBtn addTarget:self action:@selector(gogogogogo:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:touchBtn];
        
        UILabel * labels = [[UILabel alloc]initWithFrame:CGRectMake(70 * W_Wide_Zoom, 73 * W_Hight_Zoom + i * 30 * W_Hight_Zoom, 280 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        labels.text = self.datas[i];
        labels.font = [UIFont systemFontOfSize:13];
        labels.textColor = [UIColor blackColor];
        [self.view addSubview:labels];
    }

    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20 * W_Wide_Zoom, 300 * W_Hight_Zoom, 335 * W_Wide_Zoom, 150 * W_Hight_Zoom)];
    _textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
    
    UIButton * jubaoxuzhiBtn = [[UIButton alloc]initWithFrame:CGRectMake(137.5 * W_Wide_Zoom, 500 * W_Hight_Zoom, 100 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    [jubaoxuzhiBtn setTitle:@"举报须知" forState:UIControlStateNormal];
    [jubaoxuzhiBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    jubaoxuzhiBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:jubaoxuzhiBtn];
    
    [jubaoxuzhiBtn addTarget:self action:@selector(jubaoxuzhiButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)jubaoxuzhiButtonTouch{
    JubaoxuzhiViewController * jubao = [[JubaoxuzhiViewController alloc]init];
    [self.navigationController pushViewController:jubao animated:YES];


}




-(void)gogogogogo:(UIButton *)sender{
    for (int i=0; i<self.datas.count; i++) {
        
        _button1 = (UIButton *)[self.view viewWithTag:i+900001];
        
        if (_button1.tag == sender.tag) {
            _dongdongstr = self.datas[_button1.tag-900001];
            _button1.selected = YES;
        }else {
            _button1.selected = NO;
        }
        
    }
}

-(void)doRightButtonTouch{
    if (!_button1.tag) {
        [[AppUtil appTopViewController] showHint:@"您还没有勾选"];
        return;
    }
    
   // NSLog(@"%@",_dongdongstr);

    [[AFHttpClient sharedAFHttpClient]addreportWithMid:[AccountManager sharedAccountManager].loginModel.mid stid:self.stid content:_textView.text reporttype:_dongdongstr objtype:@"m" complete:^(BaseModel *model) {
        if (model) {
             [[AppUtil appTopViewController] showHint:model.retDesc];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
             [[AppUtil appTopViewController] showHint:model.retDesc];
        }
        
    }];
    

}






@end
