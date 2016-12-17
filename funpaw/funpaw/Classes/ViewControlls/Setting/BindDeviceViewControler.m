//
//  BindDeviceViewControler.m
//  petegg
//
//  Created by yulei on 16/3/25.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "BindDeviceViewControler.h"
#import "Reachability.h"
#import "SettingViewController.h"

// sego配置设备名
NSString *const SEGOPASS_BLE_DEVICE_NAME = @"segopass";
// 蓝牙配置服务UUID
NSString *const CONFIG_SERVICE_UUID = @"1f0b6a86-0dd6-440f-8aa6-8d11f3486af0";
// 请求特征
NSString *const REQUEST_CHARACTERISTIC_UUID = @"a2e8d661-0bba-4a61-91e8-dd7ff3d55b27";
// 结果特征
NSString *const RESULT_CHARACTERISTIC_UUID = @"aa78471c-257b-49f6-93a1-8686cadb1fe6";
// 正确结果设备号前缀
NSString *const SEGOEGG_PREFIX = @"segoegg";

@interface BindDeviceViewControler () <UIAlertViewDelegate> {
    CBPeripheralManager *peripheralManager;
    int serviceNum;   // 添加成功的service数量
    BOOL isAccecptOk; // 是否接收结果成功
    NSString * deviceoNum;
    NSTimer * timer;
    NSInteger  timeEnd;
    
    // 错误信息
    NSString *faileStr;
    

    
}

@end

@implementation BindDeviceViewControler

@synthesize bindButton;
@synthesize deviceNumberEdit;
@synthesize hud;

#pragma mark - View Events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
}

/**
 *  初始化界面
 */
- (void)setupView {
    [super setupView];

    self.view.backgroundColor = [UIColor whiteColor];
    self.bindButton.backgroundColor = GRAY_COLOR;
    self.bindButton.enabled = FALSE;
    self.incodeEdit.secureTextEntry = TRUE;

    [self setNavTitle:NSLocalizedString(@"bindDeviceViewTitle", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 创建蓝牙从机。
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    serviceNum = 0;
    isAccecptOk = NO;
    
    
    
}

/**
 *  检查网络状态
 *
 *  @return 是否联网
 */
- (BOOL)checkConnectionAvailable {
    BOOL hasNetwork = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
    // wifi网络可用。
    case ReachableViaWiFi:
        hasNetwork = YES;
        break;
    // 网络不可用。
    case NotReachable:
        hasNetwork = NO;
        [self showWarningTip:NSLocalizedString(@"INFO_NetNoReachable", nil)];
        break;
    // 3G网可用。
    case ReachableViaWWAN:
        hasNetwork = YES;
        [self showWarningTip:NSLocalizedString(@"INFO_ReachableViaWWAN", nil)];
        break;
    }
    return hasNetwork;
}

/**
 *  使能绑定按钮
 */
- (void)enableBindButton {
    self.bindButton.backgroundColor = GREEN_COLOR;
    self.bindButton.enabled = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/**
 *  显示打开蓝牙提示窗
 */
- (void)showNeedBluetoothWaringDialog {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have not yet opened Bluetooth" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"To Set", nil];
    [alert show];
}

/**
 *  提示窗消息处理
 *
 *  @param alertView   提示窗
 *  @param buttonIndex 按钮序号
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 进入蓝牙设置窗口。
    if (buttonIndex == 1) {
        self.view.backgroundColor = [UIColor whiteColor];
        NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

/**
 *  绑定设备
 *
 *  @param sender
 */
- (IBAction)bindButtonClicked:(UIButton *)sender {
    
    
    
        // 检查网络是否可用。
    BOOL hasNetwork = [self checkConnectionAvailable];
    if (!hasNetwork) {
        return;
    }
    NSString *strNumber = self.deviceNumberEdit.text;
    if ([AppUtil isBlankString:strNumber]) {
        [self showWarningTip:@"Device number does not exist"];
        return;
    }
    [self deviceMemer:deviceoNum];

  
}


/**
 *  设备使用记录
 */
- (void)deviceMemer:(NSString *)strdec
{
    
    NSString * str =@"clientAction.do?common=addDevice&classes=appinterface&method=json";
    NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];
    
    [dicc setValue: [AccountManager sharedAccountManager].loginModel.mid                forKey:@"mid"];
    [dicc setValue:strdec   forKey:@"deviceno"];
    [AFNetWorking postWithApi:str parameters:dicc success:^(id json) {
         faileStr =json[@"jsondata"][@"retDesc"];
        if ([json[@"jsondata"][@"retCode"] isEqualToString:@"0000"]) {

            //[self showSuccessHudWithHint:@"Bind successfully"];
            NSString * srt =json[@"jsondata"][@"content"];
            NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:srt forKey:TERMID_DEVICNUMER];
            [defaults setObject:deviceoNum forKey:PREF_DEVICE_NUMBER];
            [defaults synchronize];
            [[AppUtil appTopViewController] showHint:@"Success,please set network"];
            // TODO 实现设备http绑定。
            // 返回上级页面。
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [[AppUtil appTopViewController] showHint:faileStr];
           // [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
    
        [self showSuccessHudWithHint:faileStr];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }];

}




/**
 *  显示警告提示
 */
- (void)showWarningTip:(NSString *)str {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.minSize = CGSizeMake(132.f, 66.0f);
    [hud hide:YES afterDelay:1.0];
}

#pragma mark - Bluetooth Peripheral Manager

/**
 *  将字典对象转为json串
 *
 *  @param dic 字典
 *
 *  @return json串
 */
- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 *  创建ble设备
 *
 *  创建模拟的ble设备，收发绑定请求。
 */
- (void)setUpBleDevice {
    
//    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timestart:) userInfo:nil repeats:YES];
//    [timer setFireDate:[NSDate distantPast]];
    
    // bind请求的参数json对象。
    NSString *strUserid = [AccountManager sharedAccountManager].loginModel.mid;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"bind", @"action", strUserid, @"userid", nil];
    NSString *str = [self dictionaryToJson:params];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];

    // 请求特征：广播bind请求。
    // 创建特征1：请求特征。
    CBMutableCharacteristic *readCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:REQUEST_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyRead value:data permissions:CBAttributePermissionsReadable];

    // 结果特征：接收设备号。
    // 创建特征2：结果特征。
    CBMutableCharacteristic *resultCharacteristic =
        [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:RESULT_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    CBMutableDescriptor *resultCharacteristicDescription = [[CBMutableDescriptor alloc] initWithType:CBUUIDCharacteristicUserDescriptionStringUUID value:@"name"];
    [resultCharacteristic setDescriptors:@[ resultCharacteristicDescription ]];

    // 创建配置服务，加入上述2个特征。
    CBMutableService *configService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:CONFIG_SERVICE_UUID] primary:YES];
    [configService setCharacteristics:@[ readCharacteristic, resultCharacteristic ]];
    [peripheralManager addService:configService];
}

/**
 *  时间
 *
 *  @return 超过5分钟断开
 */

- (void)timestart:(NSTimer*)sender
{
    timeEnd++;
    
}


/**
 *  蓝牙状态更新回调
 *
 *  @param peripheral 蓝牙周边管理器
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
    // 蓝牙开启时，启动sego配置服务。
    case CBPeripheralManagerStatePoweredOn:
        NSLog(@"Bluetooth powered on");

        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Searching for device...";

        [self setUpBleDevice];
        
        break;

    // 蓝牙关闭时，提示用户打开蓝牙。
    case CBPeripheralManagerStatePoweredOff:
        NSLog(@"Bluetooth powered off");

        [self showNeedBluetoothWaringDialog];
        break;

    default:
        break;
    }
}

/**
 *  蓝牙添加服务完成回调
 *
 *  @param peripheral 蓝牙周边管理器
 *  @param service    服务
 *  @param error      错误描述
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error != nil) {
        NSLog(@"Add service error: %@", error);
        return;
    }
    serviceNum++;

    // 添加服务成功后，广播蓝牙ble设备。
    [peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[ [CBUUID UUIDWithString:CONFIG_SERVICE_UUID] ], CBAdvertisementDataLocalNameKey : SEGOPASS_BLE_DEVICE_NAME }];
}

/**
 *  蓝牙开始发送广播
 *
 *  @param peripheral 蓝牙周边管理器
 *  @param error      错误描述
 */
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"peripheralManagerDidStartAdvertisiong");
    NSLog(@"%@",error);
    
}

/**
 *  特征订阅回调
 *
 *  @param peripheral     蓝牙周边管理器
 *  @param central        中心
 *  @param characteristic 被订阅的特征
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"didSubscribeToCharacteristic %@", characteristic.UUID);
}

/**
 *  取消特征订阅回调
 *
 *  @param peripheral     蓝牙周边管理器
 *  @param central        中心
 *  @param characteristic 被取消订阅的特征
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"didUnsubscribeFromCharacteristic %@", characteristic.UUID);
}

/**
 *  读特征回调
 *
 *  @param peripheral 蓝牙周边管理器
 *  @param request    请求
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"didReceiveReadRequest");

    // 判断特征是否有读权限。
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        // 设置特征值。
        NSData *data = request.characteristic.value;
        [request setValue:data];
        [peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }
    // 无读权限，拒绝之。
    else {
        [peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}

/**
 *  写特征回调
 *
 *  @param peripheral 蓝牙周边管理器
 *  @param requests   请求
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    NSLog(@"didReceiveWriteRequests");

    CBATTRequest *request = requests[0];
    // 尚未收到应答，解析之。
    if (isAccecptOk == NO) {
        // 判断特征是否有写权限。
        if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
            CBMutableCharacteristic *vchar = (CBMutableCharacteristic *)request.characteristic; // 转换成CBMutableCharacteristic才能写
            vchar.value = request.value;
            Byte *bytes = (Byte *)[vchar.value bytes];
            NSString *strResult = [[NSString alloc] initWithBytes:bytes length:vchar.value.length encoding:NSUTF8StringEncoding];
            NSLog(@"Get result: %@", strResult);

            [hud hide:YES];

            // 将字符串分割为2个元素的数组。
            NSArray *array = [strResult componentsSeparatedByString:@","];
            if (array == nil || array.count != 2) {
                [self showWarningTip:@"Configuration failed, please re search the device!"];
                //[timer setFireDate:[NSDate distantFuture]];
                return;
            }
            strResult = array[0];
            // 出错了。
            if (![strResult isEqualToString:@"OK"]) {
                [self showWarningTip:@"Configuration failed, please re search the device!"];
                //[timer setFireDate:[NSDate distantFuture]];
                return;
                
            }

            // 设备号以segoegg打头。
            NSString *strNumber = array[1];
            if ([strNumber hasPrefix:SEGOEGG_PREFIX]) {
                isAccecptOk = YES;

                // 取出设备号，更新界面。
                deviceoNum = [strNumber substringFromIndex:SEGOEGG_PREFIX.length];
                self.deviceNumberEdit.text = deviceoNum;
                self.incodeEdit.text = @"123456";
                [self enableBindButton];
                [timer setFireDate:[NSDate distantFuture]];
            }
            //超时
//            if (timeEnd>300) {
//                
//                [self showWarningTip:@"配置超时"];
//               // [timer setFireDate:[NSDate distantFuture]];
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            }
            
            // 出错了。
            else {
                [self showWarningTip:@"Configuration failed, please re search the device"];
                
                self.deviceNumberEdit.text = @"";
                self.incodeEdit.text = @"";
                self.bindButton.enabled = FALSE;
                
                return;
            }

            [peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
        }
        // 无写权限，拒绝之。
        else {
            [peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
        }
    }
    // 忽略多次收到的应答。
    else {
    }
}

/**
 *  蓝牙准备更新订阅者回调
 *
 *  @param peripheral 蓝牙周边管理器
 */
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    NSLog(@"peripheralManagerIsReadyToUpdateSubscribers");
}

@end
