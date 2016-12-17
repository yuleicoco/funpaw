//
//  SettingViewController.m
//  petegg
//
//  Created by yulei on 16/3/22.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "BindDeviceViewControler.h"
#import "SettingViewController.h"
#import "WifiViewController.h"


//termid
NSString * const TERMID_DEVICNUMER =@"termid";

// 设备号配置项
NSString *const PREF_DEVICE_NUMBER = @"deviceNumber";
// wifi是否已设置配置项
NSString *const PREF_WIFI_CONFIGURED = @"wifiConfigured";

@interface SettingViewController () {
    NSString *strDeviceNo;     // 设备号
    NSString *strConfigResult; // 已设置过wifi的标示符
}

@end

@implementation SettingViewController

@synthesize unbindButton;
@synthesize resolveButton;
@synthesize deviceNumberEdit;
@synthesize incodeEdit;

#pragma mark - View Events

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  初始化界面
 */
- (void)setupView {
    [super setupView];

    self.view.backgroundColor = [UIColor whiteColor];

    // 解绑按钮默认可用。
    unbindButton.backgroundColor = GREEN_COLOR;
    unbindButton.enabled = TRUE;
    // 功能按钮默认不可用。
    resolveButton.backgroundColor = GRAY_COLOR;
    resolveButton.enabled = TRUE;
    [resolveButton setTitle:@"Set Network" forState:UIControlStateNormal];
    
    [self setNavTitle:NSLocalizedString(@"settingViewTitle", nil)];
}

/**
 *  视图显示前处理
 *
 *  @param animated 
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    strDeviceNo = [defults objectForKey:PREF_DEVICE_NUMBER];
    strConfigResult = [defults objectForKey:PREF_WIFI_CONFIGURED];
    NSString * str = [AccountManager sharedAccountManager].loginModel.deviceno;
    

    // 尚未绑定设备，则绑定设备。
    if ([AppUtil isBlankString:str]) {
        if ([AppUtil isBlankString:strDeviceNo]) {
            [self updateUI:@"Search Device" State:false];

        }else
        {
            [self solveBing:strDeviceNo];
        }
    }
    // 已绑定设备，解除绑定。
    else {
        [self solveBing:str];
    }
    
    
    
}

// 设置网络
- (void)solveBing:(NSString *)str
{
    
    deviceNumberEdit.text = [NSString stringWithFormat:@"    Device No:  %@", str];
    incodeEdit.text = [NSString stringWithFormat:@"    Access Code:  ******"];
    [self updateUI:@"Remove Binding" State:true];

    
}



/**
 *  显示警告提示
 */
- (void)showWarningTip:(NSString *)str {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.minSize = CGSizeMake(132.f, 66.0f);
    [hud hide:YES afterDelay:1.0];
}

/**
 *  执行解绑http请求
 */
- (void)doUnbindRequest {
    // 格式化参数。
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"tip" message:@"Are you sure you want to remove the binding?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        
        NSString *mid = [AccountManager sharedAccountManager].loginModel.mid;
        if ([AppUtil isBlankString:mid]) {
            return;
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:mid forKey:@"mid"];
        
        NSString *service = [AppUtil getServerSego3];
        service = [service stringByAppendingString:@"clientAction.do?common=delDevice&classes=appinterface&method=json"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        // 创建进度提示窗。
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Please wait...";
        
        // 执行http请求。
        [manager POST:service
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"JSON: %@", responseObject);
                  [hud hide:YES];
                  
                  // 解析执行结果。
                  NSDictionary *result = [responseObject objectForKey:@"jsondata"];
                  if ([[result objectForKey:@"retCode"] isEqualToString:@"0000"]) {
                      // 清除设备号。
                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_DEVICE_NUMBER];
                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_WIFI_CONFIGURED];
                      [AccountManager sharedAccountManager].loginModel.deviceno = @"";
                      // 更新界面状态。
                      [self updateUI:@"Search Device" State:false];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Unbind device failed: %@", error);
                  [self showWarningTip:@"Failure, please check the network "];
              }];

    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];

    
    
    
    
    
    
    
    
    
 }

/**
 *  绑定/解除绑定设备
 *
 *  @param sender
 */
- (IBAction)onUnbindButtonClicked:(id)sender {
    // 搜索设备并绑定。
    if ([AppUtil isBlankString:strDeviceNo] && [AppUtil isBlankString:[AccountManager sharedAccountManager].loginModel.deviceno]) {
        BindDeviceViewControler *bindView = [[BindDeviceViewControler alloc] initWithNibName:@"BindDeviceViewControler" bundle:nil];
        [self.navigationController pushViewController:bindView animated:YES];
    }
    // 解除绑定。
    else {
        [self doUnbindRequest];
    }
}

/**
 *  修改网络配置
 *
 *  @param sender
 */
- (IBAction)onResolveButtonClicked:(id)sender {
    if ([AppUtil isBlankString:strDeviceNo]) {
        
        if ([AppUtil isBlankString:[AccountManager sharedAccountManager].loginModel.deviceno]) {
            
            
        }else
        {
            
            WifiViewController *wifiView = [[WifiViewController alloc] initWithNibName:@"WifiViewController" bundle:nil];
            [self.navigationController pushViewController:wifiView animated:YES];
            return;
        }
        
    }
    // 设置网络配置。
    else {
        WifiViewController *wifiView = [[WifiViewController alloc] initWithNibName:@"WifiViewController" bundle:nil];
        [self.navigationController pushViewController:wifiView animated:YES];
    }
}

/**
 *  更新界面按钮状态
 *
 *  @param title 绑定按钮标题
 */
- (void)updateUI:(NSString *)title State:(BOOL)enable {
    unbindButton.enabled = YES;
    unbindButton.backgroundColor = GREEN_COLOR;
    [unbindButton setTitle:title forState:UIControlStateNormal];

    // 使能功能按钮。
    if (enable) {
        resolveButton.backgroundColor = GREEN_COLOR;
        resolveButton.enabled = TRUE;
    } else {
        resolveButton.backgroundColor = GRAY_COLOR;
        resolveButton.enabled = FALSE;

        deviceNumberEdit.text = NSLocalizedString(@"EquipmentNo", nil);
        incodeEdit.text = NSLocalizedString(@"AccessCode", nil);
        strDeviceNo = strConfigResult = @"";
    }
}

@end
