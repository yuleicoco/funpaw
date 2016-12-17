//
//  VideoViewController.m
//  petegg
//
//  Created by yulei on 16/4/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "VideoViewController.h"
#import "MyVideoCollectionViewCell.h"
#import "VideoModel.h"
#import "AFNetWorking.h"
#import "UIImageView+WebCache.h"
#import "ViewControllerss.h"
#import "SettingViewController.h"


static NSString *kfooterIdentifier = @"footerIdentifier";
static NSString *kheaderIdentifier = @"headerIdentifier";
@interface VideoViewController ()
{
    
    BOOL isSelet;
    NSString *statsIdentifi;
    // 选择上传或者删除数组
    NSMutableArray * deleteOrUpdateArr;
    NSTimer * timer;
    AppDelegate *app;
    
    //
  NSString *  termidSelf ;
  NSString *  deviceoSelf ;


    
    
}

@property(nonatomic,strong)UIButton * leftButton;
@property(nonatomic,strong)UIButton * rightButton;
@property(nonatomic,strong)UILabel * lineLabel;
@property(nonatomic,strong)UIImageView * deleteImageV;
@property(nonatomic,strong)UIButton * deleteBtn;
@property(nonatomic,strong)UIButton * updataBtn;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property(nonatomic,strong)UIProgressView * proAccuracy;


@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    [self setNavTitle: @"Video Recording"];
    
   
    
}

// 界面初始化
- (void)setupView
{
    [super setupView];
     app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 选择按钮
    isSelet = YES;
//    [self showBarButton:NAV_RIGHT imageName:@"selecting.png"];
    
    [self showBarButton:NAV_RIGHT title:@"Select" fontColor:[UIColor blackColor]];
    
    // collection
    self.collection.frame = CGRectMake(10, 110, SCREEN_WIDTH-20, SCREEN_HEIGHT-110);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collection.showsHorizontalScrollIndicator = NO;
    self.collection.showsVerticalScrollIndicator   = NO;
    [self.collection registerClass:[MyVideoCollectionViewCell class] forCellWithReuseIdentifier:@"imageId"];
    [self.collection registerNib:[UINib nibWithNibName:@"SQSupplementaryView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];
    [self.collection registerNib:[UINib nibWithNibName:@"HeaderViewCollection" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    self.collection.backgroundColor = [UIColor whiteColor];
    
    
    // 已上传  未上传
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 60 * W_Hight_Zoom, self.view.bounds.size.width, 50 * W_Hight_Zoom)];
    _leftButton =[[UIButton alloc]initWithFrame:CGRectMake(60 * W_Wide_Zoom , 10 * W_Hight_Zoom, 120 * W_Wide_Zoom , 30 * W_Hight_Zoom )];
    _leftButton.centerX = self.view.width * 0.25;
    [_leftButton setTitle:@"Oncloud" forState:UIControlStateNormal];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftButton setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    _leftButton.selected = YES;
    
    [_leftButton addTarget:self action:@selector(leftbuttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_leftButton];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(45 * W_Wide_Zoom, 34 * W_Hight_Zoom, 100 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
    _lineLabel.backgroundColor = GREEN_COLOR;
    [topView addSubview:_lineLabel];
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(250 * W_Wide_Zoom, 10 * W_Hight_Zoom, 120 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _rightButton.centerX = self.view.width * 0.75;
    [_rightButton setTitle:@"Local" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    _rightButton.selected = NO;
    [topView addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(rightButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topView];
    
    // 删除  上传
    _deleteImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, MainScreen.height-45, MainScreen.width, 45)];
    _deleteImageV.userInteractionEnabled = YES;
    _deleteImageV.hidden = YES;
    _deleteImageV.backgroundColor =[UIColor whiteColor];
    _deleteImageV.layer.borderWidth =1;
    _deleteImageV.layer.borderColor =GRAY_COLOR.CGColor;
    
    [self.view addSubview:_deleteImageV];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(_deleteImageV.center.x-15, 5, 30, 30);
    [_deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(onDeleBt:) forControlEvents:UIControlEventTouchUpInside];
    
    [_deleteImageV addSubview:_deleteBtn];
    
    // 左滑 右滑
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    // 进度条
    
    self.proAccuracy=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.proAccuracy.frame=CGRectMake(0, 65, 375, 100);
    self.proAccuracy.trackTintColor=[UIColor blackColor];
    self.proAccuracy.progress=0.0;
    self.proAccuracy.hidden  = YES;
    self.proAccuracy.progressTintColor=GREEN_COLOR;

    //设置进度值并动画显示
    [self.proAccuracy setProgress:0.0 animated:YES];
    [self.view addSubview:self.proAccuracy];

    [self initRefreshView:@"1"];
    

}

        //**********************点击事件******************************\\

/**
 *  选择按钮点击
 */
- (void)doRightButtonTouch
{
    
    [deleteOrUpdateArr removeAllObjects];
    if (isSelet) {
//        [self showBarButton:NAV_RIGHT imageName:@"cancel.png"];
            [self showBarButton:NAV_RIGHT title:@"Cancel" fontColor:[UIColor blackColor]];
        isSelet = NO;
        _deleteImageV.hidden = NO;

    }else{
        for (int i=0; i<self.dataSource.count; i++) {
            VideoModel *model = self.dataSource[i];
            NSArray *imageA = [model.filename componentsSeparatedByString:@","];
            
            for (int j=0; j<imageA.count; j++) {
        MyVideoCollectionViewCell *cell = (MyVideoCollectionViewCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
        cell.rightBtn.hidden = YES;
        cell.rightBtn.selected = NO;
        }
    }
//          [self showBarButton:NAV_RIGHT imageName:@"selecting.png"];
            [self showBarButton:NAV_RIGHT title:@"Select" fontColor:[UIColor blackColor]];
        
         isSelet = YES;
         _deleteImageV.hidden = YES;
        
}
   
    if ([statsIdentifi isEqualToString:@"1"]) {
        [_deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        
    }else if ([statsIdentifi isEqualToString:@"0"]){
        [_deleteBtn setImage:[UIImage imageNamed:@"update.png"] forState:UIControlStateNormal];
        
    }
    
}
/**
 *  删除按钮点击
 */

-(void)onDeleBt:(UIButton *)sender
{
    if ([statsIdentifi isEqualToString:@"1"]) {
    if (deleteOrUpdateArr.count>0) {//有所需要删除的数据
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to delete the selected video？" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
        
        [alert show];
        
    }else{
        [self showSuccessHudWithHint:@"Please choose to delete the photo!"];
    }

        
    }else{
    if (deleteOrUpdateArr.count ==1) {
        self.proAccuracy.hidden = NO;
        NSUserDefaults * standDefauls =[NSUserDefaults standardUserDefaults];
        NSString * devoLG =[AccountManager sharedAccountManager].loginModel.deviceno;
        NSString * termidLG = [AccountManager sharedAccountManager].loginModel.termid;
        NSString * devo  = [standDefauls objectForKey:PREF_DEVICE_NUMBER];
        NSString * termid = [standDefauls objectForKey:TERMID_DEVICNUMER];
        
        if ([AppUtil isBlankString:devoLG]) {
            if ([AppUtil isBlankString:devo]) {
                //没有设备
                
//                 [self showMessageWarring:@"请绑定设备后在上传" view:app.window];
                [self showMessageWarring:@"Please bind the device after uploading" view:app.window];
                return;
            }else{
                termidSelf = termid;
                deviceoSelf = devo;
            }
        }else{
            termidSelf = termidLG;
            deviceoSelf = devoLG;
        }
    if (![AppUtil isBlankString:[standDefauls objectForKey:@"content"]]) {
//        [self showMessageWarring:@"还有视频正在上传" view:app.window];
         [self showMessageWarring:@"There are videos are uploaded" view:app.window];
        
    }else{
    
    NSMutableString *deleStr = [[NSMutableString alloc]init];
    NSString *str = [NSString stringWithFormat:@"%@",deleteOrUpdateArr[0]];
    [deleStr appendFormat:@"%@",str];
    
    NSString * service =[NSString stringWithFormat:@"clientAction.do?common=uploadVideo&classes=appinterface&method=json&filename=%@&mid=%@&termid=%@&deviceno=%@",deleStr,[AccountManager sharedAccountManager].loginModel.mid,termidSelf,deviceoSelf];
   [AFNetWorking postWithApi:service parameters:nil success:^(id json) {
       
       NSLog(@"%@",json);
       
       /**
        *  存取查询开始时间
        */
       NSDictionary *dic1 = [json objectForKey:@"jsondata"] ;
       [standDefauls setObject:[AppUtil getNowTime] forKey:@"endTime"];
       [standDefauls setObject:dic1[@"content"] forKey:@"content"];
       [standDefauls synchronize];
       if([[dic1 objectForKey:@"retCode"] isEqualToString:@"0000"]){
        // 提取视频编号
           //[self showSuccessHudWithHint:@"Uploading, please don't close the application"];
           [[AppUtil appTopViewController] showHint:@"Uploading, please don't close the application"];
           [[NSNotificationCenter defaultCenter]postNotificationName:@"check" object:nil];
           
        NSString  * trdID = dic1[@"content"];
           // 检查视频上传状态
           timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(checkVideoStats:) userInfo:trdID repeats:YES];
           [timer setFireDate:[NSDate distantPast]];
           
           
       }else
       {
        // 上传命令 失败
           NSString * str =[dic1 objectForKey:@"retDesc"];
          [self showSuccessHudWithHint:str];

           
       }
       
   } failure:^(NSError *error) {
       
        // 上传命令 失败
       
   }];
    
    }
        isSelet = YES;
        _deleteImageV.hidden = YES;
          [self showBarButton:NAV_RIGHT title:@"Select" fontColor:[UIColor blackColor]];
        
    }else if (deleteOrUpdateArr.count ==0)
    {
        
//            [self showMessageWarring:@"没有选择视频哦" view:app.window];
        [self showMessageWarring:@"Did not choose the video oh" view:app.window];
        return;
        
    }else
    {
        
//    [self showMessageWarring:@"一次只能选择一个视频上传哦" view:app.window];
        [self showMessageWarring:@"One can only choose a video upload oh" view:app.window];
        return;
        
    }
        
   
    
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSMutableString *deleStr = [[NSMutableString alloc]init];
        
        if (deleteOrUpdateArr.count==1) {
            NSString *str = [NSString stringWithFormat:@"%@",deleteOrUpdateArr[0]];
            [deleStr appendFormat:@"'%@'",str];
        }else
        {
            for (NSInteger i = 0; i<deleteOrUpdateArr.count; i++) {
                NSString *str = [NSString stringWithFormat:@"%@",deleteOrUpdateArr[i]];
                if (i == deleteOrUpdateArr.count-1) {
                    [deleStr appendFormat:@"'%@'",str];
                }else{
                    [deleStr appendFormat:@"'%@',",str];
                    
                }
                
            }
        }
        NSString * service =[NSString stringWithFormat:@"clientAction.do?common=delVideo&classes=appinterface&method=json&filename=%@&mid=%@",deleStr,[AccountManager sharedAccountManager].loginModel.mid];
        [AFNetWorking postWithApi:service parameters:nil success:^(id json) {
            
            NSString * str   =json[@"jsondata"][@"retCode"];
            if([str isEqualToString:@"0000"]){
                //                [self showSuccessHudWithHint:@"删除成功"];
                [self showSuccessHudWithHint:@"Delete success"];
                [self initRefreshView:@"1"];
                [deleteOrUpdateArr removeAllObjects];
                _deleteImageV.hidden  = YES;
                [self showBarButton:NAV_RIGHT title:@"Select" fontColor:[UIColor blackColor]];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        

    }else
    {
        
        
    }



}




// 左滑右滑点击

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self rightButtonTouch:nil];
     }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self leftbuttonTouch:nil];
    }
}


// 数据初始化
- (void)setupData
{
    [super setupData];
    deleteOrUpdateArr =[[NSMutableArray alloc]init];
    statsIdentifi =@"1";
   
    
}

// 请求数据
- (void)data:(NSString *)stateNum pageNum:(int)page
{
    NSString * str =@"clientAction.do?method=json&common=getVideo&classes=appinterface";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    [dic setValue:[AccountManager sharedAccountManager].loginModel.mid forKey:@"mid"];
    [dic setValue:stateNum forKey:@"status"];
    if ([stateNum isEqualToString:@"0"]) {
        [dic setValue:@"1" forKey:@"page"];
        page = 1;
        

    }else{
    [dic setValue:@(page) forKey:@"page"];
    }
    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
        json = [[json objectForKey:@"jsondata"]objectForKey:@"list"];
        NSMutableArray * arr =[[NSMutableArray alloc]init];
        if (page == START_PAGE_INDEX) {
            [self.dataSource removeAllObjects];
            [arr addObjectsFromArray:json];
            for (NSDictionary *dic0 in arr) {
                VideoModel *model = [[VideoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic0];
                [self.dataSource addObject:model];
            }
            
            
        } else {
            [arr addObjectsFromArray:json];
            if (arr.count == 0) {
                
                [self showSuccessHudWithHint:@"No more data oh"];
            }else{
            for (NSDictionary *dic0 in arr) {
                VideoModel *model = [[VideoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic0];
                [self.dataSource addObject:model];
            }
            }
         
            
            
        }
        [self handleEndRefresh];
        [self.collection reloadData];
        
    } failure:^(NSError *error) {
        
    }];
        
        
    
}


- (void)checkVideoStats:(NSTimer *)tid
{
  
    self.proAccuracy.progress= self.proAccuracy.progress+0.1;
    NSString * service =[NSString stringWithFormat:@"clientAction.do?common=queryTask&classes=appinterface&method=json&tid=%@",tid.userInfo];
    [AFNetWorking postWithApi:service parameters:nil success:^(id json) {
        json = [json objectForKey:@"jsondata"] ;
        
        
        NSString *date = [AppUtil getNowTime];
        int dateOver = [self spare:date];
        
        NSUserDefaults *standDefus = [NSUserDefaults standardUserDefaults];
        NSString *dateEnd = [standDefus objectForKey:@"endTime"];
        int dateEndOver = [self spare:dateEnd];
        // dateEndOver = (dateOver -dateEndOver)/60 + (dateOver -dateEndOver)%60;
        dateEndOver = dateOver - dateEndOver;
        
        if(dateEndOver >600)
        {
//            [self showMessageWarring:@"超时" view:app.window];
            [self showMessageWarring:@"Overtime" view:app.window];
            [timer setFireDate:[NSDate distantFuture]];
             [standDefus removeObjectForKey:@"content"];
            
        }else{

            if ([[json objectForKey:@"content"] isEqualToString:@"0"]) {
                // 正在上传
                NSLog(@"上传中");
            }
            if ([[json objectForKey:@"content"] isEqualToString:@"1"]) {
//                [self showMessageWarring:@"上传成功" view:app.window];
                [self showMessageWarring:@"Upload success" view:app.window];
                [standDefus removeObjectForKey:@"content"];
                [self initRefreshView:@"0"];
                self.proAccuracy.progress =1.0;
                self.proAccuracy.hidden  = YES;
                [timer setFireDate:[NSDate distantFuture]];
                
            }
            if ([[json objectForKey:@"content"] isEqualToString:@"2"]) {
//                 [self showMessageWarring:@"上传失败" view:app.window];
                [self showMessageWarring:@"Upload failed" view:app.window];
                [timer setFireDate:[NSDate distantFuture]];
                 [standDefus removeObjectForKey:@"content"];
            }
        
        }
           } failure:^(NSError *error) {
               
        
    }];
    

    
}



#pragma mark - 滑动

- (void)leftbuttonTouch:(UIButton *)state
{
    
    if(state.selected)return;
    state.selected = YES;
    [self performSelector:@selector(timeEnough:) withObject:nil afterDelay:3.0];
    
    [_deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [self initRefreshView:@"1"];
    [self.dataSource removeAllObjects];
    statsIdentifi = @"1";
    _leftButton.selected = YES;
    _rightButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _lineLabel.frame = CGRectMake(50 * W_Wide_Zoom, 34 * W_Hight_Zoom, 100 * W_Wide_Zoom, 1 * W_Hight_Zoom);
    }];
    
    
}


-(void)timeEnough:(UIButton *)btn
{
    btn.selected = NO;
    [timer invalidate];
     timer=nil;
    
}



- (void)rightButtonTouch:(UIButton *)btn
{
    
    
    if(btn.selected)return;
     btn.selected = YES;
    [self performSelector:@selector(timeEnough:) withObject:nil afterDelay:3.0];

    
    [_deleteBtn setImage:[UIImage imageNamed:@"update.png"] forState:UIControlStateNormal];
   [self initRefreshView:@"0"];
    statsIdentifi = @"0";
    [self.dataSource removeAllObjects];
    _leftButton.selected = NO;
    _rightButton.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _lineLabel.frame = CGRectMake(235 * W_Wide_Zoom, 34 * W_Hight_Zoom, 100 * W_Wide_Zoom, 1 * W_Hight_Zoom);
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Mark  --- collectionDelegate

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    VideoModel *model;
    if (self.dataSource.count>0) {
        model = self.dataSource[section];
    }
    NSArray *imageA = [model.filename componentsSeparatedByString:@","];
    
    return imageA.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return self.dataSource.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(MainScreen.width/5+5, MainScreen.width/5+5);
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoModel *model;
    if (self.dataSource.count>0) {
        model = self.dataSource[indexPath.section];
    }
    NSArray *imageA = [model.thumbnails componentsSeparatedByString:@","];
    
    MyVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageId" forIndexPath:indexPath];
    NSString *urlstr = @"";
    if(![AppUtil isBlankString:imageA[indexPath.row]]){
        urlstr = imageA[indexPath.row];
    }
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"sego.png"]];
    cell.imageV.backgroundColor = [UIColor blackColor];
    cell.imageV.tag = 1000*(indexPath.section+1) +indexPath.row;
    cell.imageV.userInteractionEnabled = YES;
    cell.startImageV.hidden = NO;
    cell.rightBtn.hidden = YES;
    

    UITapGestureRecognizer *tapMYP = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onImageVVV:)];
    [cell.imageV addGestureRecognizer:tapMYP];
    
    return cell;
    
}

//头部
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {350,20};
    return size;
}



//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={350,20};
    return size;
}

// heder和footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
  
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = kfooterIdentifier;
        
    }else{
        reuseIdentifier = kheaderIdentifier;
    }
   
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UILabel *label = (UILabel *)[view viewWithTag:2222];
        view.backgroundColor =[UIColor whiteColor];
        
        VideoModel *model;
        if (self.dataSource.count>0) {
            model = self.dataSource[indexPath.section];
        }

        NSArray *timeTtile =[model.opttime componentsSeparatedByString:@","];
        label.text =timeTtile[indexPath.row];
        
        
        
        
    
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UILabel *label = (UILabel *)[view viewWithTag:1111];
        view.backgroundColor =[UIColor whiteColor];
        label.backgroundColor =GRAY_COLOR;

        
    }
    return view;
    
}

// 每张图的点击
- (void)onImageVVV:(UITapGestureRecognizer *)imageSender
{
    
    if (!isSelet) {
    NSInteger i = imageSender.view.tag/1000;//分区
    int j = imageSender.view.tag%1000;//每个分区的分组
    
    VideoModel *model = self.dataSource[i-1];
        
    NSArray *imageA = [model.filename componentsSeparatedByString:@","];
    
    MyVideoCollectionViewCell *cell = (MyVideoCollectionViewCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i-1]];
    
    if (cell.rightBtn.hidden == YES) {
        cell.rightBtn.hidden = NO;
        cell.rightBtn.selected = YES;
        [deleteOrUpdateArr addObject:imageA[j]];//把要删除的图片加入删除数组
        
    }else{
        cell.rightBtn.hidden = YES;
        cell.rightBtn.selected = NO;
        [deleteOrUpdateArr removeObject:imageA[j]];//把要删除的图片从删除数组中删除
    }
    
    }else
    {
        
        if ([statsIdentifi isEqualToString:@"0"]) {
            
        }else
        {
        // 播放视频
        NSInteger i =imageSender.view.tag/1000;
        int j = imageSender.view.tag%1000;
        VideoModel *model = self.dataSource[i-1];
        ViewControllerss * vcPlay =[[ViewControllerss alloc]init];
        // 拼接
        NSString * str = model.networkaddress;
        NSArray * arrNetWorking =[str componentsSeparatedByString:@","];
        vcPlay.playUrl  = arrNetWorking[j];
        [self.navigationController pushViewController:vcPlay animated:NO];
        }
        
    }
    
}

- (int )spare:(NSString *)str
{
    int a =[[str substringWithRange:NSMakeRange(0, 2)] intValue];
    int b =[[str substringWithRange:NSMakeRange(3, 2)] intValue];
    int c=[[str substringWithRange:NSMakeRange(6, 2)] intValue];
    a= a*3600+b*60+c;
    return a;
    
}


@end
