//
//  RecordViewController.m
//  petegg
//
//  Created by ldp on 16/6/28.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "RecordViewController.h"

#import "AFHttpClient+Record.h"

#import "MyVideoCollectionViewCell.h"
#import "UIImage-Extensions.h"

#import "ImageModel.h"
#import "LargeViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFHttpClient+InformationChange.h"

static NSString *kfooterIdentifier = @"footerIdentifier";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kRecordheaderIdentifier = @"RecordHeaderIdentifier";

@interface RecordViewController ()
{
    InformationModel * informationModel;
}

@property (nonatomic, strong) UIView *headPortraitView;

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *signatureLabel;


@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageSize = -1;
    
    self.view.backgroundColor =[UIColor whiteColor];
    [self setNavTitle: @"Home"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadInformation) name:NotificationInformationChange object:nil];
}

- (void)setupData {
    [super setupData];
    
    [self.dataSource addObject:[[RecordModel alloc] init]];
   
    [self loadInformation];
}

- (void)loadInformation {
    [[AFHttpClient sharedAFHttpClient]queryByIdMemberWithMid:[AccountManager sharedAccountManager].loginModel.mid complete:^(BaseModel *model) {
        if (model) {
            
            informationModel = model.list[0];
            
            [self performSelectorOnMainThread:@selector(flushHeadView) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)flushHeadView {
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:informationModel.headportrait] placeholderImage:[UIImage imageNamed:@"sego1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.bgImgView.image = [[image cutImage] blurryImageWithBlurLevel:0.2];
        }
    }];
    
    _nameLabel.text = informationModel.nickname;
    _signatureLabel.text = informationModel.signature;
}

-(void)changeName:(NSNotification *)nsnotifition{
    NSString * str = nsnotifition.object;
    _nameLabel.text = str;
}

-(void)changeSignature:(NSNotification *)nsnotifition{
    NSString * str = nsnotifition.object;
    self.signatureLabel.text = str;
}

-(void)initheadImage:(NSNotification *)nsnotifition{
    UIImage * testImage =nsnotifition.object;
    self.headImageView.image = testImage;
    self.bgImgView.image = [[testImage cutImage] blurryImageWithBlurLevel:0.2];
}

-(void)setupView {
    [super setupView];

    self.collectionView.frame = CGRectMake(0, STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT, self.view.width , self.view.height - STATUS_BAR_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator   = NO;
    
    [self.collectionView registerClass:[MyVideoCollectionViewCell class] forCellWithReuseIdentifier:@"imageId"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SQSupplementaryView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderViewCollection" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecordHeaderViewCollection" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kRecordheaderIdentifier];
    
    self.collectionView.backgroundColor =[UIColor whiteColor];
    
    [self initRefreshView];
    
    self.headPortraitView.hidden = NO;
}

- (void)loadDataSourceWithPage:(int)page {
    
    [[AFHttpClient sharedAFHttpClient] queryHomeWithMid:[AccountManager sharedAccountManager].loginModel.mid page:page complete:^(BaseModel *model) {
       
        if (model) {
            
            if (page == START_PAGE_INDEX) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObject:[[RecordModel alloc] init]];
            }
            
            for (RecordModel* recordModel in model.list) {
                recordModel.networkaddressArray = [recordModel.networkaddress componentsSeparatedByString:@","];
                recordModel.thumbailsArray = [recordModel.thumbnails componentsSeparatedByString:@","];
                recordModel.typeArray = [recordModel.type componentsSeparatedByString:@","];
            }
            
            if (model.list.count == 0) {
                self.collectionView.mj_footer.hidden = YES;
            }else{
                self.collectionView.mj_footer.hidden = NO;
            }
            
            
            [self.dataSource addObjectsFromArray:model.list];
            
        }
 
        [self handleEndRefresh];
        
        [self.collectionView reloadData];
    }];
}

- (UIView *)headPortraitView {
    if (!_headPortraitView) {
        
        _headPortraitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.width, 200 * W_Hight_Zoom)];
        
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0 * W_Wide_Zoom,0 * W_Hight_Zoom,375 * W_Wide_Zoom,200 * W_Hight_Zoom)];
        [_headPortraitView addSubview:_bgImgView];
        [_headPortraitView sendSubviewToBack:_bgImgView];
        
        _headImageView =[[UIImageView alloc]initWithFrame:CGRectMake(_headPortraitView.width / 2 - 40, self.view.origin.y+30*W_Hight_Zoom, 80, 80)];
        _headImageView.image = [UIImage imageNamed:@"sego1"];
        
        [_headImageView.layer setMasksToBounds:YES];
        [_headImageView.layer setCornerRadius:40]; //设置矩形四个圆角半径
        [_headPortraitView addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*W_Wide_Zoom, 20*W_Hight_Zoom)];
        _nameLabel.text = @"";
        _nameLabel.center = CGPointMake(self.view.center.x, _headImageView.frame.origin.y+100*W_Hight_Zoom);
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        [_headPortraitView addSubview:_nameLabel];
        
        _signatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*W_Wide_Zoom, 20*W_Hight_Zoom)];
        _signatureLabel.text = @"";
        _signatureLabel.center = CGPointMake(self.view.center.x, _nameLabel.bottom + 20);
        _signatureLabel.font = [UIFont systemFontOfSize:15];
        _signatureLabel.textAlignment = NSTextAlignmentCenter;
        _signatureLabel.textColor = [UIColor whiteColor];
        [_headPortraitView addSubview:_signatureLabel];
    }
    
    return _headPortraitView;
}

#pragma Mark  --- collectionDelegate


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    
    RecordModel *model = self.dataSource[section];
    
    return model.thumbailsArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.width - 4 * 10 ) / 4 , (collectionView.width - 4 * 10 ) / 4);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return nil;
    }
    
    RecordModel *model = self.dataSource[indexPath.section];
    
    MyVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageId" forIndexPath:indexPath];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.thumbailsArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"sego.png"]];
    cell.imageV.backgroundColor = [UIColor blackColor];
    cell.imageV.tag = 1000*(indexPath.section+1) +indexPath.row;
    cell.imageV.userInteractionEnabled = YES;
    
    if ([model.typeArray[indexPath.row] isEqualToString:@"video"]) {
        cell.startImageV.hidden = NO;
    }else{
        cell.startImageV.hidden = YES;
    }
    
    return cell;
}


//头部
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size;
    
    if (section == 0) {
        size = CGSizeMake(self.collectionView.width, 200 * W_Hight_Zoom);
    }else {
        size = CGSizeMake(self.collectionView.width, 20);
    }
    
    return size;
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size ;
    
    if (section == 0) {
        size = CGSizeZero;
    }else{
        size = CGSizeMake(self.collectionView.width, 20);
    }
    
    return size;
}

// heder和footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    UICollectionReusableView *view;
    
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = kfooterIdentifier;
        view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        UILabel *label = (UILabel *)[view viewWithTag:1111];
        view.backgroundColor =[UIColor whiteColor];
        label.backgroundColor =GRAY_COLOR;
    }else if(indexPath.section == 0){
        reuseIdentifier = kRecordheaderIdentifier;
        view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
        if (![view.subviews containsObject:self.headPortraitView]) {
            [view addSubview:self.headPortraitView];
        }
    }else{
        reuseIdentifier = kheaderIdentifier;
        view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
        UILabel *label = (UILabel *)[view viewWithTag:2222];
        view.backgroundColor =[UIColor whiteColor];
        
        RecordModel *model = self.dataSource[indexPath.section];
        
        label.text = model.time;
    }
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecordModel *model = self.dataSource[indexPath.section];
    
    if ( [@"image" isEqualToString: model.typeArray[indexPath.row]] ) {
        ImageModel *model1 = [[ImageModel alloc]init];
        model1.imagename = model.networkaddressArray[indexPath.row];
        
        // 暂时不处理事情
        LargeViewController * largeVC =[[LargeViewController alloc]initWithNibName:@"LargeViewController" bundle:nil];
        largeVC.model = model1;
        
        [self.navigationController pushViewController:largeVC animated:YES];     
    }else{
        MPMoviePlayerViewController * vc = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:model.networkaddressArray[indexPath.row]]];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
        [self presentMoviePlayerViewControllerAnimated:vc];
    }
}

@end
