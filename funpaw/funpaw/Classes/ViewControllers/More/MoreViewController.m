//
//  MoreViewController.m
//  funpaw
//
//  Created by czx on 2017/2/7.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "MoreViewController.h"


@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:NSLocalizedString(@"tabMore_title",nil)];
    UIButton * signoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    signoutBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:signoutBtn];
    [signoutBtn addTarget:self action:@selector(siggnoutButtonTouch) forControlEvents:UIControlEventTouchUpInside];

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







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
