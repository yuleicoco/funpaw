//
//  EggViewController.m
//  petegg
//
//  Created by ldp on 16/3/14.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "EggViewController.h"
#import "InCallViewController.h"
#import "SettingViewController.h"
#import "SephoneManager.h"

@interface EggViewController ()
{
    NSString * _equipmentStateArr;
    UIImageView * _noDeviceImageView;
    UIImageView * _yesDeviceImageView;
    BOOL _isOpen;
    UIButton * _openButton;
    InCallViewController * _incallVC;
    
    
}
@end

@implementation EggViewController
@synthesize _appdelegate;
@synthesize otherArr;


- (void)viewDidLoad{
    [super viewDidLoad];
 
    [self setNavTitle: @"Device"];
    
    UIButton * btnFb2 =[UIButton buttonWithType:UIButtonTypeCustom];
    btnFb2.frame=CGRectMake(0, 0, 18, 18) ;
    [btnFb2 setImage:[UIImage imageNamed:@"new_egg_seting.png"] forState:UIControlStateNormal];
    [btnFb2 addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * settings =[[UIBarButtonItem alloc]initWithCustomView:btnFb2];
    self.navigationItem.rightBarButtonItem = settings;
    
    otherArr =[[NSMutableArray alloc]init];
    
    // sip登陆。
    
    [SephoneManager addProxyConfig:[AccountManager sharedAccountManager].loginModel.sipno password:[AccountManager sharedAccountManager].loginModel.sippw domain:@"www.segosip001.cn"];
    
    
    NSLog(@"====%@======%@",[AccountManager sharedAccountManager].loginModel.sipno,[AccountManager sharedAccountManager].loginModel.sippw);
    
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    //第一次用户接受
                }else{
                    //用户拒绝
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

// 设置
- (void)settings:(UIButton *)sender
{
    SettingViewController * setVC =[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:setVC animated:YES];
    
    
}


/**
 *  通知  内存 处理
 *
 *  @param animated diss
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super  viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdate:) name:kSephoneCallUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdate:) name:kSephoneRegistrationUpdate object:nil];
    
     [self equipmentState];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kSephoneCallUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kSephoneRegistrationUpdate object:nil];
    
    
}


// 注册消息处理
- (void)registrationUpdate:(NSNotification *)notif {
    SephoneRegistrationState state = [[notif.userInfo objectForKey:@"state"] intValue];
    SephoneProxyConfig *cfg = [[notif.userInfo objectForKey:@"cfg"] pointerValue];
    // Only report bad credential issue
    
    
    

    
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
            NSLog(@"======注销成功");
            break;
        case SephoneRegistrationFailed:
            NSLog(@"========OK 以外都是失败");
            break;
            
        default:
            break;
    }
    
}


// 通话状态处理
- (void)callUpdate:(NSNotification *)notif {
    SephoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    SephoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];

    switch (state) {
        case SephoneCallOutgoingInit:{
            // 成功
            _incallVC =[[InCallViewController alloc]initWithNibName:@"InCallViewController" bundle:nil];
            [_incallVC setCall:call];
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


// 判断用户有没有绑定设备
- (void)equipmentState
{
   
    _appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    
    NSString * str =[AccountManager sharedAccountManager].loginModel.deviceno;
    
    NSString * devo  = [defaults objectForKey:PREF_DEVICE_NUMBER];
 
    
    if ([AppUtil isBlankString:str]) {
        if ([AppUtil isBlankString:devo]) {
            self.view.backgroundColor =[UIColor lightGrayColor];
            [_noDeviceImageView removeFromSuperview];
            // 没有绑定
            [_openButton removeFromSuperview];
            _noDeviceImageView =[[UIImageView alloc]initWithFrame:CGRectMake(50, 64, 280*W_Wide_Zoom, 400*W_Hight_Zoom)];
            [_yesDeviceImageView removeFromSuperview];
            _noDeviceImageView.image =[UIImage imageNamed:@"noDevice.png"];
            [self.view addSubview:_noDeviceImageView];
            
        }else{
            [self queryDeviceState];
        }
        
    }
    else
    {
        self.view.backgroundColor =[UIColor whiteColor];
        //  设置界面
        [self queryDeviceState];
        
    }

    
    
}


//查询绑定设备的状态
- (void)queryDeviceState
{
    
    /**
     *  @DEVICE_NUMBER:这个是用户去绑定设备得到的设备号
     *  @devicenumber:这个是用户登录进来就有的设备号
     */
    
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    NSString * bangdinDevico = [defaults objectForKey:PREF_DEVICE_NUMBER];
    NSString * mid =[AccountManager sharedAccountManager].loginModel.mid;
    NSString * devico =[AccountManager sharedAccountManager].loginModel.deviceno;
    
   NSString * service = @"clientAction.do?common=queryDeviceStatus&classes=appinterface&method=json";
    
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"a" forKey:@"quantity"];
    
    if ([AppUtil isBlankString:devico]) {
        
        [dic setValue:bangdinDevico forKey:@"deviceno"];
        [dic setValue:mid forKey:@"mid"];
    }else
    {
        
        // 查询设备状态   // 代码可以优化（先把功能做了）
        
        [dic setValue:devico forKey:@"deviceno"];
        [dic setValue:mid forKey:@"mid"];
        
    }
    
    [AFNetWorking postWithApi:service parameters:dic success:^(id json) {
        if ([json[@"jsondata"][@"retCode"] isEqualToString:@"0000"]) {
            
            _equipmentStateArr =json[@"jsondata"][@"retVal"][@"status"];
            [self UIinitUseface:_equipmentStateArr];
    
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        
        
    }];
    
    
    
}

- (void)UIinitUseface:(NSString *)status
{
    _yesDeviceImageView.image = nil;
    self.view.backgroundColor =[UIColor whiteColor];

    _yesDeviceImageView =[[UIImageView alloc]initWithFrame:CGRectMake(35*W_Wide_Zoom, 90*W_Hight_Zoom, 300*W_Wide_Zoom, 300*W_Hight_Zoom)];
    
    if ([status isEqualToString:@"ds001"]) {
        // 在线
        _yesDeviceImageView.image =[UIImage imageNamed:@"egg_online.png"];
        _isOpen = YES;
        [self buttonOpen];
    }
    else if ([status isEqualToString:@"ds003"]) {
        //通话
        _yesDeviceImageView.image =[UIImage imageNamed:@"egg_calling.png"];
        [self buttonOpen];
        
    }
    else if ([status isEqualToString:@"ds004"]) {
        //正在上传
        _yesDeviceImageView.image =[UIImage imageNamed:@"egg_upload.png"];
        [self buttonOpen];
        
    }else if([status isEqualToString:@"ds000"])
    {
        // 设备不存在
        _yesDeviceImageView.image =[UIImage imageNamed:@"egg_offline.png"];
        [_noDeviceImageView removeFromSuperview];
        
        
    }
    else {
        // 离线
        _yesDeviceImageView.image =[UIImage imageNamed:@"egg_offline.png"];
        [_noDeviceImageView removeFromSuperview];
        
    }
    [self.view addSubview:_yesDeviceImageView];
    
}

- (void)buttonOpen
{
    [_noDeviceImageView removeFromSuperview];
    [_openButton removeFromSuperview];
    _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_openButton setTitle:NSLocalizedString(@"openButton", nil) forState:UIControlStateNormal];
    [_openButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _openButton.tag = 410925;
    _openButton.titleLabel.font =[UIFont systemFontOfSize:13];
    _openButton.userInteractionEnabled = YES;
    _openButton.layer.borderWidth=0.8;
    _openButton.layer.borderColor =AllBackColor.CGColor;
    [_openButton.layer setMasksToBounds:YES];
    [_openButton.layer setCornerRadius:5.0];
    [_openButton addTarget:self action:@selector(btn_set:) forControlEvents:UIControlEventTouchUpInside];
    _openButton.frame = CGRectMake(70*W_Wide_Zoom, 420*W_Hight_Zoom, 240*W_Wide_Zoom, 40*W_Hight_Zoom);
    [self.view addSubview:_openButton];
}

// 点击开启视频按钮
- (void)btn_set:(UIButton * )sender
{
    
    
    if (_isOpen) {
        
        _isOpen = NO;
        /**
         *   这里做一个模拟延迟的菊花 提高用户体验
         */
        
        //时间
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
    
        
        NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
        // 使用记录
        NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
        // 自己开
        [dic setValue:@"self" forKey:@"object"];
        NSString * devicLg =[AccountManager sharedAccountManager].loginModel.deviceno;
        NSString * mid =[AccountManager sharedAccountManager].loginModel.mid;
        NSString * devico1 =[defaults objectForKey:PREF_DEVICE_NUMBER];
        
        if ([AppUtil isBlankString:devicLg]) {
            [self sipCall:devico1 sipName:nil];
             [dic setValue:devico1 forKey:@"deviceno"];
            
        }else
        {
            [self sipCall:devicLg sipName:nil];
            [dic setValue:devicLg forKey:@"deviceno"];

        }
        [dic setValue:mid forKey:@"belong"];
        [dic setValue:mid forKey:@"mid"];
        [dic setValue:locationString forKey:@"starttime"];
        [dic setValue:@"0" forKey:@"consumption"];
        
        NSString * str =@"clientAction.do?common=addDeviceUseRecord&classes=appinterface&method=json";
        
        [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
            _isOpen = YES;
            NSString * buildID = json[@"jsondata"][@"content"];
            [defaults setValue:buildID forKey:@"otherbuildIDS"];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    }else
    {
        // 测试
    
        
    }
    
    
    
}

#pragma mark - Event Functions

//  call
//
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
