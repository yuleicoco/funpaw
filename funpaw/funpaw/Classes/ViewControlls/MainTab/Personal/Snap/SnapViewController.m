//
//  SnapViewController.m
//  petegg
//
//  Created by yulei on 16/4/18.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "SnapViewController.h"
#import "MyVideoCollectionViewCell.h"
#import "PhotoModel.h"
#import "ImageModel.h"
#import "UIImageView+WebCache.h"
#import "LargeViewController.h"


static NSString *headFootFlg = @"up";
static NSString *kfooterIdentifier = @"footerIdentifier";
static NSString *kheaderIdentifier = @"headerIdentifier";
@interface SnapViewController ()

{
    
    BOOL  isSelet;
    NSMutableArray * deleteArr;
    
    
}

@property(nonatomic,strong)UIImageView * deleteImageV;
@property(nonatomic,strong)UIButton * deleteBtn;
@end

@implementation SnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self setNavTitle: @"Snapshot"];
    
}

 -(void)setupView
{
    
    [super setupView];
    
    isSelet = YES;
//     [self showBarButton:NAV_RIGHT imageName:@"selecting.png"];
    [self showBarButton:NAV_RIGHT title:@"Select" fontColor:[UIColor blackColor]];
    
    self.collection.frame = CGRectMake(10, 65, SCREEN_WIDTH-20, SCREEN_HEIGHT-70);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collection.showsHorizontalScrollIndicator = NO;
    self.collection.showsVerticalScrollIndicator   = NO;
    [self.collection registerClass:[MyVideoCollectionViewCell class] forCellWithReuseIdentifier:@"imageId"];
    [self.collection registerNib:[UINib nibWithNibName:@"SQSupplementaryView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];
    [self.collection registerNib:[UINib nibWithNibName:@"HeaderViewCollection" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    self.collection.backgroundColor =[UIColor whiteColor];
    
    // 删除
    
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
    [self initRefreshView:@"0"];



    
    
}

- (void)setupData
{
    [super setupData];
    
    self.dataSource =[[NSMutableArray alloc]init];
    deleteArr =[[NSMutableArray alloc]init];
    
}

/**
 *  选择按钮
 */
- (void)doRightButtonTouch
{
    [deleteArr removeAllObjects];
    if (isSelet) {
//        [self showBarButton:NAV_RIGHT imageName:@"cancel.png"];
        [self showBarButton:NAV_RIGHT title:@"Cancel" fontColor:[UIColor blackColor]];
        isSelet = NO;
        _deleteImageV.hidden = NO;
        
    }else{
        for (int i=0; i<self.dataSource.count; i++) {
            PhotoModel *model = self.dataSource[i];
            NSArray *imageA = [model.networkaddress componentsSeparatedByString:@","];
            
            for (int j=0; j<imageA.count; j++) {
                MyVideoCollectionViewCell *cell = (MyVideoCollectionViewCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                cell.rightBtn.hidden = YES;
                cell.rightBtn.selected = NO;
            }
        }
//        [self showBarButton:NAV_RIGHT imageName:@"selecting.png"];
        [self showBarButton:NAV_RIGHT title:@"Select" fontColor:[UIColor blackColor]];
        
        isSelet = YES;
        _deleteImageV.hidden = YES;
        
    }

    
    
}

/**
 *  删除
 */

-(void)onDeleBt:(UIButton *)sender
{
    
    if (deleteArr.count>0) {//有所需要删除的数据
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to delete the selected images？" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
        
        [alert show];
        
    }else{
        [self showSuccessHudWithHint:@"Please choose to delete the photo!"];
    }

    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        for (int i=0; i<self.dataSource.count; i++) {
            PhotoModel *model = self.dataSource[i];
            NSArray *imageA = [model.imagename componentsSeparatedByString:@","];
            
            for (int j=0; j<imageA.count; j++) {
                MyVideoCollectionViewCell *cell = (MyVideoCollectionViewCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                cell.rightBtn.hidden = YES;
                cell.rightBtn.selected = NO;
            }
            
        }
        
        _deleteImageV.hidden = YES;
        

        NSMutableString *deleStr = [[NSMutableString alloc]init];
        NSString *str = [NSString stringWithFormat:@"%@",deleteArr[0]];
        [deleStr appendFormat:@"%@",str];
        deleStr =[NSMutableString stringWithFormat:@"'%@'",deleStr];
        for (int i=1; i<deleteArr.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@",deleteArr[i]];
            [deleStr appendFormat:@",'%@'",str];
        }
        
        
        
        NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];
        [dicc setValue:[AccountManager sharedAccountManager].loginModel.mid forKey:@"mid"];
        [dicc setValue:deleStr forKey:@"filename"];
        NSString  *  service =[NSString stringWithFormat:@"clientAction.do?common=delPhotoGraph&classes=appinterface&method=json"];
        [AFNetWorking postWithApi:service parameters:dicc success:^(id json) {
            
            json = [json objectForKey:@"jsondata"] ;
            if([[json objectForKey:@"retCode"] isEqualToString:@"0000"]){
                [self showSuccessHudWithHint:@"Delete success"];
                [deleteArr removeAllObjects];
                 [self initRefreshView:@"0"];
//               [self showBarButton:NAV_RIGHT imageName:@"selecting.png"];
                [self showBarButton:NAV_RIGHT title:@"Select" fontColor:[UIColor blackColor]];
                
            }

        } failure:^(NSError *error) {
            
        }];
        
        
       
    }
}




// 请求数据
- (void)data:(NSString *)stateNum pageNum:(int)page
{
    
    if (deleteArr.count>0) {
        
        [self handleEndRefresh];
    }else{
    
    
    NSString * str =@"clientAction.do?method=json&common=getPhotoGraph&classes=appinterface";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    [dic setValue:[AccountManager sharedAccountManager].loginModel.mid forKey:@"mid"];
    [dic setValue:@(page) forKey:@"page"];
    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
        
          json = [[json objectForKey:@"jsondata"]objectForKey:@"list"];
          NSMutableArray * arr =[[NSMutableArray alloc]init];
        
        if (page == START_PAGE_INDEX) {
            [self.dataSource removeAllObjects];
            [arr addObjectsFromArray:json];
            for (NSDictionary *dic0 in arr) {
                 PhotoModel *model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic0];
                [self.dataSource addObject:model];
            }

           
         } else {
            [arr addObjectsFromArray:json];
            for (NSDictionary *dic0 in arr) {
                PhotoModel *model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic0];
                [self.dataSource addObject:model];
            }

           
        }

        
        
        
         [self handleEndRefresh];
         [self.collection reloadData];
        
    } failure:^(NSError *error) {
        
    }];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark  --- collectionDelegate


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    PhotoModel *model;
    if (self.dataSource.count>0) {
        model = self.dataSource[section];
    }
    NSArray *imageA = [model.imagename componentsSeparatedByString:@","];
    
    return imageA.count;
}

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
    PhotoModel *model;
    if (self.dataSource.count>0) {
        model = self.dataSource[indexPath.section];
    }
    NSArray *imageA = [model.networkaddress componentsSeparatedByString:@","];
    
    MyVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageId" forIndexPath:indexPath];
    NSString *urlstr = @"";
    if(![AppUtil isBlankString:imageA[indexPath.row]]){
        urlstr = imageA[indexPath.row];
    }
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"sego.png"]];
    cell.imageV.backgroundColor = [UIColor blackColor];
    cell.imageV.tag = 1000*(indexPath.section+1) +indexPath.row;
    cell.imageV.userInteractionEnabled = YES;
    cell.startImageV.hidden = YES;
    
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
        
        PhotoModel *model;
        if (self.dataSource.count>0) {
            model = self.dataSource[indexPath.section];
        }
        
        NSArray *timeTtile =[model.pgtime componentsSeparatedByString:@","];
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
        
        PhotoModel *model = self.dataSource[i-1];
        NSArray *imageA = [model.imagename componentsSeparatedByString:@","];
        
        MyVideoCollectionViewCell *cell = (MyVideoCollectionViewCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i-1]];
        
        if (cell.rightBtn.hidden == YES) {
            cell.rightBtn.hidden = NO;
            cell.rightBtn.selected = YES;
            [deleteArr addObject:imageA[j]];//把要删除的图片加入删除数组
            
        }else{
            cell.rightBtn.hidden = YES;
            cell.rightBtn.selected = NO;
            [deleteArr removeObject:imageA[j]];//把要删除的图片从删除数组中删除
        }
        
    }else
    {
        
        int i = imageSender.view.tag/1000;//分区
        int j = imageSender.view.tag%1000;
        
        PhotoModel *model = self.dataSource[i-1];
        NSArray *jArr = [model.networkaddress componentsSeparatedByString:@","];
        [deleteArr removeObject:jArr[j]];
        [deleteArr insertObject:jArr[j] atIndex:0];
        
        NSString *strAllimg = [NSString stringWithString:deleteArr[0]];
        for (int kkk = 1; kkk<deleteArr.count; kkk++) {
            strAllimg = [strAllimg stringByAppendingFormat:@",%@",deleteArr[kkk]];
        }
        ImageModel *model1 = [[ImageModel alloc]init];
        model1.imagename = strAllimg;
    
        // 暂时不处理事情
        LargeViewController * largeVC =[[LargeViewController alloc]initWithNibName:@"LargeViewController" bundle:nil];
        largeVC.model = model1;
        
        [self.navigationController pushViewController:largeVC animated:YES];
        
    }
    
}


@end
