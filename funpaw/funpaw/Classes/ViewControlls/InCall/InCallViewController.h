//
//  InCallViewController.h
//  petegg
//
//  Created by yulei on 16/3/21.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InCallViewController : UIViewController

- (void)setCall:(SephoneCall *)acall;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UISlider *penSd;
@property (strong, nonatomic) IBOutlet UIView *statsView;
@property (strong, nonatomic) IBOutlet UILabel *timeText;
@property (strong, nonatomic) IBOutlet UIImageView *pointView;
@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *flowerUI;


// 别人

@property(nonatomic,strong)NSString * deviceoOth;
@property(nonatomic,strong)NSString * termidOth;
@property(nonatomic,assign)BOOL isOth;



@property (strong, nonatomic) IBOutlet UIButton *up_btn;
@property (strong, nonatomic) IBOutlet UIButton *left_btn;
@property (strong, nonatomic) IBOutlet UIButton *down_btn;
@property (strong, nonatomic) IBOutlet UIButton *right_btn;
@property (strong, nonatomic) IBOutlet UIButton *left_up_btn;
@property (strong, nonatomic) IBOutlet UIButton *left_down_btn;


@end
