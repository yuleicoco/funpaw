//
//  MainTabViewController.m
//  petegg
//
//  Created by ldp on 16/3/14.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "MainTabViewController.h"

#import "EggViewController.h"
#import "PersonalViewController.h"
#import "RecordViewController.h"

#import "UITabBar+Badge.h"

@interface MainTabViewController()
{
    
    dispatch_source_t timer3;
    AppDelegate * app;
    NSString * messageCount;
    
    
    
    
}

//记录
@property (strong, nonatomic) UINavigationController  *navRecordVC;
//不倒蛋
@property (strong, nonatomic) UINavigationController  *navEggVC;
//个人中心
@property (strong, nonatomic) UINavigationController  *navPersonalVC;

@end

@implementation MainTabViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(check) name:@"check" object:nil];
  
}



- (void)setupSubviews
{
    self.tabBar.backgroundColor=[UIColor whiteColor];
    
    self.viewControllers = @[
                             self.navRecordVC,
                             self.navEggVC,
                             self.navPersonalVC
                             ];
    
    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -1);
    self.tabBar.layer.shadowOpacity = 0.4;
    self.tabBar.layer.shadowRadius = 2;
}

//记录
- (UINavigationController *)navRecordVC{
    if (!_navRecordVC) {
        
        RecordViewController* vc = [[RecordViewController alloc] init];
        
        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:@"Home"
                                      image:[[UIImage imageNamed:@"jiluhou.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"jiluselect.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _navRecordVC = [[UINavigationController alloc]initWithRootViewController:vc];
    }
    
    return _navRecordVC;
}

//不倒蛋
- (UINavigationController *)navEggVC{
    if (!_navEggVC) {
        
        EggViewController* vc = [[EggViewController alloc] init];
        
        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:@"Device"
                                      image:[[UIImage imageNamed:@"tab_egg_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"tab_egg_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _navEggVC = [[UINavigationController alloc]initWithRootViewController:vc];
    }
    
    return _navEggVC;
}

//个人中心
- (UINavigationController *)navPersonalVC{
    
    if (!_navPersonalVC) {
        
       PersonalViewController* vc = [[PersonalViewController alloc] init];
        // 明天写
        // vc.messageCount =messageCount;
        
        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:@"Me"
                                      image:[[UIImage imageNamed:@"tab_personal_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"tab_personal_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
       _navPersonalVC = [[UINavigationController alloc]initWithRootViewController:vc];
        
    }
    
    return _navPersonalVC;
}

- (void)check
{
    
    NSTimeInterval period = 5.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer3 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer3, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer3, ^{
        
        [self compareDoubleTime];
        
    });
    dispatch_source_set_cancel_handler(timer3, ^{
        
       // dispatch_source_cancel(timer3);

    })
    ;
    dispatch_resume(timer3);
}

/**
 *  对比时间差
 */
- (void)compareDoubleTime
{
    
    NSLog(@"===================================");
    
    NSString *date = [AppUtil getNowTime];
    int dateOver = [self spare:date];
    
    NSUserDefaults *standDefus = [NSUserDefaults standardUserDefaults];
    NSString *dateEnd = [standDefus objectForKey:@"endTime"];
    int dateEndOver = [self spare:dateEnd];
    // dateEndOver = (dateOver -dateEndOver)/60 + (dateOver -dateEndOver)%60;
    dateEndOver = dateOver - dateEndOver;
    
    if ([AppUtil isBlankString:[standDefus objectForKey:@"content"]]) {
          
        
    } else {
        // 先查询状态视频状态
        
        NSString *service =
        [NSString stringWithFormat:@"clientAction.do?common=queryTask&classes="
         @"appinterface&method=json&tid=%@",
         [standDefus objectForKey:@"content"]];
        [AFNetWorking postWithApi:service parameters:nil success:^(id json) {
              json = [json objectForKey:@"jsondata"];
              if ([[json objectForKey:@"content"] isEqualToString:@"0"]) {
                // 在对比时间 做出判断
                if (dateEndOver >= 600) {
                  // 已经超时
                  dispatch_suspend(timer3);
//                  [self showMessageWarring:@"超时" view:app.window];
                    [self showMessageWarring:@"Overtime" view:app.window];
                    
                    [standDefus removeObjectForKey:@"content"];

                } else {
                 

                }
              }
              if ([[json objectForKey:@"content"] isEqualToString:@"1"]) {
                // 上传成功
                  [self showMessageWarring:@"Upload success" view:app.window];
                  dispatch_source_cancel(timer3);
                [standDefus removeObjectForKey:@"content"];
                dispatch_suspend(timer3);
              }
              if ([[json objectForKey:@"content"] isEqualToString:@"2"]) {
                  dispatch_suspend(timer3);
//                  [self showMessageWarring:@"上传失败" view:app.window];
                  [self showMessageWarring:@"Upload failed" view:app.window];
                 [standDefus removeObjectForKey:@"content"];
             
            }

            }

            failure:^(NSError *error){
//               [self showMessageWarring:@"网络错误" view:app.window];
                [self showMessageWarring:@"Network error" view:app.window];
                
            }];
    }
}

- (int )spare:(NSString *)str
{
    int a =[[str substringWithRange:NSMakeRange(0, 2)] intValue];
    int b =[[str substringWithRange:NSMakeRange(3, 2)] intValue];
    int c=[[str substringWithRange:NSMakeRange(6, 2)] intValue];
    a= a*3600+b*60+c;
    return a;
    
}


- (void)pushViewController:(UIViewController*)viewController {
    
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    
        [((UINavigationController*)self.selectedViewController) pushViewController:viewController animated:YES];
        
    }
    
}


@end
