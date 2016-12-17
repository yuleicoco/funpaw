//
//  SquareViewController.m
//  petegg
//
//  Created by ldp on 16/3/14.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "SquareViewController.h"

#import "RecommendViewController.h"
#import "AttentionViewController.h"
#import "IssuePinViewController.h"
#import "WechatShortVideoController.h"
#import "RepositoryViewController.h"


@interface SquareViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource,WechatShortVideoDelegate>

@property(nonatomic,strong)UIButton * leftButton;
@property(nonatomic,strong)UIButton * rightButton;
@property(nonatomic,strong)UILabel * lineLabel;
@property(nonatomic,strong)UIButton * issueBtn;
@property(nonatomic,strong)UIBarButtonItem * petShowBUtton;

@property(nonatomic,strong)UIButton * coverBtn;
@property(nonatomic,strong)UIView * downWhiteView;
@property(nonatomic,strong)UIView * downView;

@property(nonatomic,strong)UIImagePickerController * imagePicker;

@property UIPageViewController *pageViewController;
@property (assign) id<UIScrollViewDelegate> origPageScrollViewDelegate;

@property (nonatomic, strong)NSArray *viewControllers;

@property(nonatomic,strong)RecommendViewController *recommendVC;
@property(nonatomic,strong)AttentionViewController *attentionVC;

@end

@implementation SquareViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    //self.title = NSLocalizedString(@"tabSquare", nil);
    _imagePicker =[[UIImagePickerController alloc]init];
    _imagePicker.delegate= self;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self initUserface];
}

-(void)initUserface{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 200 * W_Wide_Zoom, 50 * W_Hight_Zoom)];
    // topView.backgroundColor =[UIColor whiteColor];
    _leftButton =[[UIButton alloc]initWithFrame:CGRectMake(50 * W_Wide_Zoom , 10 * W_Hight_Zoom, 40 * W_Wide_Zoom , 30 * W_Hight_Zoom )];
    [_leftButton setTitle:NSLocalizedString(@"recommend", nil) forState:UIControlStateNormal];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftButton setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    _leftButton.selected = YES;
    
    [_leftButton addTarget:self action:@selector(leftbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_leftButton];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * W_Wide_Zoom, 40 * W_Hight_Zoom, 18 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
    _lineLabel.backgroundColor = GREEN_COLOR;
    [topView addSubview:_lineLabel];
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(110 * W_Wide_Zoom, 10 * W_Hight_Zoom, 40 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    [_rightButton setTitle:NSLocalizedString(@"sprout", nil) forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    _rightButton.selected = NO;
    [topView addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setTitleView:topView];
    
    [self setTitleView:topView];
    [self showBarButton:NAV_RIGHT imageName:@"btn_new_issue"];

}

- (void)setupView{
    //初始化 pageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    _pageViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    _recommendVC = [[RecommendViewController alloc]init];
    _attentionVC = [[AttentionViewController alloc]init];
    
    _viewControllers = @[_recommendVC, _attentionVC];
     
    [_pageViewController setViewControllers:@[_recommendVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)leftbuttonTouch{
    _leftButton.selected = YES;
    _rightButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _lineLabel.frame = CGRectMake( 60 * W_Wide_Zoom, 40 * W_Hight_Zoom, 18 * W_Wide_Zoom, 1 * W_Hight_Zoom);
           }];
    
    [self.pageViewController setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)rightButtonTouch{
    _leftButton.selected = NO;
    _rightButton.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _lineLabel.frame = CGRectMake(120 * W_Wide_Zoom, 40 * W_Hight_Zoom, 18 * W_Wide_Zoom, 1 * W_Hight_Zoom);

    }];
    
    [self.pageViewController setViewControllers:@[self.viewControllers[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

-(void)yincang:(UIButton * )sender{
    [UIView animateWithDuration:0.3 animations:^{
        _downWhiteView.frame = CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 180 * W_Hight_Zoom);
        _downView.frame = CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom);
        
    }];
    if (900 == sender.tag) {
        sender.hidden = YES;
    }else{
        _coverBtn.hidden = YES;
    }
}

-(void)doRightButtonTouch{
    
    _downWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom , 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 160 * W_Hight_Zoom )];
    _downView = [[UIView alloc]initWithFrame:CGRectMake(0* W_Wide_Zoom , 667* W_Hight_Zoom, 375* W_Wide_Zoom , 40* W_Hight_Zoom)];
    _coverBtn = [[UIButton alloc]initWithFrame:self.view.bounds];
    _coverBtn.backgroundColor = [UIColor blackColor];
    _coverBtn.tag = 900;
    _coverBtn.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:_coverBtn];
    [_coverBtn addTarget:self action:@selector(yincang:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.3 animations:^{
        _downWhiteView.frame = CGRectMake(0* W_Wide_Zoom , 460* W_Hight_Zoom, 375* W_Wide_Zoom , 160* W_Hight_Zoom);
        _downWhiteView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_downWhiteView];
        
        _downView.frame = CGRectMake(0* W_Wide_Zoom , 627* W_Hight_Zoom, 375* W_Wide_Zoom , 40* W_Hight_Zoom);
        _downView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_downView];
              }];
    UIButton * downBtn = [[UIButton alloc]initWithFrame:CGRectMake(0* W_Wide_Zoom , 0* W_Hight_Zoom, 375* W_Wide_Zoom , 40* W_Hight_Zoom)];
    [downBtn setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    downBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_downView addSubview:downBtn];
    downBtn.tag = 901;
    [downBtn addTarget:self action:@selector(yincang:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray * nameArray = @[NSLocalizedString(@"photograph", nil),NSLocalizedString(@"photoalbum", nil),NSLocalizedString(@"repository", nil),NSLocalizedString(@"lvideo", nil)];
    for (int i = 0 ; i < 4; i++ ) {
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0* W_Wide_Zoom , 0 + 40 * i* W_Hight_Zoom , 375* W_Wide_Zoom , 1* W_Hight_Zoom)];
        lineLabel.backgroundColor = GRAY_COLOR;
        lineLabel.alpha = 0.6;
        [_downWhiteView addSubview:lineLabel];
        UIButton * buttones = [[UIButton alloc]initWithFrame:CGRectMake(0* W_Wide_Zoom , 0 + 40 * i* W_Hight_Zoom, 375* W_Wide_Zoom , 40* W_Hight_Zoom)];
        buttones.tag = i;
        [buttones setTitle:nameArray[i] forState:UIControlStateNormal];
        [buttones setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        buttones.titleLabel.font = [UIFont systemFontOfSize:14];
        [_downWhiteView addSubview:buttones];
        [buttones addTarget:self action:@selector(touchSonme:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)touchSonme:(UIButton *)sender{
    if (0 == sender.tag) {
        [self takePhoto];
    }else if (1 == sender.tag){
        [self loacalPhoto];
    }else if (2 == sender.tag){
        NSLog(@"资源库");
         [self yincang:nil];
        RepositoryViewController * rePositoryVc = [[RepositoryViewController alloc]init];
        [self.navigationController pushViewController:rePositoryVc animated:YES];
    
    }else if (3 == sender.tag){
        NSLog(@"小视频");
        [self takeChat];
    }
    
}

#pragma mark - wechat
//仿微信小视频
- (void)takeChat{
    [self yincang:nil];
    WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
    wechatShortVideoController.delegate = self;
    [self.navigationController pushViewController:wechatShortVideoController animated:YES];
}




#pragma mark - Uiimagepicker
  // 拍照
- (void)takePhoto
{
    [self yincang:nil];
  
    NSArray * mediaty = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.mediaTypes = @[mediaty[0]];
        //设置相机模式：1摄像2录像
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //使用前置还是后置摄像头
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //闪光模式
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        _imagePicker.allowsEditing = YES;
    }else
    {
        NSLog(@"打开摄像头失败");
    }
    [self presentViewController:_imagePicker animated:YES completion:nil];
    //[self.navigationController pushViewController:_imagePicker animated:YES];
    
}
//相册选取

- (void)loacalPhoto
{
    [self yincang:nil];
    NSArray * mediaTypers = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.mediaTypes = @[mediaTypers[0],mediaTypers[1]];
        _imagePicker.allowsEditing = YES;
    }
    [self presentViewController:_imagePicker animated:NO completion:nil];
    
}




//得到图片之后的处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    UIImage * getImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //[imageArray addObject:getImage];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    IssuePinViewController * vC = [[IssuePinViewController alloc]init];
    vC.firstImage = getImage;
    [self.navigationController pushViewController:vC animated:YES];

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
    
    if ([self.recommendVC isEqual:viewController]) {
        [self leftbuttonTouch];
    }else if([self.attentionVC isEqual:viewController]) {
        [self rightButtonTouch];
    }
}


-(void)finishWechatShortVideoCapture:(NSURL *)filePath{
    

}

@end
