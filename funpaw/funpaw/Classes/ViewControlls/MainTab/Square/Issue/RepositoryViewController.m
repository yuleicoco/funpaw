//
//  RepositoryViewController.m
//  petegg
//
//  Created by czx on 16/4/22.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "RepositoryViewController.h"
#import "RepositoryVideoViewController.h"
#import "RepositorySnapshotViewController.h"

@interface RepositoryViewController ()<UIScrollViewDelegate, UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property(nonatomic,strong)UIButton * leftButton;
@property(nonatomic,strong)UIButton * rightButton;
@property(nonatomic,strong)UILabel * lineLabel;
@property UIPageViewController *pageViewController;
@property (assign) id<UIScrollViewDelegate> origPageScrollViewDelegate;

@property (nonatomic, strong)NSArray *viewControllers;

@property (nonatomic,strong)RepositoryVideoViewController * videoVC;
@property (nonatomic,strong)RepositorySnapshotViewController * snapshotVc;

@end

@implementation RepositoryViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTopView];
    [self setNavTitle:@"资源库"];
}


-(void)setupData{
    [super setupData];
}

-(void)initTopView{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 60 * W_Hight_Zoom, self.view.width, 40 * W_Hight_Zoom)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    _leftButton =[[UIButton alloc]initWithFrame:CGRectMake(73.75 * W_Wide_Zoom , 5 * W_Hight_Zoom, 40 * W_Wide_Zoom , 30 * W_Hight_Zoom )];
    [_leftButton setTitle:@"视频" forState:UIControlStateNormal];
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
    [_rightButton setTitle:@"抓拍" forState:UIControlStateNormal];
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
    //64
    _pageViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    _videoVC = [[RepositoryVideoViewController alloc]init];
    _snapshotVc = [[RepositorySnapshotViewController alloc]init];
    
    _viewControllers = @[_videoVC, _snapshotVc];
    
    [_pageViewController setViewControllers:@[_videoVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
}


-(void)leftbuttonTouch{

        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频和抓拍只能选择一种发布，您要放弃抓拍选择视频？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            _leftButton.selected = YES;
            _rightButton.selected = NO;
            [UIView animateWithDuration:0.3 animations:^{
                _lineLabel.frame = CGRectMake(81.75 * W_Wide_Zoom, 31 * W_Hight_Zoom, 24 * W_Wide_Zoom, 1.2 * W_Hight_Zoom);
            }];
            
            [self.pageViewController setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
            NSLog(@"取消");
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];

    
    
    
    
}

-(void)rightButtonTouch{
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频和抓拍只能选择一种发布，您要放弃视频选择抓拍？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
      
        
        _leftButton.selected = NO;
        _rightButton.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _lineLabel.frame = CGRectMake(269.25 * W_Wide_Zoom, 31 * W_Hight_Zoom, 24 * W_Wide_Zoom, 1.2 * W_Hight_Zoom);
            
        }];
        
        [self.pageViewController setViewControllers:@[self.viewControllers[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    

    
    
  
    
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
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    UIViewController *viewController = self.pageViewController.viewControllers[0];
  
    if ([self.videoVC isEqual:viewController]) {
        [self leftbuttonTouch];
    }else if([self.snapshotVc isEqual:viewController]) {
        [self rightButtonTouch];
    }
    
}




@end
