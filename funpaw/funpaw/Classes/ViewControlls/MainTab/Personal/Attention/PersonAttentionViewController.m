//
//  PersonAttentionViewController.m
//  petegg
//
//  Created by czx on 16/4/15.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "PersonAttentionViewController.h"
#import "PersonalAtnViewController.h"
#import "PersonalFansViewController.h"
#import "PersonNewAttentionViewController.h"


@interface PersonAttentionViewController ()< UIScrollViewDelegate, UIPageViewControllerDelegate,UIPageViewControllerDataSource>//UIPageViewControllerDataSource
@property(nonatomic,strong)UIButton * leftButton;
@property(nonatomic,strong)UIButton * rightButton;
@property(nonatomic,strong)UILabel * lineLabel;
@property UIPageViewController *pageViewController;
@property (assign) id<UIScrollViewDelegate> origPageScrollViewDelegate;

@property (nonatomic, strong)NSArray *viewControllers;
@property (nonatomic, strong)PersonalAtnViewController * atnVc;
@property (nonatomic, strong)PersonalFansViewController * fansVc;
@property (nonatomic, strong)UIButton * headButton;

@end

@implementation PersonAttentionViewController


-(void)cleanTip{
     _pageViewController.view.frame = CGRectMake(0 * W_Wide_Zoom, 64 * W_Hight_Zoom, self.view.frame.size.width, self.view.frame.size.height * W_Hight_Zoom - 64 * W_Hight_Zoom);
    _headButton.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cleanTip) name:@"isreaddd" object:nil];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"关注"];
    [self initTopView];
   
}
-(void)initTopView{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 60 * W_Hight_Zoom, self.view.width, 40 * W_Hight_Zoom)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    _leftButton =[[UIButton alloc]initWithFrame:CGRectMake(73.75 * W_Wide_Zoom , 5 * W_Hight_Zoom, 40 * W_Wide_Zoom , 30 * W_Hight_Zoom )];
    [_leftButton setTitle:@"关注" forState:UIControlStateNormal];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftButton setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    _leftButton.selected = YES;
    
    [_leftButton addTarget:self action:@selector(leftbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_leftButton];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(81.75 * W_Wide_Zoom, 31 * W_Hight_Zoom, 24 * W_Wide_Zoom, 1.2 * W_Hight_Zoom)];
    _lineLabel.backgroundColor = GREEN_COLOR;
    [topView addSubview:_lineLabel];
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(261.25 * W_Wide_Zoom, 5 * W_Hight_Zoom, 40 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    [_rightButton setTitle:@"粉丝" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    _rightButton.selected = NO;
    [topView addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];

}


-(void)setupView{
    [super setupView];
   
   //如果有新消息，pageviecontroller的位置要发生改变，看了消息之后，还要发送通知让它变回来
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                    options:nil];
    if (self.isredTip == NO) {
          _pageViewController.view.frame = CGRectMake(0 * W_Wide_Zoom, 94 * W_Hight_Zoom, self.view.frame.size.width, self.view.frame.size.height * W_Hight_Zoom - 94 * W_Hight_Zoom );
        _headButton =[[UIButton alloc]initWithFrame:CGRectMake(117.5 * W_Wide_Zoom, 7 * W_Hight_Zoom, 140 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        _headButton.titleEdgeInsets = UIEdgeInsetsMake(0 , 0, 0 , 0);
        [_headButton setBackgroundImage:[UIImage imageNamed:@"moveing.png"] forState:UIControlStateNormal];
        _headButton.backgroundColor = [UIColor blackColor];
        [_headButton setTitle:@"新关注" forState:UIControlStateNormal];
        _headButton.titleLabel.font =[UIFont systemFontOfSize:13];
        _headButton.layer.cornerRadius = 5;
        [_pageViewController.view addSubview:_headButton];
        UILabel * hongdianLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 * W_Wide_Zoom, 12 * W_Hight_Zoom,3 *W_Wide_Zoom, 3 * W_Hight_Zoom)];
        hongdianLabel.backgroundColor = [UIColor redColor];
        [_headButton addSubview:hongdianLabel];
        [_headButton addTarget:self action:@selector(newGuanzhu) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _pageViewController.view.frame = CGRectMake(0 * W_Wide_Zoom, 64 * W_Hight_Zoom, self.view.frame.size.width, self.view.frame.size.height * W_Hight_Zoom - 64 * W_Hight_Zoom);
        
    }
    //64
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    _atnVc = [[PersonalAtnViewController alloc]init];
    _fansVc = [[PersonalFansViewController alloc]init];
    
    _viewControllers = @[_atnVc, _fansVc];
    
    [_pageViewController setViewControllers:@[_atnVc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

}
-(void)leftbuttonTouch{
    _leftButton.selected = YES;
    _rightButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _lineLabel.frame = CGRectMake(81.75 * W_Wide_Zoom, 31 * W_Hight_Zoom, 24 * W_Wide_Zoom, 1.2 * W_Hight_Zoom);
    }];
    
    [self.pageViewController setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)rightButtonTouch{
    _leftButton.selected = NO;
    _rightButton.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _lineLabel.frame = CGRectMake(269.25 * W_Wide_Zoom, 31 * W_Hight_Zoom, 24 * W_Wide_Zoom, 1.2 * W_Hight_Zoom);
        
    }];
    
    [self.pageViewController setViewControllers:@[self.viewControllers[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.viewControllers indexOfObject: viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return self.viewControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.viewControllers indexOfObject: viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.viewControllers count]) {
        return nil;
    }
    return self.viewControllers[index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    //    NSLog(@"willTransitionToViewController: %i", [self indexForViewController:[pendingViewControllers objectAtIndex:0]]);
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    UIViewController *viewController = self.pageViewController.viewControllers[0];
    
    if ([self.atnVc isEqual:viewController]) {
        [self leftbuttonTouch];
    }else if([self.fansVc isEqual:viewController]) {
        [self rightButtonTouch];
    }
}

-(void)newGuanzhu{
    PersonNewAttentionViewController * newVc = [[PersonNewAttentionViewController alloc]init];
    [self.navigationController pushViewController:newVc animated:YES];


}


@end