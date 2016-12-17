//
//  RankViewController.m
//  petegg
//
//  Created by ldp on 16/3/14.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "RankViewController.h"

#import "WeekBangViewController.h"
#import "MonthBangViewController.h"

@interface RankViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property(nonatomic,strong)UIButton * leftButton;
@property(nonatomic,strong)UIButton * rightButton;
@property(nonatomic,strong)UILabel * lineLabel;
@property UIPageViewController *pageViewController;
@property (assign) id<UIScrollViewDelegate> origPageScrollViewDelegate;
@property (nonatomic, strong)NSArray *viewControllers;

@property (nonatomic,strong)WeekBangViewController * weeBangVc;
@property (nonatomic,strong)MonthBangViewController * monthBangVc;

@end

@implementation RankViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initUserface];
}
-(void)initUserface{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    // topView.backgroundColor =[UIColor whiteColor];
    _leftButton =[[UIButton alloc]initWithFrame:CGRectMake(50 , 10, 40 , 30 )];
    [_leftButton setTitle:@"周榜" forState:UIControlStateNormal];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftButton setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    _leftButton.selected = YES;
    
    [_leftButton addTarget:self action:@selector(leftbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_leftButton];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, 18, 1)];
    _lineLabel.backgroundColor = GREEN_COLOR;
    [topView addSubview:_lineLabel];
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(110, 10, 40, 30)];
    [_rightButton setTitle:@"月榜" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    _rightButton.selected = NO;
    [topView addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    //    [self.navigationItem setTitleView:topView];
    
    [self setTitleView:topView];
  //  [self showBarButton:NAV_RIGHT imageName:@"btn_new_issue"];
    
}

-(void)setupView{
    [super setupView];
    //初始化 pageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    _pageViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    
    _weeBangVc = [[WeekBangViewController alloc]init];
    _monthBangVc = [[MonthBangViewController alloc]init];

    _viewControllers = @[_weeBangVc, _monthBangVc];

    [_pageViewController setViewControllers:@[_weeBangVc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

}
-(void)leftbuttonTouch{
    _leftButton.selected = YES;
    _rightButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _lineLabel.frame = CGRectMake(60, 40, 18, 1);
    }];
    
    [self.pageViewController setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)rightButtonTouch{
    _leftButton.selected = NO;
    _rightButton.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _lineLabel.frame = CGRectMake(120, 40, 18, 1);
        
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
    
    if ([self.weeBangVc isEqual:viewController]) {
        [self leftbuttonTouch];
    }else if([self.monthBangVc isEqual:viewController]) {
        [self rightButtonTouch];
    }
}@end
