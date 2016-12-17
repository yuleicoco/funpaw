//
//  RepositoryVideoViewController.m
//  petegg
//
//  Created by czx on 16/4/22.
//  Copyright © 2016年 sego. All rights reserved.
//
static NSString *headFootFlg = @"up";
static NSString *kfooterIdentifier = @"footerIdentifier111";
static NSString *kheaderIdentifier = @"headerIdentifier111";
#import "RepositoryVideoViewController.h"
#import "AFHttpClient+Issue.h"
#import "MyVideoCollectionViewCell.h"
#import "IssueZiYuankuModel.h"
#import "WechatIssueViewController.h"
@interface RepositoryVideoViewController ()

{
    
    
    NSMutableArray * deleteOrUpdateArr;
    NSMutableArray * thumbnailsAry;
    UIImageView * _deleteImageV;
    UIButton * _deleteBtn;
    
    
}


@end

@implementation RepositoryVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setupView{
    [super setupView];
    [self showBarButton:NAV_RIGHT imageName:@"selecting.png"];
    self.collection.frame = CGRectMake(10, 40, SCREEN_WIDTH-20, SCREEN_HEIGHT-110);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collection.showsHorizontalScrollIndicator = NO;
    self.collection.showsVerticalScrollIndicator   = NO;
    [self.collection registerClass:[MyVideoCollectionViewCell class] forCellWithReuseIdentifier:@"imageId"];
    [self.collection registerNib:[UINib nibWithNibName:@"SQSupplementaryView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];
    [self.collection registerNib:[UINib nibWithNibName:@"HeaderViewCollection" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    self.collection.backgroundColor =[UIColor whiteColor];
    
    _deleteImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, MainScreen.height-105, MainScreen.width, 45)];
    _deleteImageV.userInteractionEnabled = YES;
    _deleteImageV.hidden = YES;
    _deleteImageV.backgroundColor =[UIColor whiteColor];
    _deleteImageV.layer.borderWidth =1;
    _deleteImageV.layer.borderColor =GRAY_COLOR.CGColor;
    
    [self.view addSubview:_deleteImageV];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(_deleteImageV.center.x-15, 5, 30, 30);
//    [_deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [_deleteBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_deleteBtn addTarget:self action:@selector(onDeleBt:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteImageV addSubview:_deleteBtn];
    
    
    [self initRefreshView:@"1"];
    
    
    
}


/**
 *  删除 或者上传
 */

- (void)onDeleBt:(UIButton *)sender
{
    
    if (deleteOrUpdateArr.count>1) {
        // 这里只能上传一个（提示）
        [self showSuccessHudWithHint:@"只能选择一个视频发布"];
    }else if (deleteOrUpdateArr.count == 1){
        NSLog(@"haha");
        WechatIssueViewController * vc = [[WechatIssueViewController alloc]init];
        vc.ziyuanshipArray = deleteOrUpdateArr;
        vc.thumbArry = thumbnailsAry;
        vc.wechatOrziyuanku = @"ziyuankuship";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

-(void)setupData{
    [super setupData];
    deleteOrUpdateArr =[[NSMutableArray alloc]init];
    thumbnailsAry = [[NSMutableArray alloc]init];

}

- (void)data:(NSString *)stateNum pageNum:(int)page
{
    
    [[AFHttpClient sharedAFHttpClient]getVideoWithMid:[AccountManager sharedAccountManager].loginModel.mid pageIndex:page complete:^(BaseModel *model) {
        if (page == 1) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:model.list];
            _deleteImageV.hidden = YES;
            [deleteOrUpdateArr removeAllObjects];
            [thumbnailsAry removeAllObjects];
            
        }else{
            [self.dataSource addObjectsFromArray:model.list];
        }
        
        [self handleEndRefresh];
        [self.collection reloadData];
    }];
    
}
#pragma Mark  --- collectionDelegate


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    IssueZiYuankuModel *model;
    if (self.dataSource.count>0) {
        model = self.dataSource[section];
    }
    NSArray *imageA = [model.thumbnails componentsSeparatedByString:@","];
    
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
    IssueZiYuankuModel * model = self.dataSource[indexPath.section];
    MyVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageId" forIndexPath:indexPath];
    NSArray *imageA = [model.thumbnails componentsSeparatedByString:@","];
     NSString *urlstr = @"";
    if(![AppUtil isBlankString:imageA[indexPath.row]]){
        urlstr = imageA[indexPath.row];
    }
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"sego.png"]];
     cell.imageV.tag = 1000*(indexPath.section+1) +indexPath.row;
    cell.imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapMYP = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onVideo:)];
    [cell.imageV addGestureRecognizer:tapMYP];
    cell.rightBtn.hidden = YES;

    
    return cell;
}


/**
 *  图片点击
 */

- (void)onVideo:(UITapGestureRecognizer *)imageSender
{

    
     NSInteger i = imageSender.view.tag/1000;//分区
        int j = imageSender.view.tag%1000;//每个分区的分组
        IssueZiYuankuModel *model = self.dataSource[i-1];
    
        NSArray *imageA = [model.networkaddress componentsSeparatedByString:@","];
    
        NSArray * thumAr = [model.thumbnails componentsSeparatedByString:@","];
    
        MyVideoCollectionViewCell *cell = (MyVideoCollectionViewCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i-1]];
    
    if (deleteOrUpdateArr.count>=1) {
        if (cell.rightBtn.hidden == NO) {
            cell.rightBtn.hidden = YES;
            cell.rightBtn.selected = NO;
            [deleteOrUpdateArr removeObject:imageA[j]];//把要删除的图片从删除数组中删除
             [thumbnailsAry removeObject:thumAr[j]];
              _deleteImageV.hidden = YES;
        }else{
            [[AppUtil appTopViewController] showHint:@"您只能选择一个视频"];
            return;
        }
    }else{
        if (cell.rightBtn.hidden == YES) {
            cell.rightBtn.hidden = NO;
            cell.rightBtn.selected = YES;
            [deleteOrUpdateArr addObject:imageA[j]];//把要删除的图片加入删除数组
            [thumbnailsAry addObject:thumAr[j]];
        }else{
            cell.rightBtn.hidden = YES;
            cell.rightBtn.selected = NO;
            [deleteOrUpdateArr removeObject:imageA[j]];//把要删除的图片从删除数组中删除
            [thumbnailsAry removeObject:thumAr[j]];
        }
    
    if (deleteOrUpdateArr.count>=1) {
        _deleteImageV.hidden = NO;
    
    }else{
        _deleteImageV.hidden = YES;
    }
     
        
    }
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
        
        IssueZiYuankuModel *model;
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



@end
