//
//  MainTabViewController.m
//  funpaw
//
//  Created by czx on 2017/2/7.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "MainTabViewController.h"
#import "EggViewController.h"
#import "MoreViewController.h"

@interface MainTabViewController ()
@property (nonatomic,strong)UINavigationController * eggVc;
@property (nonatomic,strong)UINavigationController * moreVc;

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

-(void)setupSubviews{
     self.tabBar.backgroundColor=[UIColor whiteColor];
        self.viewControllers = @[self.eggVc,
                                 self.moreVc];
    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -1);
    self.tabBar.layer.shadowOpacity = 0.4;
    self.tabBar.layer.shadowRadius = 2;
    
    
}
//device
-(UINavigationController *)eggVc{
    if (!_eggVc) {
        EggViewController * vc = [[EggViewController alloc]init];
        vc.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"Device"
                                                    image:[[UIImage imageNamed:@"tab_home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                        selectedImage:[[UIImage imageNamed:@"tab_homedian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        
        _eggVc = [[UINavigationController alloc]initWithRootViewController:vc];
    }

    return _eggVc;
}

-(UINavigationController *)moreVc{
    if ((!_moreVc)) {
        MoreViewController * vc = [[MoreViewController alloc]init];
        vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"More"
                                                     image:[[UIImage imageNamed:@"tab_person"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_persondian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _moreVc =[[UINavigationController alloc]initWithRootViewController:vc];
    }
    
    return _moreVc;
}







-(void)pushViewController:(UIViewController *)viewController{
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        [((UINavigationController*)self.selectedViewController) pushViewController:viewController animated:YES];
        
    }
    


}

@end
