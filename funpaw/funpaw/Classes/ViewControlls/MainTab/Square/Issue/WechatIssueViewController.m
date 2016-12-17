//
//  WechatIssueViewController.m
//  petegg
//
//  Created by czx on 16/4/19.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "WechatIssueViewController.h"
#import "SCRecorder.h"
#import "SCRecordSessionManager.h"
#import "AFHttpClient+Issue.h"

@interface WechatIssueViewController ()<UITextViewDelegate>
@property (nonatomic,strong)SCPlayer *player;
@property (nonatomic,strong)UITextView * topTextView;
@property (nonatomic,strong)UILabel * placeholderLabel;
@property (nonatomic,strong)UIButton *releaseButton;
@end

@implementation WechatIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    _releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [_releaseButton setTitle:@"发布" forState:normal];
    [_releaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_releaseButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

}
-(void)setupView{
    [super setupView];
    [self setNavTitle:@"发布萌宠秀"];
    [self showBarButton:NAV_RIGHT title:@"发布" fontColor:[UIColor blackColor]];
    self.view.backgroundColor = LIGHT_GRAY_COLOR;

    _topTextView = [[UITextView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 60 * W_Hight_Zoom, 375 * W_Wide_Zoom, 150 * W_Hight_Zoom)];
    _topTextView.textAlignment = NSTextAlignmentLeft;
    _topTextView.backgroundColor = [UIColor whiteColor];
    _topTextView.delegate = self;
    _topTextView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_topTextView];

    
    _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 60 * W_Hight_Zoom, 100 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
    _placeholderLabel.textColor = [UIColor grayColor];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.text = @"请输入内容";
    _placeholderLabel.font = _topTextView.font;
    _placeholderLabel.layer.cornerRadius = 5;
    [self.view addSubview:_placeholderLabel];

    

    if ([_wechatOrziyuanku isEqualToString:@"wechat"]) {
        _player = [SCPlayer player];
        SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
        playerView.tag = 500;
        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        playerView.frame = CGRectMake(0 * W_Wide_Zoom, 210* W_Hight_Zoom, 150 * W_Wide_Zoom, 150 * W_Hight_Zoom);
        [self.view addSubview:playerView];
        _player.loopEnabled = YES;
        [_player setItemByUrl:self.urlstr];
        [_player play];
    }else if([_wechatOrziyuanku isEqualToString:@"ziyuankuship"]){
        NSLog(@"%@",_ziyuanshipArray);
        NSLog(@"%@",_thumbArry);
        NSString * imageStr = [_thumbArry componentsJoinedByString:@","];
        NSURL *imagUrl = [NSURL URLWithString:imageStr];
        UIImageView * image = [[UIImageView alloc]init];
        image.frame = CGRectMake(0 * W_Wide_Zoom, 210* W_Hight_Zoom, 150 * W_Wide_Zoom, 150 * W_Hight_Zoom);
        [image sd_setImageWithURL:imagUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
        [self.view addSubview:image];
    }else if ([_wechatOrziyuanku isEqualToString:@"tupianpian"]){
       
        for (int i = 0 ; i <  _imageArrayy.count; i++) {
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(12.5 * W_Wide_Zoom + 90 * i * W_Wide_Zoom , 210* W_Hight_Zoom, 80 * W_Wide_Zoom, 80 * W_Hight_Zoom)];
            [image sd_setImageWithURL:[NSURL URLWithString:_imageArrayy[i]] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
            
            [self.view addSubview:image];
            
        }

    }
    
}

-(void)doRightButtonTouch{

}

-(void)releaseInfo:(UIButton *)sender{
    if ([_wechatOrziyuanku isEqualToString:@"wechat"]) {
        sender.userInteractionEnabled = NO;
        [self wechatIssue];
    }else if([_wechatOrziyuanku isEqualToString:@"ziyuankuship"]){
        sender.userInteractionEnabled = NO;
        [self ziyuankuissue];
        
    }else if ([_wechatOrziyuanku isEqualToString:@"tupianpian"]){
        sender.userInteractionEnabled = NO;
        [self tupianpianfabu];
    }
}
-(void)tupianpianfabu{
    NSString * resouce = [_imageArrayy componentsJoinedByString:@","];
    NSMutableString * str = [NSMutableString stringWithString:resouce];
    [self showHudInView:self.view hint:@"正在发布..."];
    [[AFHttpClient sharedAFHttpClient]addSproutpetWithMid:[AccountManager sharedAccountManager].loginModel.mid content:_topTextView.text type:@"s" resources:str complete:^(BaseModel *model) {
        [self hideHud];
        if ([model.retCode isEqualToString:@"0000"]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxin" object:nil];
        _releaseButton.userInteractionEnabled = YES;
    }];
}
-(void)ziyuankuissue{
    NSString * thresouceStr = [[NSString alloc]init];
    thresouceStr  = [_thumbArry componentsJoinedByString:@","];
    NSString * shipresouce = [[NSString alloc]init];
    shipresouce = [_ziyuanshipArray componentsJoinedByString:@","];
    thresouceStr = [thresouceStr stringByAppendingString:@","];
    thresouceStr = [thresouceStr stringByAppendingString:shipresouce];
    NSMutableString * resoucesstr = [NSMutableString stringWithString:thresouceStr];
    
    [self showHudInView:self.view hint:@"正在发布..."];
    [[AFHttpClient sharedAFHttpClient]addSproutpetWithMid:[AccountManager sharedAccountManager].loginModel.mid content:_topTextView.text type:@"v" resources:resoucesstr complete:^(BaseModel *model) {
        [self hideHud];
        if ([model.retCode isEqualToString:@"0000"]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxin" object:nil];
        _releaseButton.userInteractionEnabled = YES;
    }];
}

-(void)wechatIssue{
    NSMutableString * resouceStr = [[NSMutableString alloc]init];
    [resouceStr appendString:@".mov,"];
    [resouceStr appendString:self.str];
    [self showHudInView:self.view hint:@"正在发布..."];
    [[AFHttpClient sharedAFHttpClient]addSproutpetWithMid:[AccountManager sharedAccountManager].loginModel.mid content:_topTextView.text type:@"pv" resources:resouceStr complete:^(BaseModel *model) {
        [self hideHud];
        if ([model.retCode isEqualToString:@"0000"]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxin" object:nil];
        _releaseButton.userInteractionEnabled = YES;
    }];
}


-(void)setupData{
    [super setupData];
    //播放小视频的窗口
   
    
}

-(void)doLeftButtonTouch{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有发布内容，是否要退出？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        // 点击按钮后的方法直接在这里面写
        [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeholderLabel.text = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (_topTextView.text.length == 0) {
        _placeholderLabel.text = @"请输入内容";
    }else{
        _placeholderLabel.text = @"";
    }
    
    
}


@end