//
//  wifiViewController.m
//  petegg
//
//  Created by yulei on 16/3/22.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "BindDeviceViewControler.h"
#import "Reachability.h"
#import "SettingViewController.h"
#import "WifiViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface WifiViewController () <CBPeripheralManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    CBPeripheralManager *peripheralManager;
    int serviceNum;          // 添加成功的service数量
    BOOL isAccecptOk;        // 是否接收结果成功
    NSArray *encryptionList; // 加密方式数组
    NSString *curEncryption; // 当前加密选项
}

@end

@implementation WifiViewController

@synthesize wifiNameEdit;
@synthesize passwordEdit;
@synthesize selectEncryptionButton;
@synthesize encryptionListTab;
@synthesize okButton;
@synthesize hud;

#pragma mark - View Events

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  初始化页面
 */
- (void)setupView {
    [super setupView];

    self.view.backgroundColor = [UIColor whiteColor];

    encryptionList = @[ @"Public", @"WPA/WPA2", @"WEP" ];
    // 初始化加密方式下拉框。
    encryptionListTab.hidden = YES;
    curEncryption = [NSString stringWithFormat:@"1"];
    if ([encryptionListTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [encryptionListTab setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([encryptionListTab respondsToSelector:@selector(setLayoutMargins:)]) {
        [encryptionListTab setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    encryptionListTab.tableFooterView = [[UIView alloc] init];

    self.okButton.backgroundColor = GREEN_COLOR;
    
    self.wifiNameEdit.text = [self fetchSSIDInfo];
    
    [_showPasswordBtn setImage:[UIImage imageNamed:@"kuang_off.png"] forState:UIControlStateNormal];
    [_showPasswordBtn setImage:[UIImage imageNamed:@"kuang_on.png"] forState:UIControlStateSelected];
    _showPasswordBtn.selected = NO;
    passwordEdit.secureTextEntry = YES;

    [self setNavTitle:NSLocalizedString(@"wifiViewTitle", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  显示密码复选框点击处理
 *
 *  @param sender <#sender description#>
 */
- (IBAction)onShowPasswordButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        passwordEdit.secureTextEntry = NO;
    } else {
        passwordEdit.secureTextEntry = YES;
    }
}

/**
 *  显示警告提示
 */
- (void)showWarningTip:(NSString *)str {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = str;
    hud.minSize = CGSizeMake(132.f, 66.0f);
    [hud hide:YES afterDelay:1.0];
}

/**
 *  确定按钮点击处理
 *
 *  @param sender <#sender description#>
 */
- (IBAction)onOkButtonClicked:(id)sender {
    if ([AppUtil isBlankString:wifiNameEdit.text] || [AppUtil isBlankString:passwordEdit.text]) {
        [self showWarningTip:@"WIFI name or password can not be empty"];
        return;
    }
    // TODO 检查名称或密码中不能有空格。

    // 创建蓝牙从机。
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    serviceNum = 0;
    isAccecptOk = NO;
}

/**
 *  获取当前连接WIFI的名称
 *
 *  @return 
 */
- (NSString *)fetchSSIDInfo {
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            break;
        }
    }
    if (info == nil) {
        return @"";
    }

    return [info objectForKey:@"SSID"];
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
 */
- (void)setUpBleDevice {
    if ([AppUtil isBlankString:wifiNameEdit.text] || [AppUtil isBlankString:passwordEdit.text]) {
        return;
    }

    // setwifi请求的参数json对象。
    NSString *strUserid =[AccountManager sharedAccountManager].loginModel.mid;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"setwifi", @"action", wifiNameEdit.text, @"wifi", passwordEdit.text, @"pass", strUserid, @"userid", curEncryption, @"sec", nil];
    
    NSString *str = [self dictionaryToJson:params];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];

    // 结果特征：接收设置结果。
    // 创建特征2：结果特征。
    CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    CBMutableCharacteristic *resultCharacteristic =
        [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:RESULT_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    CBMutableDescriptor *resultCharacteristicDescription = [[CBMutableDescriptor alloc] initWithType:CBUUIDCharacteristicUserDescriptionStringUUID value:@"name"];
    [resultCharacteristic setDescriptors:@[ resultCharacteristicDescription ]];

    // 请求特征：广播setwifi请求。
    // 创建特征1：请求特征。
    CBMutableCharacteristic *requestCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:REQUEST_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyRead value:data permissions:CBAttributePermissionsReadable];

    // 创建配置服务，加入上述2个特征。
    CBMutableService *configService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:CONFIG_SERVICE_UUID] primary:YES];
    [configService setCharacteristics:@[ resultCharacteristic, requestCharacteristic ]];
    [peripheralManager addService:configService];
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
        hud.labelText = @"Setting network";

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
    if (!isAccecptOk) {
        // 判断特征是否有写权限。
        if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
            CBMutableCharacteristic *vchar = (CBMutableCharacteristic *)request.characteristic; // 转换成CBMutableCharacteristic才能写
            vchar.value = request.value;
            Byte *bytes = (Byte *)[vchar.value bytes];
            NSString *strResult = [[NSString alloc] initWithBytes:bytes length:vchar.value.length encoding:NSUTF8StringEncoding];
            NSLog(@"Get result: %@", strResult);

            [hud hide:TRUE];

            // 将字符串分割为2个元素的数组。
            NSArray *array = [strResult componentsSeparatedByString:@","];
            if (array == nil || array.count != 2) {
               //[self showWarningTip:@"配置失败，请重新设置网络"];
                [[AppUtil appTopViewController] showHint:@"Failed,try again"];
                return;
            }
            strResult = array[0];
            // 出错了。
            if (![strResult isEqualToString:@"OK"]) {
               [[AppUtil appTopViewController] showHint:@"Failed,try again"];
                return;
            }

            // 设备号以segoegg打头。
            NSString *strNumber = array[1];
            if ([strNumber hasPrefix:SEGOEGG_PREFIX]) {
                isAccecptOk = YES;

                // 保持已配置状态。
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:@"1" forKey:PREF_WIFI_CONFIGURED];
                [defaults synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            
                
            } else {
               [[AppUtil appTopViewController] showHint:@"Failed,try again"];
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

#pragma mark - Encryption Select

/**
 *  加密方式下拉按钮点击处理
 *
 *  @param sender <#sender description#>
 */
- (IBAction)selectEncryptionClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    // 显示加密方式下拉列表。
    if (sender.selected) {
        encryptionListTab.hidden = NO;
        encryptionListTab.delegate = self;
        encryptionListTab.dataSource = self;
        [encryptionListTab reloadData];
    }
    // 隐藏加密方式下拉列表。
    else if (!sender.selected) {
        encryptionListTab.hidden = YES;
    }
}

/**
 *  获取加密方式下拉列表列数
 *
 *  @param tableView 下拉列表
 *
 *  @return 列数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 *  获取加密方式下拉列表行数
 *
 *  @param tableView 下拉列表
 *  @param section   列号
 *
 *  @return 行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return encryptionList.count;
}

/**
 *  获取加密方式下拉列表行高度
 *
 *  @param tableView 下拉列表
 *  @param indexPath 行序号
 *
 *  @return 行高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (44 * W_Hight_Zoom);
}

/**
 *  显示加密方式下拉列表单元格时回调
 *
 *  @param tableView 下拉列表
 *  @param cell      单元格
 *  @param indexPath 行序号
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

/**
 *  获取加密方式下拉列表单元
 *
 *  @param tableView 下拉列表
 *  @param indexPath 行序号
 *
 *  @return 行单元
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *showUserInfoCellIdentifier = @"ShowUserInfoCell123";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showUserInfoCellIdentifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    // 设置单元格文本。
    cell.textLabel.text = encryptionList[indexPath.row];

    return cell;
}

/**
 *  选择加密方式下拉列表行的处理
 *
 *  @param tableView 下拉列表
 *  @param indexPath 行序号
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    curEncryption = [NSString stringWithFormat:@"%d", indexPath.row];
    // 更新选择按钮的文本。
    // OPEN
    if (indexPath.row == 0) {
        [self.selectEncryptionButton setTitle:@"Public" forState:UIControlStateNormal];
    }
    // WPA/WPA2
    else if (indexPath.row == 1) {
        [self.selectEncryptionButton setTitle:@"WPA/WPA2" forState:UIControlStateNormal];
    }
    // WEP
    else if (indexPath.row == 2) {
        [self.selectEncryptionButton setTitle:@"WEP" forState:UIControlStateNormal];
    }

    // 隐藏加密方式列表。
    self.encryptionListTab.hidden = YES;
    selectEncryptionButton.selected = NO;
}


- (void)bangdingSheBei
{
    
    NSString * str =@"clientAction.do?common=addDevice&classes=appinterface&method=json";
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    NSString * devicos = [defults objectForKey:@"deviceNumber"];
    NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];
    
    [dicc setValue: [AccountManager sharedAccountManager].loginModel.mid                forKey:@"mid"];
    [dicc setValue:devicos   forKey:@"deviceno"];
    
    [AFNetWorking postWithApi:str parameters:dicc success:^(id json) {
        
        //[self showSuccessHudWithHint:@"绑定成功"];
        [[AppUtil appTopViewController] showHint:@"Complete"];
        // 返回上一级页面。
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [[AppUtil appTopViewController] showHint:@"Failed"];
        
        
    }];
    
    
    
}

@end
