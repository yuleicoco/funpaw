//
//  BindDeviceViewControler.h
//  petegg
//
//  Created by yulei on 16/3/25.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

// sego蓝牙配置服务常量
extern NSString *const SEGOPASS_BLE_DEVICE_NAME;
extern NSString *const CONFIG_SERVICE_UUID;
extern NSString *const REQUEST_CHARACTERISTIC_UUID;
extern NSString *const RESULT_CHARACTERISTIC_UUID;
extern NSString *const SEGOEGG_PREFIX;

/**
 *  绑定设备页面
 */
@interface BindDeviceViewControler : BaseViewController <CBPeripheralManagerDelegate>

// 绑定按钮
@property (strong, nonatomic) IBOutlet UIButton *bindButton;
// 设备号编辑框
@property (strong, nonatomic) IBOutlet UITextField *deviceNumberEdit;
// 接入码编辑框
@property (strong, nonatomic) IBOutlet UITextField *incodeEdit;

// 进度窗
@property (nonatomic, weak) MBProgressHUD *hud;

@end
