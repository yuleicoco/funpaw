//
//  RecommendViewController.m
//  petegg
//
//  Created by ldp on 16/3/23.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "RecommendViewController.h"

#import "AFHttpClient+Square.h"

#import "RecommendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "sys/utsname.h"
#import "CycleScrollView.h"
#import "DetailViewController.h"
#import "PersonDetailViewController.h"
#import "AFHttpClient+IsfriendClient.h"

#import "UIImage-Extensions.h"
#import "FeaturedViewController.h"

static NSString * cellId = @"recommeCellId";

@interface RecommendViewController ()
@property (nonatomic,strong)CycleScrollView * topScrollView;
@end

@implementation RecommendViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dada) name:@"shuaxin" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dada2) name:@"dianzanbian" object:nil];
    //dianzanbian
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)dada{
    [self initRefreshView];
    // [self loadDataSourceWithPage:1];
}
-(void)dada2{
    [self loadDataSourceWithPage:1];

}
- (void)setupView{
    [super setupView];
    _topScrollView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 170 * W_Hight_Zoom) animationDuration:3];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - STATUS_BAR_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT);
 
    
    
    
    
    
    [self.tableView registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.tableHeaderView = _topScrollView;
    
    [self initRefreshView];
    
}

-(void)setupData{
    [super setupData];
    //topview
    [[AFHttpClient sharedAFHttpClient]queryRecommendWithcomplete:^(BaseModel *model) {
        
        [self.dataSourceImage addObjectsFromArray:model.list];
        
        [self initTopView];
    } failure:^{
        
    }];
    
}

- (void)loadDataSourceWithPage:(int)page {
    [[AFHttpClient sharedAFHttpClient] queryFollowSproutpetWithMid:[AccountManager sharedAccountManager].loginModel.mid pageIndex:page pageSize:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
        
        if (page == START_PAGE_INDEX) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:model.list];
        } else {
            [self.dataSource addObjectsFromArray:model.list];
        }
        
        if (model.list.count < REQUEST_PAGE_SIZE){
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
        }

        [self.tableView reloadData];
        [self handleEndRefresh];
        
    } failure:^{
        [self handleEndRefresh];
    }];
    
   
    
}

-(void)initTopView{
    NSMutableArray * arrList =[[NSMutableArray alloc]init];
    NSMutableArray * textList =[[NSMutableArray alloc]init];
    NSMutableArray * aidList = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < self.dataSourceImage.count; i++) {
       SquareModel * model  = self.dataSourceImage[i];
        UIImageView * pImageView1 =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 170 * W_Hight_Zoom)];
        [pImageView1 sd_setImageWithURL:[NSURL URLWithString:model.frontcover] placeholderImage:[UIImage imageNamed:@"segouploade.png"]];
        //[textList addObject:_imageArr[i][@"title"]];
        [textList addObject:model.title];
        [arrList addObject:pImageView1];
        [aidList addObject:model.aid];
    }
    _topScrollView.textArr = textList;
    _topScrollView.fetchContentViewAtIndex=  ^UIView *(NSInteger pageIndex){
        return arrList[pageIndex];
    };
    
    _topScrollView.totalPagesCount = ^NSInteger(void){
        return arrList.count;
    };
    
    _topScrollView.TapActionBlock = ^(NSInteger pagIndex){
    
        //这里写点击事件
       // NSLog(@"%@",aidList[pagIndex]);
        FeaturedViewController * featureVc = [[FeaturedViewController alloc]init];
      //  NSInteger i  = (NSInteger)aidList[pagIndex];
        NSString * i = aidList[pagIndex];
        featureVc.number = i;
        [self.navigationController pushViewController:featureVc animated:YES];
        
    };

}


#pragma mark - TableView的代理函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 370*W_Hight_Zoom;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    //把数据给model
    SquareModel * model = self.dataSource[indexPath.row];

   //cell赋值
    if ([model.type isEqualToString:@"pv"] || [model.type isEqualToString:@"v"]) {
        cell.mvImageview.hidden = NO;
    }else{
        cell.mvImageview.hidden = YES;
    }
    
    
    cell.nameLabel.text = model.nickname;
    [cell.iconImageV.layer setMasksToBounds:YES];
    NSString * imageStr = [NSString stringWithFormat:@"%@",model.headportrait];
    NSURL * imageUrl = [NSURL URLWithString:imageStr];
    [cell.iconImageV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    cell.iconImageV.layer.cornerRadius = cell.iconImageV.bounds.size.width/2;
    UIButton * touchButton = [[UIButton alloc]initWithFrame:cell.iconImageV.frame];
    [touchButton addTarget:self action:@selector(iconImageVTouch:) forControlEvents:UIControlEventTouchUpInside];
    touchButton.tag = indexPath.row + 9;
    [cell addSubview:touchButton];

    if (model.cutImage) {
        cell.photoView.image = model.cutImage;
    }else{
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:model.thumbnails] placeholderImage:[UIImage imageNamed:@"sego.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                cell.photoView.image = [image imageByScalingProportionallyToSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)];
                model.cutImage = cell.photoView.image;
            }
        }];
    }
    
    
    
    UIButton * photoViewBtn = [[UIButton alloc]initWithFrame:cell.photoView.frame];
    photoViewBtn.tag = indexPath.row + 11;
    [photoViewBtn addTarget:self action:@selector(photoButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:photoViewBtn];
    
    
    
    cell.introduceLable.text = model.content;
    
    cell.timeLable.text = model.publishtime;
    cell.leftnumber.text = model.comments;
    cell.rihttnumber.text = model.praises;
    
    if ([model.mid isEqualToString:[AccountManager sharedAccountManager].loginModel.mid]) {
        cell.aboutBtn.hidden = YES;
    }else{
        cell.aboutBtn.hidden = NO;
    if ([AppUtil isBlankString:model.isfriend]) {
        cell.aboutBtn.selected = NO;
        [cell.aboutBtn setTitle:@"+关注" forState:UIControlStateNormal];
        
    }else{
        cell.aboutBtn.selected = YES;
        [cell.aboutBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    }
    [cell.aboutBtn addTarget:self action:@selector(attentionTouch:) forControlEvents:UIControlEventTouchUpInside];
    cell.aboutBtn.tag = indexPath.row + 12;
    
    //tabview隐藏点击效果和分割线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



//关注按钮点击事件
-(void)attentionTouch:(UIButton * )sender{
    NSInteger i = sender.tag - 12;
    SquareModel * model = self.dataSource[i];
    NSString * friendId = model.mid;
    
    if (sender.selected == YES) {
        [[AFHttpClient sharedAFHttpClient]optgzWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:friendId type:@"cancel" complete:^(BaseModel *model) {
            //提示
            [[AppUtil appTopViewController] showHint:model.retDesc];
            //刷新界面
            [self loadDataSourceWithPage:1];
            //要用model改一下
        }];
    }else{
   [[AFHttpClient sharedAFHttpClient]optgzWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:friendId type:@"add" complete:^(BaseModel *model) {
       [[AppUtil appTopViewController] showHint:model.retDesc];
       [self loadDataSourceWithPage:1];
       //同上
    }];
    }
}

-(void)iconImageVTouch:(UIButton *)sender{
    NSInteger i = sender.tag - 9;
    
    SquareModel * model = self.dataSource[i];
    NSString * mid = model.mid;
    PersonDetailViewController * personVc = [[PersonDetailViewController alloc]init];
    personVc.ddddd = mid;
    [self.navigationController pushViewController:personVc animated:NO];
   
}

-(void)photoButtonTouch:(UIButton *)sender{
    NSInteger i = sender.tag -11;

    SquareModel * model = self.dataSource[i];
    NSString * stid = model.stid;
    NSLog(@"%@",stid);

    DetailViewController* viewController = [[DetailViewController alloc] init];
    viewController.stid = model.stid;
    [self.navigationController pushViewController:viewController animated:YES];
    
}



@end