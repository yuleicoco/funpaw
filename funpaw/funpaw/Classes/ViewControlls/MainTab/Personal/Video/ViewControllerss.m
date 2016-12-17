//
//  ViewControllerss.m
//  videoDemo
//
//  Created by yulei on 15/9/23.
//  Copyright (c) 2015年 yulei. All rights reserved.
//

#import "ViewControllerss.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoViewController.h"
#import "AppDelegate.h"
@interface ViewControllerss ()
{
    
    
    UIProgressView * playerProgress; // 进度条
    UILabel * time1;
    UISlider *sliderGo;
    UIButton * centerBtn;
    UIButton *btn;
 
    
    
    
    
}
@property(nonatomic,strong)UIView * playerContainer; // 播放器容器
@property(nonatomic,strong)AVPlayer * player; // 播放器对象
@property (assign,readonly) CGFloat   totalTime;
@property (nonatomic,readonly)CMTimeScale  timeScale;
@end

@implementation ViewControllerss



- (void)viewWillLayoutSubviews
{
    //  交换了长宽
    CGRect bounds = [UIScreen mainScreen].bounds;
    float height =bounds.size.height;
    float width = bounds.size.width;
    NSLog(@"=======width:%f",width);
    NSLog(@"=======height:%f",height);
    
    

    
}

       //================托马斯旋转===========//
- (BOOL)shouldAutorotate{
    return NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏navigationController
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    //设置应用程序的状态栏到指定的方向
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    //view旋转
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];

    
    [self initUserface];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    //显示navigationController
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


- (void)back
{
    NSLog(@"zou");
    [self.player pause];
    self.player =nil;
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [self.navigationController popViewControllerAnimated:YES];
    
}


          //================play==================//


-(void)dealloc{
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
}
-(void)setupUI{
    //创建播放器层
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame=self.playerContainer.bounds;
    playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.playerContainer.layer addSublayer:playerLayer];
    
    
}

/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */

/**
 *  初始化播放器
 *
 *  @return 播放器对象
 */
-(AVPlayer *)player{
    if (!_player) {
        AVPlayerItem *playerItem=[self getPlayItem:0];
        _player=[AVPlayer playerWithPlayerItem:playerItem];
        [self addProgressObserver];
        [self addObserverToPlayerItem:playerItem];
    }
    return _player;
    
   }


/**
 *  根据视频索引取得AVPlayerItem对象
 *
 *  @param videoIndex 视频顺序索引
 *
 *  @return AVPlayerItem对象
 */
-(AVPlayerItem *)getPlayItem:(int)videoIndex{
    NSString *urlStr=[NSString stringWithFormat:@"%@",self.playUrl,nil];
    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return playerItem;
}

#pragma mark - 通知
/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    
    
}


#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver{
    AVPlayerItem *playerItem=self.player.currentItem;
    UIProgressView *progress=playerProgress;
    //这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);

        float total=CMTimeGetSeconds([playerItem duration]);
        NSLog(@"当前已经播放%.2fs.",current);
        //NSString * strTime =[NSString stringWithFormat:@"%.0f",current];
        NSString * strTime = [self convertTime:current];
        sliderGo.value = current;
        time1.text = strTime;
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
            NSString * str =[self convertTime:CMTimeGetSeconds(playerItem.duration)];
            NSLog(@"==============%@",str);
            sliderGo.maximumValue =CMTimeGetSeconds(playerItem.duration);            
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
        //
    }
}

- (void)initUserface

{
    // 568 320
    _playerContainer =[[UIView alloc]initWithFrame:CGRectMake(0, 0*W_Hight_Zoom, 375*W_Wide_Zoom, 670*W_Hight_Zoom)];
    _playerContainer.backgroundColor =[UIColor blackColor];
    [self.view addSubview:_playerContainer];
    
    centerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    centerBtn.center = _playerContainer.center;
    centerBtn.userInteractionEnabled = YES;
    [centerBtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(choosePlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerBtn];
    
    
    // 进度条
    playerProgress =[[UIProgressView alloc]initWithFrame:CGRectMake(100,620 *W_Hight_Zoom, 375*W_Wide_Zoom, 40*W_Hight_Zoom)];
    playerProgress.backgroundColor =[UIColor blackColor];// 没有走过
    playerProgress.progressTintColor =[UIColor redColor];// 已经走过
    playerProgress.trackTintColor =[UIColor blackColor];
    [self.view addSubview:playerProgress];
    
    
   //   使用滑动条
    sliderGo =[[UISlider alloc]initWithFrame:CGRectMake(98, 572*W_Hight_Zoom, 375*W_Wide_Zoom,100*W_Hight_Zoom )];
    sliderGo.minimumValue =0;
    
    [sliderGo setThumbImage:[UIImage imageNamed:@"soundSlider.png"] forState:UIControlStateNormal];
    [sliderGo setThumbImage:[UIImage imageNamed:@"soundSlider.png"] forState:UIControlStateHighlighted];
    
    [sliderGo addTarget:self action:@selector(changeOut:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sliderGo];
    
    
    
    // 放回
    
    UIButton * returnBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [returnBtn setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
   // [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:returnBtn];
    
    
    time1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 580*W_Hight_Zoom, 100, 40)];
    time1.backgroundColor =[UIColor clearColor];
    time1.tintColor =[UIColor redColor];
    time1.text =@"00.00";
    [self.view addSubview:time1];
    
   
    //  下载
    /*
    UIButton * downLoad =[[UIButton alloc]initWithFrame:CGRectMake(20, 100, 40, 40)];
    downLoad.backgroundColor =[UIColor redColor];
    [downLoad setTitle:@"下载" forState:UIControlStateNormal];
    [downLoad addTarget:self action:@selector(downloadButtonVideo) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:downLoad];
    
    */
    
    //  右上角播放
    
    btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 580*W_Hight_Zoom, 40, 40)];
    [btn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor =[UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    

    


    [self setupUI];
    
    
    

}

- (void)changeOut:(UISlider *)sender
{
    //快进
    NSLog(@"== 快进%f",sender.value);
    CGFloat speedTime = sender.value;
    int scale =1;
    CMTime cmtime =CMTimeMake(speedTime*scale, scale);
    [self.player.currentItem seekToTime:cmtime];
    centerBtn.hidden = YES;
    [self.player play];
    
    
}
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

- (void)choosePlay

{
    [self.player play];
    centerBtn.hidden = YES;
    
    [btn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];

}


- (void)play:(UIButton *)sender
{
    if(self.player.rate==0){ //说明时暂停
        [sender setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self.player play];
        centerBtn.hidden = YES;
    }else if(self.player.rate==1){//正在播放
        [self.player pause];
        centerBtn.hidden = NO;
        [sender setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
        
    }
    
}


- (void)downloadButtonVideo
{
    // 下载视频
  NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"%@",path);
    
    
}



@end
