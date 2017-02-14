//
//  More2ViewController.m
//  funpaw
//
//  Created by czx on 2017/2/10.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "More2ViewController.h"
#import "ExchangePasswordViewController.h"
#import "PhotoViewController.h"
#import "RepositoryViewController.h"
@interface More2ViewController ()

@end

@implementation More2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self setNavTitle:NSLocalizedString(@"tabMore_title",nil)];
        UIButton * signoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 400, 100, 100)];
        signoutBtn.backgroundColor = [UIColor blackColor];
        [self.view addSubview:signoutBtn];
        [signoutBtn addTarget:self action:@selector(siggnoutButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        self.view.backgroundColor =LIGHT_GRAY_COLOR;
}

-(void)setupView{
    [super setupView];
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.superview);
        make.right.equalTo(topView.superview);
        make.top.equalTo(topView.superview);
        make.height.mas_equalTo(120);

    }];

    UILabel * linleLabel1 = [[UILabel alloc]init];
    linleLabel1.backgroundColor = LIGHT_GRAY_COLOR;
    [topView addSubview:linleLabel1];
    [linleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(linleLabel1.superview.mas_centerY);
        make.left.equalTo(linleLabel1.superview);
        make.right.equalTo(linleLabel1.superview);
        make.height.mas_equalTo(0.5);

    }];

    UILabel * videoLabel = [[UILabel alloc]init];
    videoLabel.textColor = YELLOW_COLOR;
    videoLabel.font = [UIFont systemFontOfSize:18];
    videoLabel.text = @"Video";
    [topView addSubview:videoLabel];
    [videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(videoLabel.superview.mas_left).offset(12);
        make.top.equalTo(videoLabel.superview.mas_top).offset(20);


    }];

    UIButton * videoBtn = [[UIButton alloc]init];
    videoBtn.backgroundColor = [UIColor clearColor];

    [videoBtn addTarget:self action:@selector(videoButtonTouch) forControlEvents:UIControlEventTouchUpInside];
      [topView addSubview:videoBtn];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(videoBtn.superview);
        make.right.equalTo(videoBtn.superview);
        make.top.equalTo(videoBtn.superview);
        make.bottom.equalTo(linleLabel1.mas_top);

    }];


    UILabel * photoLabel = [[UILabel alloc]init];
    photoLabel.text = @"Photo";
    photoLabel.textColor = YELLOW_COLOR;
    photoLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:photoLabel];
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(photoLabel.superview.mas_left).offset(12);
        make.top.equalTo(linleLabel1.mas_top).offset(20);

    }];

    UIButton * photoBtn = [[UIButton alloc]init];
    photoBtn.backgroundColor = [UIColor clearColor];
    [photoBtn addTarget:self action:@selector(photoButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:photoBtn];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(photoBtn.superview.mas_left);
        make.right.equalTo(photoBtn.superview.mas_right);
        make.top.equalTo(linleLabel1.mas_bottom);
        make.bottom.equalTo(photoBtn.superview.mas_bottom);

    }];

    
}

-(void)photoButtonTouch{
    PhotoViewController * photoVc = [[PhotoViewController alloc]init];
    [self.navigationController pushViewController:photoVc animated:NO];


}


-(void)videoButtonTouch{
//    ExchangePasswordViewController * exchangVc = [[ExchangePasswordViewController alloc]init];
//    [self.navigationController pushViewController:exchangVc animated:NO];
    RepositoryViewController * repostvc = [[RepositoryViewController alloc]init];
    [self.navigationController pushViewController:repostvc animated:NO];
    
    
}


-(void)siggnoutButtonTouch{
  //  FuckLog(@"退出登录");

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"me_tips", nil) preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel_bind", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {


    }]];

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Sure_bind", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStateChange object:@NO];
        [[AccountManager sharedAccountManager]logout];

        NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
     //   NSString * incodeNumStr = [userDefatluts objectForKey:@"incodeNum"];

        for(NSString* key in [dictionary allKeys]){
            [userDefatluts removeObjectForKey:key];
            [userDefatluts synchronize];
        }
        [userDefatluts setObject:@"1" forKey:@"STARTFLAG"];
       // [userDefatluts setObject:incodeNumStr forKey:@"incodeNum"];
    }]];
    [self presentViewController:alert animated:YES completion:nil];



    

}





@end
