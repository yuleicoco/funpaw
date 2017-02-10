//
//  EggViewController.m
//  funpaw
//
//  Created by czx on 2017/2/7.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "EggViewController.h"
#import "InCallViewController.h"
#import "HWWeakTimer.h"
#import "ShareWork+device.h"
#import "FeedViewController.h"
#import "UnbandViewController.h"
#import "WifiViewController.h"
#import "BindingViewController.h"


@interface EggViewController ()

{
    
    // 设备状态
    NSString *strState;
    
}
@end


@implementation EggViewController

@synthesize moveTimer;
@synthesize openVideoBtn;
@synthesize bgImage;
@synthesize addBtn;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"tabEgg_title",nil)];
    
    // sephone
 //   [SephoneManager addProxyConfig:[AccountManager sharedAccountManager].loginModel.sipno password:[AccountManager sharedAccountManager].loginModel.sippw domain:@"www.segosip001.cn"];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    //第一次用户接受
                }else{
                    //用户拒绝
                    return ;
                    
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
    
    
    
    //麦克风
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            
            // 用户同意获取麦克风
            NSLog(@"用户同意获取麦克风");
            
        } else {
            
            // 用户不同意获取麦克风
            NSLog(@"用户不同意");
            
        }
        
    }];
    
    

    
}


// 前
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    /*
     CGRect rectTab1 =  self.tabBarController.tabBar.frame;
     CGRect rectTab2  = self.navigationController.navigationBar.frame;
     CGRect  rectTab3 = [[UIApplication sharedApplication] statusBarFrame];
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdate:) name:kSephoneCallUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdate:) name:kSephoneRegistrationUpdate object:nil];
    
    // 检查设置状态
    moveTimer =[HWWeakTimer scheduledTimerWithTimeInterval:5.0 block:^(id userInfo) {
        [self checkDeviceStats];
    } userInfo:@"Fire" repeats:YES];
    [self checkDeviceStats];
 
    
}


/**
 通话状态处理
 
 @param notif se
 */
- (void)callUpdate:(NSNotification *)notif {
    SephoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    SephoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    
    switch (state) {
        case SephoneCallOutgoingInit:{
            // 成功
            InCallViewController *   _incallVC =[[InCallViewController alloc]init];
            
            [self presentViewController:_incallVC animated:YES completion:nil];
            break;
        }
            
        case SephoneCallStreamsRunning: {
            break;
        }
        case SephoneCallUpdatedByRemote: {
            break;
        }
            
        default:
            break;
    }
}



/**
  注册消息处理

 @param notif se
 */
- (void)registrationUpdate:(NSNotification *)notif {
    SephoneRegistrationState state = [[notif.userInfo objectForKey:@"state"] intValue];
    switch (state) {
            
        case SephoneRegistrationNone:
            
            NSLog(@"======开始");
            break;
        case SephoneRegistrationProgress:
            NSLog(@"=====注册进行");
            break;
        case SephoneRegistrationOk:
            
            NSLog(@"=======成功");
            break;
        case SephoneRegistrationCleared:
            break;
        case SephoneRegistrationFailed:
            NSLog(@"========OK 以外都是失败");
            break;
            
        default:
            break;
    }
    
}



// 后
- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSephoneCallUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kSephoneRegistrationUpdate object:nil];
    
    [moveTimer invalidate];
    
}



// 检查设备状态
- (void)checkDeviceStats
{
   //MI16090000013020
    [[ShareWork sharedManager]DeviceStats:@"MI17020000013124" complete:^(BaseModel * model) {
      
        if ([model.retCode isEqualToString:@"0000"]) {
            
            
            if ([AppUtil isBlankString:model.retVal[@"status"]]) {
                strState = [NSString stringWithFormat:@"%@",@"ds000"];
            }else{
                strState = [NSString stringWithFormat:@"%@",model.retVal[@"status"]];
            }
            
        }// 没有设备
        else if ([model.totalrecords isEqualToString:@"0"])
        {
            strState = [NSString stringWithFormat:@"%@",@"ds000"];
            
        }
        
       
        // 根据状态刷新UI
        
        [self UIchangeMothod];
        
    
        
    }];
    
    
    
    
}










// 数据

- (void)setupData
{
    [super setupData];
    NSLog(@"开始");
    
    
}


- (void)setupView
{
    [super setupView];
    
    [self showBarButton:NAV_RIGHT imageName:@"1"];
    
    
    // 背景图
    
    bgImage =[UIImageView new];
    [self.view addSubview:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
       // make.width.mas_equalTo(self.view.mas_width);
        make.top.equalTo(self.view.mas_top).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(49);
        make.right.left.equalTo(@0);
        
       
        
    }];
    
    // 添加按钮
    addBtn =[UIButton new];
    [addBtn setImage:[UIImage imageNamed:@"egg_add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(btn_add:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.size.mas_equalTo(CGSizeMake(90, 60));
         make.centerX.equalTo(self.view.mas_centerX);
         make.bottom.equalTo(self.view.mas_bottom).offset(-120);
        
        
        
    }];
    
    
    

    
    // 开启按钮
    openVideoBtn =[UIButton new];
    
    [openVideoBtn addTarget:self action:@selector(OpenVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openVideoBtn];
    
    [openVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view.mas_bottom).offset(-90);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        
    }];
    
    
    
    
    
    
    
    
    
}


// UI变化

-(void)UIchangeMothod
{
    // nodevice
    if ([strState isEqualToString:@"ds000"]) {
        
        [bgImage setImage:[UIImage imageNamed:@"English_tips"]];
        
    }
    
    
}

// +功能列表按钮
- (void)doRightButtonTouch
{
    

    
    
}


//绑定设备
-(void)btn_add:(UIButton *)sender
{
    
    BindingViewController * bindVC =[[BindingViewController alloc]init];
    [self.navigationController pushViewController:bindVC animated:NO];
    
    
}


// 设置选项
// wifi
- (void)wifiTouch:(UIButton *)sender
{
    WifiViewController * wifiVC =[[WifiViewController alloc]init];
    [self.navigationController pushViewController:wifiVC animated:NO];
    
    
    
}
//喂食
- (void)foodTouch:(UIButton *)sender
{
  
    FeedViewController * feedVc = [[FeedViewController alloc]init];
    [self.navigationController pushViewController:feedVc animated:NO];
    
    
    
}

// 解除绑定
- (void)bdinTouch:(UIButton *)sender
{
    
    UnbandViewController * bandVC =[[UnbandViewController alloc]init];
    [self.navigationController pushViewController:bandVC animated:NO];
    
    
    
}




/**
 开始视频

 @param sender btn
 */
- (void)OpenVideo:(UIButton *)sender
{
    
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Event Functions

//  call
/*
 @dialerNumber 别人的账号
 @sipName 自己的账号
 @ 视频通话
 */
- (void)sipCall:(NSString*)dialerNumber sipName:(NSString *)sipName
{
    
    NSString *  displayName  =nil;
    [[SephoneManager instance] call:dialerNumber displayName:displayName transfer:FALSE];
    
}


@end
