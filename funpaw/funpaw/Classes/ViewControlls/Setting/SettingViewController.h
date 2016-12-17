//
//  SettingViewController.h
//  petegg
//
//  Created by yulei on 16/3/22.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>

// 设置相关配置项
extern NSString *const PREF_DEVICE_NUMBER;
extern NSString *const PREF_WIFI_CONFIGURED;
extern NSString *const TERMID_DEVICNUMER;

/**
 *  不倒蛋设置界面
 */
@interface SettingViewController : BaseViewController

// 解绑按钮
@property (strong, nonatomic) IBOutlet UIButton *unbindButton;
// 功能按钮，多个用途
@property (strong, nonatomic) IBOutlet UIButton *resolveButton;
// 设备号编辑框
@property (strong, nonatomic) IBOutlet UITextField *deviceNumberEdit;
// 接入码编辑框
@property (strong, nonatomic) IBOutlet UITextField *incodeEdit;

@end
