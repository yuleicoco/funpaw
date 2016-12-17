//
//  BaseViewController.m
//  petegg
//
//  Created by ldp on 16/3/14.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "BaseViewController.h"
#import "UITabBar+Badge.h"
#import "AFHttpClient+PersonAttention.h"
@implementation BaseViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayColor];
    
    if (self.navigationController) {
        self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
        self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
        self.navigationController.navigationBar.layer.shadowOpacity = 0.4;
        self.navigationController.navigationBar.layer.shadowRadius = 2;
    }
    
    [self setupView];
    
    [self setupData];
}

- (void)setupData{
    
}

- (void)setupView{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftBackButton];
//    [self isMessage];
//    [self isfouceTip];

}

//是否有人关注
-(void)isfouceTip{
        [[AFHttpClient sharedAFHttpClient]focusTipCountWithMid:[AccountManager sharedAccountManager].loginModel.mid  complete:^(BaseModel *model) {
            if (model) {
                if ([model.content isEqualToString:@"0"]) {
                    NSUserDefaults * defeults =[NSUserDefaults standardUserDefaults];
                    [defeults setObject:model.content forKey:@"countfoucetip"];
                    [defeults synchronize];
                }else{
                    NSUserDefaults * defeults =[NSUserDefaults standardUserDefaults];
                    [defeults setObject:model.content forKey:@"countfoucetip"];
                    [defeults synchronize];
                    [self.tabBarController.tabBar showBadgeOnItemIndex:4];
                }

            }
        }];

}



/**
 *  消息提示
 */

- (void)isMessage
{
    NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];
    [dicc setValue:[AccountManager sharedAccountManager].loginModel.mid forKey:@"mid"];
    NSString * service =[NSString stringWithFormat:@"clientAction.do?common=trendTipCount&classes=appinterface&method=json"];
    [AFNetWorking postWithApi:service parameters:dicc success:^(id json) {
        json = [json objectForKey:@"jsondata"] ;
        
        if ([json[@"content"] isEqualToString:@"0"]) {
            
            [self setValue:@"0"];
        }else{
            
            [self setValue:json[@"content"]];
            [self.tabBarController.tabBar showBadgeOnItemIndex:4];
            
        }
    } failure:^(NSError *error) {
    }];
    
}



- (void)setValue:(NSString * )str
{
    
    NSUserDefaults * defeults =[NSUserDefaults standardUserDefaults];
    [defeults setObject:str forKey:@"countMessage"];
    [defeults synchronize];

    
}

/**
 *  设置返回按钮
 */
- (void)setLeftBackButton{
    self.tabBarController.tabBar.hidden= NO;
    NSArray *array = self.navigationController.viewControllers;
    self.navigationItem.backBarButtonItem= nil;
    if (array.count > 1) {
        UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftbutton.frame = CGRectMake(0, 0, 30, 30);
        [leftbutton setTitleEdgeInsets:UIEdgeInsetsMake(-1, -18, 0, 0)];
        [leftbutton setImageEdgeInsets:UIEdgeInsetsMake(-1, -18, 0, 0)];

        [leftbutton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        self.tabBarController.tabBar.hidden= YES;
        
        [self showBarButton:NAV_LEFT button:leftbutton];
    }
}

- (void)showBarButton:(EzNavigationBar)position title:(NSString *)name fontColor:(UIColor *)color{
    UIButton *button ;
    CGSize titleSize = [name boundingRectWithSize:CGSizeMake(999999.0f, NAV_BAR_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    CGRect buttonFrame = CGRectZero;
    
    buttonFrame = CGRectMake(0, 0, titleSize.width, 44);
    
    button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateNormal];
    
    [self showBarButton:position button:button];
}

- (void)showBarButton:(EzNavigationBar)position imageName:(NSString *)imageName{
    UIButton *button ;
    UIImage* image = [UIImage imageNamed:imageName];
    CGRect buttonFrame = CGRectZero;
    
    buttonFrame = CGRectMake(0, 0, image.size.width, NAV_BAR_HEIGHT);
    if ( buttonFrame.size.width < NAV_BUTTON_MIN_WIDTH ){
        buttonFrame.size.width = NAV_BUTTON_MIN_WIDTH;
    }
    
    if ( buttonFrame.size.height < NAV_BUTTON_MIN_HEIGHT ){
        buttonFrame.size.height = NAV_BUTTON_MIN_HEIGHT;
    }
    button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:image forState:UIControlStateNormal];
    
    [self showBarButton:position button:button];
}

- (void)showBarButton:(EzNavigationBar)position button:(UIButton *)button{
    if (NAV_LEFT == position) {
        [button addTarget:self action:@selector(doLeftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }else if (NAV_RIGHT == position){
        [button addTarget:self action:@selector(doRightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)setTitleView:(UIView *)titleView{
    
    self.navigationItem.titleView = titleView;
}

-(void) setNavTitle:(NSString*) navTitle{
    
    // 修改居中问题
    CGSize titleSize =self.navigationController.navigationBar.bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width/2,titleSize.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = WHITE_FG;
    label.textAlignment = NSTextAlignmentCenter;
    label.text=navTitle;
    self.navigationItem.titleView=label;
    
}

- (void)doLeftButtonTouch{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doRightButtonTouch{
    
}

- (void)dealloc{
    
    
}

@end
