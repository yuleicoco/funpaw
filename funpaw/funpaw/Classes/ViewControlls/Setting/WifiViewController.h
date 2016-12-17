//
//  wifiViewController.h
//  petegg
//
//  Created by yulei on 16/3/22.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>

/**
 *  wifi设置界面
 */
@interface WifiViewController : BaseViewController

// wifi名称编辑框
@property (strong, nonatomic) IBOutlet UITextField *wifiNameEdit;
// 密码编辑框
@property (strong, nonatomic) IBOutlet UITextField *passwordEdit;
// 选择加密方式按钮
@property (strong, nonatomic) IBOutlet UIButton *selectEncryptionButton;
// 加密方式列表
@property (strong, nonatomic) IBOutlet UITableView *encryptionListTab;
// 确定按钮
@property (strong, nonatomic) IBOutlet UIButton *okButton;

// 进度窗
@property (nonatomic, weak) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UIButton *showPasswordBtn;





@end
