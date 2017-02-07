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

#define TARGET 60
#define DELTE_SCALE 16
#define MAX_MOVE 90

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
    
    
    // 横屏
    int _deltaX;
    int _deltaY;
    int _lastMoveX;
    int _lastMoveY;
    int _currentX;
    int _currentY;
    
    int _startX;
    int _startY;
    
    NSArray * btnList;
    //方向键
    NSArray * DriArr;
    //文本
    NSArray * LabeArr;
    
    
    
}
@property (nonatomic, strong) CTCallCenter * center;
@property (nonatomic, assign) SephoneCall *call;
@end

@implementation InCallViewController
@synthesize call;
@synthesize videoView;
@synthesize btnBack;
@synthesize flowUI;
@synthesize penSl;
@synthesize pesnBack;
@synthesize FiveView;
@synthesize pointTouch;
@synthesize timeLable;
@synthesize pullBtn;
@synthesize isOth;
@synthesize deviceoOth;
@synthesize termidOth;





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
    // 视频
    sephone_core_set_native_video_window_id([SephoneManager getLc], (unsigned long)videoView);
    [flowUI startAnimating];
    // 创建定时器更新通话时间 (以及创建时间显示)
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateViews) userInfo:nil repeats:YES];
    
    
    
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
    
}



// 初始化控件



- (void)setupView
{
    [super setupView];
    
    // 视频界面
    videoView =[UIView new];
    videoView.backgroundColor =[UIColor blackColor];
    [self.view addSubview:videoView];
    
    
    // 等待状态
    flowUI  =[UIActivityIndicatorView new];
    flowUI.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [videoView addSubview:flowUI];
    
    // 点
    pointTouch =[UIImageView new];
    pointTouch.hidden  = YES;
    [pointTouch setImage:[UIImage imageNamed:@"penSelect"]];
    
    
    //屏幕尺寸
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat width = size_screen.width;
    CGFloat height = size_screen.height;
    
    // 屏幕分成16份
    _deltaX = (int) (width / DELTE_SCALE);
    _deltaY = (int) (height / DELTE_SCALE);
    //  只需要得到滑动的最后一个点就OK
    
    _lastMoveX = -1;
    _lastMoveY = -1;
    
    [self.view addSubview:pointTouch];
    
    // 返回按钮
    btnBack =[UIButton new];
    [btnBack addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnBack];
    
    
    // 时间
    timeLable =[UILabel new];
    timeLable.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:timeLable];

    // 激光笔背景
    pesnBack =[UIImageView new];
    pesnBack.userInteractionEnabled = YES;
    pesnBack.image =[UIImage imageNamed:@"penPlace"];
    [self.view addSubview:pesnBack];
    
    
    
    
    // 5个按钮背景
    FiveView =[UIImageView new];
    FiveView.userInteractionEnabled = YES;
    [self.view addSubview:FiveView];

    
    // 方向键
    UIButton * topBtn   =[UIButton new];
    UIButton * downBtn =[UIButton new] ;
    UIButton * leftBtn  =[UIButton new];
    UIButton * rightBtn = [UIButton new];
    UIButton * RtopBtn = [UIButton new];
    UIButton * RdownBtn =[UIButton new];
    topBtn.tag =1000001;
    downBtn.tag=1000002;
    leftBtn.tag =1000003;
    rightBtn.tag =1000004;
    RtopBtn.tag =1000005;
    RdownBtn.tag =1000006;
    
    
    [topBtn addTarget:self action:@selector(topClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [topBtn addTarget:self action:@selector(Stopclick:) forControlEvents:UIControlEventTouchDown];
    
    
    [downBtn addTarget:self action:@selector(downClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [downBtn addTarget:self action:@selector(Sdownclick:) forControlEvents:UIControlEventTouchDown];
    
    [leftBtn addTarget:self action:@selector(leftClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn addTarget:self action:@selector(Sleftclick:) forControlEvents:UIControlEventTouchDown];
    
    
    [rightBtn addTarget:self action:@selector(rightClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(Srightclick:) forControlEvents:UIControlEventTouchDown];
    
    [RtopBtn addTarget:self action:@selector(RtopClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [RtopBtn addTarget:self action:@selector(Slef_toptclick:) forControlEvents:UIControlEventTouchDown];
    
    [RdownBtn addTarget:self action:@selector(RdownClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [RdownBtn addTarget:self action:@selector(Slef_downtclick:) forControlEvents:UIControlEventTouchDown];
    
    
    DriArr =@[topBtn,downBtn,leftBtn,rightBtn,RtopBtn,RdownBtn];
    for (NSInteger i =0; i<6; i++) {
        [self.view addSubview:DriArr[i]];
        
        
    }
    // 5个文本字体
    UILabel * label1 =[UILabel new];
    UILabel * label2 =[UILabel new];
    UILabel * label3 =[UILabel new];
    UILabel * label4 =[UILabel new];
    UILabel * label5 =[UILabel new];
    LabeArr =@[label1,label2,label3,label4,label5];
    for (NSInteger  i=0; i<5; i++) {
        
        
        [FiveView addSubview:LabeArr[i]];
        
    }
    
    // 推拉
    pullBtn =[UIButton new];
    pullBtn.userInteractionEnabled = YES;
    pullBtn.hidden = YES;
    [pullBtn setImage:[UIImage imageNamed:@"take_off"] forState:UIControlStateNormal];
    [pullBtn setImage:[UIImage imageNamed:@"take_on"] forState:UIControlStateSelected];
    [pullBtn addTarget:self action:@selector(pullBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [FiveView addSubview:pullBtn];
    
    
    // 小圆
    UIImageView * SmallImage =[UIImageView new];
    SmallImage.tag = 10000001;
    SmallImage.image =[UIImage imageNamed:@"small"];
    [self.view addSubview:SmallImage];
    
    
    
    
    
    // 5个按钮
    UIButton * voicebtn =[UIButton new];
    UIButton * lightbtn =[UIButton new];
    UIButton * foodbtn =[UIButton new];
    UIButton * rollbtn =[UIButton new];
    UIButton * takephoto =[UIButton new];
    
    [voicebtn addTarget:self action:@selector(VocieClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [lightbtn addTarget:self action:@selector(LightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [foodbtn addTarget:self action:@selector(FoodClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [rollbtn addTarget:self action:@selector(RollClick:) forControlEvents:UIControlEventTouchUpInside];
    [takephoto addTarget:self action:@selector(PhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btnList =@[voicebtn,lightbtn,foodbtn,rollbtn,takephoto];
    for (NSInteger i =0; i<5; i++) {
        
        [FiveView addSubview:btnList[i]];
    }
    
    
    [self HviewUpdateView];
    
   

}

// 横屏激光笔

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    pointTouch.hidden = NO;
    
    //touches ：动作的数量()  每个对象都是一个UITouch对象，而每一个事件都可以理解为一个手指触摸。
    //获取任意一个触摸对象
    UITouch *touch = [touches anyObject];
    
    //触摸对象的位置
    CGPoint previousPoint = [touch locationInView:self.view.window];
    
    _startX = (int)previousPoint.x;
    _startY = (int)previousPoint.y;
    
    pointTouch.frame = CGRectMake(previousPoint.x - TARGET/2,previousPoint.y -TARGET/2, TARGET, TARGET);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    //获取任意一个触摸对象
    UITouch *touch = [touches anyObject];
    
    //触摸对象的位置
    CGPoint previousPoint = [touch locationInView:self.view.window];
    int currentX = (int)previousPoint.x;
    int currentY = (int)previousPoint.y;
    
    pointTouch.frame = CGRectMake(previousPoint.x - TARGET/2,(previousPoint.y - TARGET/2), TARGET, TARGET);
    
    if(_lastMoveX == -1 || _lastMoveY == -1) {
        
        
        _lastMoveX = currentX;
        _lastMoveY = currentY;
        
        
        
    } else if((abs(currentX - _lastMoveX) > _deltaX) || (abs(currentY - _lastMoveY) > _deltaY)) {
        
        _lastMoveX = currentX;
        _lastMoveY = currentY;
        
        
        
    }
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    //    //触摸对象的位置
    CGPoint previousPoint = [touch locationInView:self.view.window];
    _lastMoveX = -1;
    _lastMoveY = -1;
    
}





-(void) sendMoveCommand:(int) sendX withY:(int) sendY{
    
    
    int changeX = 0; //转换的x 不超过90
    int changeY = 0; //转换的y 不超过90
    
    //屏幕尺寸
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    
    CGFloat width = size_screen.width;
    CGFloat height = size_screen.height;
    
    
    changeX = (int) ((MAX_MOVE / width) * sendX);
    changeY = (int) ((MAX_MOVE / height) * sendY);
    changeY = MAX_MOVE- changeY;
    
    
    NSLog(@"sendMoveCommand:changeX=%d,changeY=%d, deltaX=%d, deltaY=%d,x=%d,y=%d, sX=%d ,sY=%d, sendCX=%d, sendCY=%d" ,changeX ,changeY ,_deltaX , _deltaY, sendX ,sendY,(MAX_MOVE-changeY), (MAX_MOVE-changeX), (int)((MAX_MOVE-changeY)*1.35), (int)((MAX_MOVE-changeX)*1.35));
    
    
}



//  返回
- (void)backBtn:(UIButton *)sender {
    [self videoEnd];
    [updateTimer invalidate];
    [SephoneManager terminateCurrentCallOrConference];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


/**
 *   横屏的切换 约束更新
 */
- (void)HviewUpdateView
{
    pullBtn.hidden = NO;
    pointTouch.hidden = YES;
    
    
    
    videoView.transform = CGAffineTransformScale(self.videoView.transform, 1.32, 1.04);
    
    // 视频界面
    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.top.mas_equalTo(0);
        
    }];
    [btnBack mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(12);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(15, 25));
        
    }];
    
    // 横屏红外线
    [pointTouch mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(TARGET);
        
    }];
    
    

    
    [timeLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-52);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 30));
        
    }];
    
    
    
    // 激光笔背景
    [pesnBack mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(@0);
        
        
    }];
    
    penSl.hidden = YES;
    [penSl mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(@0);
        
    }];
    FiveView.image =[UIImage imageNamed:@"halfAp"];
    FiveView.backgroundColor =[UIColor clearColor];
    FiveView.layer.borderWidth =0;
    
    // 5个按钮背景
    [FiveView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(83);
        make.top.bottom.right.mas_equalTo(0);
        
        
    }];
    
    // 5个按钮
    NSArray * imageListS=@[@"takep_on",@"Lclick_light",@"Lclick_rool",@"Lclick_food",@"Lclick_photo"];
    NSArray * imageListN=@[@"takep_off",@"Lnormal_light",@"Lnormal_rool",@"Lnormal_food",@"Lnormal_photo"];
    for (NSInteger i =0; i<5; i++) {
        [btnList[i] setImage:[UIImage imageNamed:imageListN[i]] forState:UIControlStateNormal];
        [btnList[i] setImage:[UIImage imageNamed:imageListS[i]] forState:UIControlStateSelected];
    }
    
    
    
    
    
    
    // 推拉
    [pullBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(FiveView.mas_left).offset(6);
        make.size.mas_equalTo(CGSizeMake(15, 22));
        make.bottom.equalTo(self.view.mas_bottom).offset(-187);
        
        
        
        
    }];
    
    NSArray * arrText;
    arrText = @[@"声音",@"开灯",@"喂食",@"投食",@"抓拍"];
    for (NSInteger  i=0; i<5; i++) {
        UILabel * newLable =LabeArr[i];
        newLable.text =arrText[i];
        newLable.font =[UIFont systemFontOfSize:12];
        newLable.textColor =[UIColor whiteColor];
        
        
    }
    
    
    // 文本字体
    [LabeArr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(FiveView.mas_centerX).offset(8);
        make.height.mas_equalTo(12);
        
        
    }];
    
    [LabeArr mas_distributeViewsAlongAxis:MASAxisTypeVertical
                         withFixedSpacing:65
                              leadSpacing:65
                              tailSpacing: 9];
    
    NSArray * imageList =@[@"top_egg",@"down_egg",@"left_egg",@"right_egg",@"L_top",@"L_down"];
    
    for (NSInteger i =0; i<6; i++) {
        [DriArr[i] setImage:[UIImage imageNamed:imageList[i]] forState:UIControlStateNormal];
        
    }
    
    
    [btnList mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FiveView.mas_left).offset(28);
        make.right.equalTo(self.view.mas_right).offset(-13);
        
        
    }];
    
    [btnList mas_distributeViewsAlongAxis:MASAxisTypeVertical
                         withFixedSpacing:31
                              leadSpacing:20
                              tailSpacing:20];
    
    
    
    
    //方向按钮
    
    [DriArr[0] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-124);
        make.size.mas_equalTo(CGSizeMake(143*0.75,79*0.75));
        make.left.mas_equalTo(55);
        
        
        
        
    }];
    
    
    [DriArr[1] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-32);
        make.size.mas_equalTo(CGSizeMake(143*0.75,79*0.75));
        make.left.mas_equalTo(55);
        
        
        
        
    }];
    //左
    [DriArr[2] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-54);
        make.size.mas_equalTo(CGSizeMake(79*0.75,143*0.75));
        make.left.mas_equalTo(33);
        
        
        
        
    }];
    
    [DriArr[3] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-54);
        make.size.mas_equalTo(CGSizeMake(79*0.75,143*0.75));
        make.left.mas_equalTo(125);
        
        
        
        
        
    }];
    
    [DriArr[4] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-110);
        make.right.mas_equalTo(-393);
        make.height.mas_equalTo(78);
        make.width.mas_equalTo(53);
        
        
        
        
    }];
    
    [DriArr[5] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-32);
        make.right.mas_equalTo(-393);
        make.width.mas_equalTo(53);
        make.height.mas_equalTo(78);
        
        
        
    }];
    
    
    
    
}

#pragma mark  buttonMethod _________________各点击事件__________________________


//弹出 收回

- (void)pullBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    
    if (sender.selected) {
        // 移动view
        [UIView animateWithDuration:0.5 animations:^{
            FiveView.center = CGPointMake(687, FiveView.center.y);
            
        } completion:^(BOOL finished) {
            //平移结束
           
            return ;
            
        }];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            FiveView.center = CGPointMake(625.5, FiveView.center.y);
        } completion:^(BOOL finished) {
            //平移结束
          
            
            return ;
            
        }];
        
        
    }
    
    
    
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




- (void)RefreshCellForLiveId
{
    
    [SephoneManager terminateCurrentCallOrConference];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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
- (void)FoodClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
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
         sender.selected = !sender.selected;
        
    } failure:^(NSError *error) {
        
        
    }];


    
    
}

// 声音
- (void)VocieClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    
    
    
}


/**
 *  开灯
 *
 *  @param sender  on  off
 */
- (void)LightClick:(UIButton *)sender {
    
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
- (void)RollClick:(UIButton *)sender {
    
  sender.selected = !sender.selected;
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
         sender.selected = !sender.selected;
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
}

//抓拍
- (void)PhotoClick:(UIButton *)sender {
    
     sender.selected = !sender.selected;
    
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
         sender.selected = !sender.selected;
        
    } failure:^(NSError *error) {
        
        
    }];

    
}





// 上
- (void)Stopclick:(UIButton *)sender {
    
    [self moveRobot:@"4"];
}

// 上结束
- (void)topClickSt:(UIButton *)sender {
    [self overTime];
}



// 下
- (void)downClickSt:(UIButton *)sender {
    
    [self overTime];
}

- (void)Sdownclick:(UIButton *)sender {
    
        [self moveRobot:@"3"];
    
}




// 左
- (void)Sleftclick:(UIButton *)sender {
    
    [self moveRobot:@"2"];
}

- (void)leftClickSt:(UIButton *)sender {
    
    [self overTime];
    
}

// 右
- (void)rightClickSt:(UIButton *)sender {
    
    [self overTime];
}
- (void)Srightclick:(UIButton *)sender {
    
    
    [self moveRobot:@"1"];
    
}




//  抬头  上

- (void)Slef_toptclick:(UIButton *)sender {
    
    [self moverobot:@"1"]; // 上
    

    
}


- (void)RtopClickSt:(UIButton *)sender {
    [self overTime];
    
}


- (void)Slef_downtclick:(UIButton *)sender {
    [self moverobot:@"2"]; // 上
    

    
}

- (void)RdownClickSt:(UIButton *)sender {
    
    [self overTime];
}


-(void)moverobot:(NSString *)str
{
    NSInteger i = [str integerValue];
    switch (i) {
        case 1:
            [self.view viewWithTag:100001].userInteractionEnabled = NO;
            [self.view viewWithTag:100002].userInteractionEnabled = NO;
            [self.view viewWithTag:100003].userInteractionEnabled = NO;
            [self.view viewWithTag:100004].userInteractionEnabled = NO;
            [self.view viewWithTag:100005].userInteractionEnabled = YES;
            [self.view viewWithTag:100006].userInteractionEnabled = NO;
            
            break;
            
        case 2:
            
            [self.view viewWithTag:100001].userInteractionEnabled = NO;
            [self.view viewWithTag:100002].userInteractionEnabled = NO;
            [self.view viewWithTag:100003].userInteractionEnabled = NO;
            [self.view viewWithTag:100004].userInteractionEnabled = NO;
            [self.view viewWithTag:100005].userInteractionEnabled = NO;
            [self.view viewWithTag:100006].userInteractionEnabled = YES;
            
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
        case 1:
            
            [self.view viewWithTag:i].userInteractionEnabled = YES;
            [self.view viewWithTag:100002].userInteractionEnabled = NO;
            [self.view viewWithTag:100003].userInteractionEnabled = NO;
            [self.view viewWithTag:100004].userInteractionEnabled = NO;
            [self.view viewWithTag:100005].userInteractionEnabled = NO;
            [self.view viewWithTag:100006].userInteractionEnabled = NO;
            break;
            
        case 2:
            [self.view viewWithTag:i].userInteractionEnabled = YES;
            [self.view viewWithTag:100001].userInteractionEnabled = NO;
            [self.view viewWithTag:100003].userInteractionEnabled = NO;
            [self.view viewWithTag:100004].userInteractionEnabled = NO;
            [self.view viewWithTag:100005].userInteractionEnabled = NO;
            [self.view viewWithTag:100006].userInteractionEnabled = NO;
            
            break;
        case 3:
            [self.view viewWithTag:i].userInteractionEnabled = YES;
            [self.view viewWithTag:100002].userInteractionEnabled = NO;
            [self.view viewWithTag:100001].userInteractionEnabled = NO;
            [self.view viewWithTag:100004].userInteractionEnabled = NO;
            [self.view viewWithTag:100005].userInteractionEnabled = NO;
            [self.view viewWithTag:100006].userInteractionEnabled = NO;
            
            break;
        case 4:
            
            [self.view viewWithTag:i].userInteractionEnabled = YES;
            [self.view viewWithTag:100002].userInteractionEnabled = NO;
            [self.view viewWithTag:100003].userInteractionEnabled = NO;
            [self.view viewWithTag:100001].userInteractionEnabled = NO;
            [self.view viewWithTag:100005].userInteractionEnabled = NO;
            [self.view viewWithTag:100006].userInteractionEnabled = NO;
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
        timeLable.text =[NSString stringWithFormat:@"%02i:%02i", (duration/60), (duration%60), nil];
        
        if (duration >= 300) {
            
            [SephoneManager terminateCurrentCallOrConference];
            NSLog(@"五分钟到时视频流自动断开");
            [self videoEnd];
            
        }
        
        
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
    
    [flowUI stopAnimating];
    
    
    
}

static void hideSpinner(SephoneCall *call, void *user_data) {
    InCallViewController *thiz = (__bridge InCallViewController *)user_data;
    [thiz hideSpinnerIndicator:call];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// 只允许横屏

-(BOOL)shouldAutorotate
{
    return NO;
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
     return UIInterfaceOrientationMaskLandscape;
}





@end