//
//  InCallViewController.h
//  petegg
//
//  Created by yulei on 16/3/21.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface InCallViewController :BaseViewController

- (void)setCall:(SephoneCall *)acall;
// 别人
@property (nonatomic,strong)UIView * videoView;
// 返回
@property (nonatomic,strong)UIButton * btnBack;
//等待
@property (nonatomic,strong)UIActivityIndicatorView * flowUI;
//激光笔
@property (nonatomic,strong)UISlider * penSl;
// 激光笔背景
@property (nonatomic,strong)UIImageView * pesnBack;
// 5个button背景
@property (nonatomic,strong)UIImageView * FiveView;

@property (nonatomic,strong)UIImageView * pointTouch;
@property (nonatomic,strong)UILabel * timeLable;
@property (nonatomic,strong)UIButton * pullBtn;
@property(nonatomic,assign)BOOL isOth;
@property(nonatomic,strong)NSString * deviceoOth;
@property(nonatomic,strong)NSString * termidOth;
@end
