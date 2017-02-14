
//
//  RepositoryViewController.m
//  funpaw
//
//  Created by czx on 2017/2/13.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "RepositoryViewController.h"
#import "ReposialreaduploadViewController.h"
#import "ReposinotuploadViewController.h"


@interface RepositoryViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic,strong)UIButton * leftBtn;
@property (nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,strong)UILabel * lineLabel;
@property(nonatomic,strong)UIImagePickerController * imagePicker;

@property UIPageViewController *pageViewController;
@property (assign) id<UIScrollViewDelegate> origPageScrollViewDelegate;

@property (nonatomic, strong)NSArray *viewControllers;

@property (nonatomic,strong)ReposialreaduploadViewController * VideoVc;
@property (nonatomic,strong)ReposinotuploadViewController * PicVc;
@property (nonatomic,assign)BOOL isupload;
@property (nonatomic,assign)BOOL isselect;

@end

@implementation RepositoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"Video"];
    self.view.backgroundColor = GRAY_COLOR;
    _isupload = NO;
    _isselect = NO;
    [self showBarButton:1 title:@"select" fontColor:[UIColor whiteColor] hide:NO];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //shangchuanbutton
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonBian) name:@"shangchuanbutton" object:nil];
}
-(void)buttonBian{
    _isselect = !_isselect;
    if (_isselect == NO) {
        [self showBarButton:1 title:@"select" fontColor:[UIColor whiteColor] hide:NO];
    }else{
        [self showBarButton:1 title:@"cancel" fontColor:[UIColor whiteColor] hide:NO];
    }
}


-(void)doRightButtonTouch{

    _isselect = !_isselect;
    if (_isselect == NO) {
        [self showBarButton:1 title:@"select" fontColor:[UIColor whiteColor] hide:NO];
    }else{
        [self showBarButton:1 title:@"cancel" fontColor:[UIColor whiteColor] hide:NO];
    }
    if (_isupload == NO) {
        //[self showBarButton:1 title:@"dada" fontColor:[UIColor whiteColor] hide:NO];
        //已上传
         [[NSNotificationCenter defaultCenter]postNotificationName:@"yishangchuan" object:nil];
    }else{
////    [self showBarButton:1 title:@"dada22" fontColor:[UIColor whiteColor] hide:NO];
//        //未上传
//        
//        
    }



}



-(void)setupView{
    [super setupView];
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375 * W_Wide_Zoom, 44 * W_Hight_Zoom)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];

    _leftBtn =[[UIButton alloc]initWithFrame:CGRectMake(117 * W_Wide_Zoom , 7 * W_Hight_Zoom, 70 * W_Wide_Zoom , 30 * W_Hight_Zoom )];
    [_leftBtn setTitle:@"Oncloud" forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    _leftBtn.selected = YES;
    
    [_leftBtn addTarget:self action:@selector(leftbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_leftBtn];
    
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(122 * W_Wide_Zoom, 38 * W_Hight_Zoom, 50 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
    _lineLabel.backgroundColor = GREEN_COLOR;
    [topView addSubview:_lineLabel];
    
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(197 * W_Wide_Zoom, 7 * W_Hight_Zoom, 70 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    [_rightBtn setTitle:@"Local" forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    _rightBtn.selected = NO;
    [_rightBtn addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_rightBtn];
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    _pageViewController.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    
    _VideoVc = [[ReposialreaduploadViewController alloc]init];
    _PicVc = [[ReposinotuploadViewController alloc]init];
    
    _viewControllers = @[_VideoVc, _PicVc];
    
    [_pageViewController setViewControllers:@[_VideoVc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
}

-(void)leftbuttonTouch{
    _isupload = NO;
    [self showBarButton:1 title:@"select" fontColor:[UIColor whiteColor] hide:NO];
    //_isselect = !_isselect;
     [[NSNotificationCenter defaultCenter]postNotificationName:@"yishangchuanbianbian" object:nil];
    
    _leftBtn.selected = YES;
    _rightBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _lineLabel.frame = CGRectMake(122 * W_Wide_Zoom, 38 * W_Hight_Zoom, 50 * W_Wide_Zoom, 1 * W_Hight_Zoom);
    }];
    
    [self.pageViewController setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)rightButtonTouch{
    _isupload = YES;
    [self showBarButton:1 title:@"select" fontColor:[UIColor whiteColor] hide:NO];
    //_isselect = !_isselect;
    _leftBtn.selected = NO;
    _rightBtn.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _lineLabel.frame = CGRectMake(202 * W_Wide_Zoom, 38 * W_Hight_Zoom, 50 * W_Wide_Zoom, 1 * W_Hight_Zoom);
        
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
    
    if ([self.VideoVc isEqual:viewController]) {
        [self leftbuttonTouch];
    }else if([self.PicVc isEqual:viewController]) {
        [self rightButtonTouch];
    }
}









@end