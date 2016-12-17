//
//  BaseViewController.h
//  petegg
//
//  Created by ldp on 16/3/14.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    NAV_LEFT                    =0,
    NAV_RIGHT                   =1,
} EzNavigationBar;

@interface BaseViewController : UIViewController

// 信息量
@property (nonatomic,strong)NSString * count;



- (void)setupData;

- (void)setupView;

- (void)showBarButton:(EzNavigationBar)position title:(NSString *)name fontColor:(UIColor *)color;

- (void)showBarButton:(EzNavigationBar)position imageName:(NSString *)imageName;

- (void)showBarButton:(EzNavigationBar)position button:(UIButton *)button;

- (void)setTitleView:(UIView *)titleView;

- (void)doLeftButtonTouch;

- (void)doRightButtonTouch;

- (void) setNavTitle:(NSString*) navTitle;

@end
