//
//  InCallViewController.m
//  petegg
//
//  Created by yulei on 16/3/21.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "InCallViewController.h"
#import "SettingViewController.h"
#import "HWWeakTimer.h"

@import CoreTelephony;

@interface InCallViewController ()

{
    NSTimer *updateTimer;
    NSTimer *hideControlsTimer;
    NSTimer * moveTimer;
    NSTimer * timeShow;
    
    
    int timeCompar;
    int doubleTime;
    int couunt;
    
    // 投食次数
    NSInteger feeding;
    
    // 自己
    NSString * termidSelf;
    NSString * deviceoSelf;
    
    
    
    
    
}
@property (nonatomic, strong) CTCallCenter * center;
@property (nonatomic, assign) SephoneCall *call;
@end

@implementation InCallViewController
@synthesize penSd;
@synthesize call;
@synthesize videoView;
@synthesize timeText;
@synthesize pointView;
@synthesize isOth;
@synthesize termidOth;
@synthesize deviceoOth;


- (void)setCall:(SephoneCall *)acall {
    call = acall;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Set observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdateEvent:) name:kSephoneCallUpdate object:nil];
    
    // Update on show
    SephoneCall *call_ = sephone_core_get_current_call([SephoneManager getLc]);
    SephoneCallState state = (call != NULL) ? sephone_call_get_state(call_) : 0;
    [self callUpdate:call_ state:state animated:FALSE];
    
    videoView.transform = CGAffineTransformScale(self.videoView.transform, 1.2, 1.0);
    // 视频
    sephone_core_set_native_video_window_id([SephoneManager getLc], (unsigned long)videoView);
    [self.flowerUI startAnimating];
    // 创建定时器更新通话时间 (以及创建时间显示)
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateViews) userInfo:nil repeats:YES];
    
    
    
}

- (void)applicationWillResignActive:(NSNotification *)notification

{
    
    [self RefreshCellForLiveId];

    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.backBtn removeFromSuperview];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    if (updateTimer != nil) {
        [updateTimer invalidate];
        updateTimer = nil;
    }
    
    [moveTimer invalidate];
    
    // Clear windows
    //  必须清除，否则会因为arc导致再次视频通话时crash。
    sephone_core_set_native_video_window_id([SephoneManager getLc], (unsigned long)NULL);
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSephoneCallUpdate object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   // [[UIApplication sharedApplication].keyWindow addSubview:self.backBtn];

        self.center = [[CTCallCenter alloc] init];
        __weak InCallViewController *weakSelf = self;
        self.center.callEventHandler = ^(CTCall * call)
        {
            //TODO:检测到来电后的处理
            [weakSelf performSelectorOnMainThread:@selector(RefreshCellForLiveId)
                                   withObject:nil
                                waitUntilDone:NO];
        
            
        };
    
    
    // 后台
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification
     object:[UIApplication sharedApplication]];
    
    [self callStream:call];
    [self setupView];

}

- (void)RefreshCellForLiveId
{
    
    [SephoneManager terminateCurrentCallOrConference];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


- (void)setupView
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.view.backgroundColor =[UIColor whiteColor];
    UIImage *thumbImage =[UIImage imageNamed:@"1.png"];
    UIImage *thumbImage1 =[UIImage imageNamed:@"22.jpg"];
    [penSd setThumbImage:thumbImage1 forState:UIControlStateHighlighted];
    [penSd setThumbImage:thumbImage forState:UIControlStateNormal];
    
    
}

- (void)callStream:(SephoneCall *)calls
{
    
    if (calls != NULL) {
        
        sephone_call_set_next_video_frame_decoded_callback(calls, hideSpinner, (__bridge void *)(self));
    }
    
    
    if (![SephoneManager hasCall:calls]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    
    
}


// 滑动红外线
- (IBAction)moveBtnClick:(UISlider *)sender {
    

    float valu = sender.value*100;
    int str =(int)valu;
    NSString * msg =[NSString stringWithFormat:@"control_pantilt,0,0,1,0,%d,%d",str,30];
 
    doubleTime++;
    if (doubleTime%2 ==0) {
        
        int timeComparSecond =[self getTimeNow];
        if (timeComparSecond - timeCompar<100) {
            
            // 不执行
        }else{
            
            
            [self sendMessage:msg];
        }

    }else{
        
       timeCompar = [self getTimeNow];
        [self sendMessage:msg];
        
    }
    
   
    
    
}

- (int )getTimeNow
{
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString * timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    int a =[[timeNow substringWithRange:NSMakeRange(0, 2)] intValue];
    int b =[[timeNow substringWithRange:NSMakeRange(3, 2)] intValue];
    int c=[[timeNow substringWithRange:NSMakeRange(6, 2)] intValue];
    int d =[[timeNow substringFromIndex:9]intValue];
    a= a*3600000+b*60000+c*1000+d;
    return a;
    
}




//**************************外设控制**************************//



#pragma sendMessageTest wjb
-(void) sendMessage:(NSString *)mess{
    
    const char * message =[mess UTF8String];
    sephone_core_send_user_message([SephoneManager getLc], message);
    
}



// 除了开灯其他的都延迟3秒

//喂食
- (IBAction)feedBtnClick:(UIButton *)sender {
    
   
    NSString * str =@"clientAction.do?common=food&classes=appinterface&method=json";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    
    if (isOth) {
        [dic setValue:deviceoOth forKey:@"deviceno"];
        [dic setValue:termidOth forKey:@"termid"];
        
    }else{
        
     [self dowithID];
        [dic setValue:deviceoSelf forKey:@"deviceno"];
        [dic setValue:termidSelf forKey:@"termid"];
        
        
    }
    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
        
        NSLog(@"%@",json);
        
    } failure:^(NSError *error) {
        
        
    }];


    
    
}


/**
 *  开灯
 *
 *  @param sender  on  off
 */
- (IBAction)lightBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    NSString * str1;
    doubleTime++;
    if (doubleTime%2 ==0) {
        str1 = @"off";
    }else
    {
        
        str1 =@"on";
    }
    
    NSString * str =@"clientAction.do?common=switchLight&classes=appinterface&method=json";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    
    if (isOth) {
        [dic setValue:deviceoOth forKey:@"deviceno"];
        [dic setValue:termidOth forKey:@"termid"];
    }else
    {
        
        [self dowithID];
        [dic setValue:deviceoSelf forKey:@"deviceno"];
        [dic setValue:termidSelf forKey:@"termid"];
    }
   
    [dic setValue:str1 forKey:@"action"];
    
    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
        
        NSLog(@"%@",json);
        
    } failure:^(NSError *error) {
        
        
    }];

    
    
}

// 零食
- (IBAction)juankFootBtnClick:(UIButton *)sender {
    
   
//    [NSThread sleepForTimeInterval:3];
//    sender.selected =!sender.selected;
    
//    double delayInSeconds = 3.0;
//    __block InCallViewController* bself = self;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//       // sender.selected =!sender.selected;
//    });
    
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    NSString * tsm =[defaults objectForKey:@"tsm"];
    NSString * otherID =[defaults objectForKey:@"othID"];
    NSString * selfID =[defaults objectForKey:@"otherbuildIDS"];
    NSString * str =@"clientAction.do?common=feeding&classes=appinterface&method=json";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    if (isOth) {
        feeding++;
        if ([tsm intValue]<feeding) {
            [self showSuccessHudWithHint:@"To achieve the maximum number of feeding times"];
            return;
        }else{
        [dic setValue:otherID forKey:@"id"];
        [dic setValue:deviceoOth forKey:@"deviceno"];
        [dic setValue:termidOth forKey:@"termid"];
        
        }
    }else
    {
        [self dowithID];
        [dic setValue:selfID forKey:@"id"];
        [dic setValue:deviceoSelf forKey:@"deviceno"];
        [dic setValue:termidSelf forKey:@"termid"];
    }

    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
        
        NSLog(@"%@",json);
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
}

//抓拍
- (IBAction)photoBtnClick:(UIButton *)sender {
    
    
    
    NSString * str =@"clientAction.do?common=photoGraph&classes=appinterface&method=json";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    
    if (isOth) {
        [dic setValue:deviceoOth forKey:@"deviceno"];
        [dic setValue:termidOth forKey:@"termid"];
    }else
    {
        [self dowithID];
        [dic setValue:deviceoSelf forKey:@"deviceno"];
        [dic setValue:termidSelf forKey:@"termid"];
        
    }
   
    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
        
        NSLog(@"%@",json);
        
    } failure:^(NSError *error) {
        
        
    }];

    
}




//  返回
- (IBAction)backBtnClick:(UIButton *)sender {
    [self videoEnd];
    [SephoneManager terminateCurrentCallOrConference];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
// 上
- (IBAction)start:(UIButton *)sender {
    
    [self moveRobot:@"4"];
}

// 上结束
- (IBAction)beforBtnClick:(UIButton *)sender {
    [self overTime];
}



// 下
- (IBAction)down:(UIButton *)sender {
    
    [self overTime];
}

- (IBAction)downStart:(UIButton *)sender {
    
        [self moveRobot:@"3"];
    
}




// 左
- (IBAction)leftStart:(UIButton *)sender {
    
    [self moveRobot:@"2"];
}

- (IBAction)left:(UIButton *)sender {
    
    [self overTime];
    
}

// 右
- (IBAction)right:(UIButton *)sender {
    
    [self overTime];
}
- (IBAction)rightstatr:(UIButton *)sender {
    
    
    [self moveRobot:@"1"];
    
}




//  抬头  上

- (IBAction)uptop_start:(UIButton *)sender {
    
    [self moverobot:@"1"]; // 上
    

    
}


- (IBAction)topup:(UIButton *)sender {
    [self overTime];
    
}


- (IBAction)topdown_start:(UIButton *)sender {
    [self moverobot:@"2"]; // 上
    

    
}

- (IBAction)topdown:(UIButton *)sender {
    
    [self overTime];
}


-(void)moverobot:(NSString *)str
{
    NSInteger i = [str integerValue];
    switch (i) {
        case 1:
            self.right_btn.userInteractionEnabled = NO;
            self.left_btn.userInteractionEnabled = NO;
            self.up_btn.userInteractionEnabled = NO;
            self.down_btn.userInteractionEnabled = NO;
            self.left_up_btn.userInteractionEnabled = YES;
            self.left_down_btn.userInteractionEnabled = NO;
            break;
            
        case 2:
            self.right_btn.userInteractionEnabled = NO;
            self.left_btn.userInteractionEnabled = NO;
            self.up_btn.userInteractionEnabled = NO;
            self.down_btn.userInteractionEnabled = NO;
            self.left_up_btn.userInteractionEnabled = NO;
            self.left_down_btn.userInteractionEnabled = YES;
            
            break;
        default:
            break;
    }
    
    
    moveTimer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0*0.2 block:^(id userInfo) {
        
        [self sendInfomationL:str];
    } userInfo:@"Fire" repeats:YES];
    [moveTimer fire];
    
    
}

- (void)sendInfomationL:(NSString *)sender
{
    
    NSString * msg =[NSString stringWithFormat:@"control_servo,0,0,2,%d,200",[sender intValue]];
    NSLog(@"我走");
    [self sendMessage:msg];
}




- (void)moveRobot:(NSString *)str
{
   
    NSInteger i = [str integerValue];
    switch (i) {
        case 4:
            // 上
            self.up_btn.userInteractionEnabled = YES;
            self.down_btn.userInteractionEnabled = NO;
            self.left_btn.userInteractionEnabled = NO;
            self.right_btn.userInteractionEnabled = NO;
            self.left_up_btn.userInteractionEnabled = NO;
            self.left_down_btn.userInteractionEnabled = NO;
            break;
        case 3:
            //下
            self.down_btn.userInteractionEnabled = YES;
            self.up_btn.userInteractionEnabled = NO;
            self.left_btn.userInteractionEnabled = NO;
            self.right_btn.userInteractionEnabled = NO;
            self.left_up_btn.userInteractionEnabled = NO;
            self.left_down_btn.userInteractionEnabled = NO;
            break;
        case 2:
            //左
            self.left_btn.userInteractionEnabled = YES;
            self.right_btn.userInteractionEnabled = NO;
            self.down_btn.userInteractionEnabled = NO;
            self.up_btn.userInteractionEnabled = NO;
            self.left_up_btn.userInteractionEnabled = NO;
            self.left_down_btn.userInteractionEnabled = NO;
            break;
        case 1:
            // 右
            self.right_btn.userInteractionEnabled = YES;
            self.left_btn.userInteractionEnabled = NO;
            self.up_btn.userInteractionEnabled = NO;
            self.down_btn.userInteractionEnabled = NO;
            self.left_up_btn.userInteractionEnabled = NO;
            self.left_down_btn.userInteractionEnabled = NO;
            break;
            
        default:
            break;
    }
    
    
    moveTimer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0*0.2 block:^(id userInfo) {
        
        [self sendInfomation:str];
    } userInfo:@"Fire" repeats:YES];
    [moveTimer fire];
}


- (void)sendInfomation:(NSString *)sender
{
    
    NSString * msg =[NSString stringWithFormat:@"control_servo,0,0,1,%d,200",[sender intValue]];
    [self sendMessage:msg];

    
}



- (void)overTime
{
    [moveTimer invalidate];
    self.up_btn.userInteractionEnabled = YES;
    self.down_btn.userInteractionEnabled = YES;
    self.left_btn.userInteractionEnabled = YES;
    self.right_btn.userInteractionEnabled = YES;
    self.left_up_btn.userInteractionEnabled = YES;
    self.left_down_btn.userInteractionEnabled = YES;


    
}

// 更新控件内容
- (void)updateViews {
    
    SephoneCall *calltime= sephone_core_get_current_call([SephoneManager getLc]);
    
    if (calltime == NULL) {
        return;
    }else
    {
        int duration = sephone_call_get_duration(calltime);
        
        //NSLog(@"=========时间======%02i:%02i",(duration/60), (duration%60));
        timeText.text =[NSString stringWithFormat:@"%02i:%02i", (duration/60), (duration%60), nil];
        
        if (duration >= 300) {
            
            [SephoneManager terminateCurrentCallOrConference];
            NSLog(@"五分钟到时视频流自动断开");
            [self videoEnd];
            
        }
        
        
    }
    
    if (couunt%2 ==1) {
        pointView.hidden = NO;
    }else
    {
        pointView.hidden = YES;
        
    }
    
    couunt ++;
    if (call == NULL) {
       return;
    }

    
}




// 通话监听

- (void)callUpdate:(SephoneCall *)call_ state:(SephoneCallState)state animated:(BOOL)animated {
   
    

    // Fake call update
    if (call_ == NULL) {
        return;
    }
    
    switch (state) {
            // 通话结束或出错时退出界面。
        case SephoneCallEnd:
        case SephoneCallError: {
            call = NULL;
           [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}


- (void)callUpdateEvent:(NSNotification *)notif {
    SephoneCall *call_ = [[notif.userInfo objectForKey:@"call"] pointerValue];
    SephoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    [self callUpdate:call_ state:state animated:TRUE];
}



/**
 *  结束设备使用记录
 */


- (void)videoEnd
{
    
    NSUserDefaults * defau =[NSUserDefaults standardUserDefaults];
    NSString *  otherBulidId =[defau objectForKey:@"otherbuildIDS"];
    NSString *  selfID =[defau objectForKey:@"othID"];
    
    // otherbuildIDS
    /*
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
     */
    
    NSString * service = @"clientAction.do?common=updateDeviceUseRecord&classes=appinterface&method=json";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    
    if ([AppUtil isBlankString:otherBulidId]) {
        [dic setValue:selfID forKey:@"id"];
    }else
    {
        [dic setValue:otherBulidId forKey:@"id"];
        
    }
    [AFNetWorking postWithApi:service parameters:dic success:^(id json) {
        
        
    } failure:^(NSError *error) {
        
    }];
    
}



- (void)dowithID
{
    
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    NSString * devoLG =[AccountManager sharedAccountManager].loginModel.deviceno;
    NSString * termidLG = [AccountManager sharedAccountManager].loginModel.termid;
    NSString * devo  = [defaults objectForKey:PREF_DEVICE_NUMBER];
    NSString * termid = [defaults objectForKey:TERMID_DEVICNUMER];
    
    if ([AppUtil isBlankString:devoLG]) {
        if ([AppUtil isBlankString:devo]) {
            //没有设备
            
        }else{
            termidSelf = termid;
            deviceoSelf = devo;
        }
    }else{
        termidSelf = termidLG;
        deviceoSelf = devoLG;
        
        
    }
    
    
    
    
 
}


// 用户体验设置

- (void)hideSpinnerIndicator:(SephoneCall *)call {
    
    self.waitView.hidden = YES;
    
    
}

static void hideSpinner(SephoneCall *call, void *user_data) {
    InCallViewController *thiz = (__bridge InCallViewController *)user_data;
    [thiz hideSpinnerIndicator:call];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
