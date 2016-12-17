//
//  PersonDetailViewController.m
//  petegg
//
//  Created by czx on 16/4/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "PersonDataTableViewCell.h"
#import "AFHttpClient+PersonDate.h"
#import "AFHttpClient+Detailed.h"
#import "PersonDetailModel.h"
#import "DetailModel.h"
#import "UIImageView+WebCache.h"
#import "AFHttpClient+ChangepasswordAndBlacklist.h"
#import "DetailViewController.h"
#import "OtherEggViewController.h"
#import "UIImage-Extensions.h"
static NSString * cellId = @"personDetailCellId";
@interface PersonDetailViewController ()

{
    
    UIButton * fanwenBtn;
     NSMutableArray * askRuleArr;
}

@property (nonatomic,strong)UIImageView * headImage; //头像
@property (nonatomic,strong)UIImageView * typeImage; //种类
@property (nonatomic,strong)UIImageView * sexImage;  //性别
@property (nonatomic,strong)UIButton * ageImage;  //年龄
@property (nonatomic,strong)UILabel * qqLabel;       //qq
@property (nonatomic,strong)UILabel * attentionLabel;//关注数量
@property (nonatomic,strong)UILabel * fansLabel;     //粉丝数量
@property (nonatomic,strong)UILabel *autographLabel; //个性签名
@property (nonatomic,strong)UIView * topView;

@end

@implementation PersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    askRuleArr =[[NSMutableArray alloc]init];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)initUseTopView{
    
    PersonDetailModel * model = self.dataSourceImage[0];
    
    //判断是自己或者已被拉黑的人，不显示拉黑按钮
    if ([model.mid isEqualToString:[AccountManager sharedAccountManager].loginModel.mid]|| [model.isinblacklist isEqualToString:@"1"]) {
    
    }else{
        [self showBarButton:NAV_RIGHT imageName:@"addblack.png"];
    }
      [self setNavTitle:model.nickname];
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom, 15 * W_Hight_Zoom, 80 * W_Wide_Zoom, 80 * W_Hight_Zoom)];
    [_headImage.layer setMasksToBounds:YES];
    _headImage.layer.cornerRadius = _headImage.width/2;
    NSString * imageStr = [NSString stringWithFormat:@"%@",model.headportrait];
    NSURL * imageUrl = [NSURL URLWithString:imageStr];
    [_headImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    [_topView addSubview:_headImage];
    
 
    
    _typeImage = [[UIImageView alloc]initWithFrame:CGRectMake(100 * W_Wide_Zoom, 22 * W_Hight_Zoom, 20 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
    if ([model.pet_race isEqualToString:@"汪"]) {
        _typeImage.image = [UIImage imageNamed:@"wangwang.png"];
    }else{
        _typeImage.image = [UIImage imageNamed:@"miaomiao.png"];
    }
    //  _typeImage.layer.cornerRadius = _typeImage.width/2;
    [_topView addSubview: _typeImage];
    
    
    
    _sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(130 * W_Wide_Zoom, 22 * W_Hight_Zoom, 20 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
    if ([model.pet_sex isEqualToString:@"公"]) {
     _sexImage.image = [UIImage imageNamed:@"manquanquan.png"];
    }else{
    _sexImage.image = [UIImage imageNamed:@"womanquanquan.png"];
    }
  //  _sexImage.layer.cornerRadius = _sexImage.width/2;
    [_topView addSubview:_sexImage];
    
    
    
    _ageImage = [[UIButton alloc]initWithFrame:CGRectMake(160 * W_Wide_Zoom, 22 * W_Hight_Zoom, 35 * W_Wide_Zoom, 18 * W_Hight_Zoom)];
    _ageImage.layer.cornerRadius = 10;
    _ageImage.layer.borderWidth = 1;
    _ageImage.layer.borderColor = GREEN_COLOR.CGColor;
    _ageImage.titleLabel.font = [UIFont systemFontOfSize:12];
    [_ageImage setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    NSString * age = [NSString stringWithFormat:@"%@岁",model.pet_age];
    [_ageImage setTitle:age forState:UIControlStateNormal];
    
    
    [_topView addSubview: _ageImage];
    
    UILabel * qq = [[UILabel alloc]initWithFrame:CGRectMake(100 * W_Wide_Zoom, 42 * W_Hight_Zoom, 30 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    qq.text = @"QQ:";
    qq.font = [UIFont systemFontOfSize:14];
    qq.textColor = [UIColor blackColor];
    [_topView addSubview:qq];
    
    _qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(140 * W_Wide_Zoom, 42 * W_Hight_Zoom, 100 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _qqLabel.text = model.qq;
    _qqLabel.font = [UIFont systemFontOfSize:14];
    _qqLabel.textColor = [UIColor blackColor];
    [_topView addSubview:_qqLabel];
    
    
    UILabel * guanzhu = [[UILabel alloc]initWithFrame:CGRectMake(100 * W_Wide_Zoom, 67 * W_Hight_Zoom, 50 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    guanzhu.text = @"关注:";
    guanzhu.textColor = [UIColor blackColor];
    guanzhu.font = [UIFont systemFontOfSize:14];
    [_topView addSubview:guanzhu];
    
    _attentionLabel = [[UILabel alloc]initWithFrame:CGRectMake(140 * W_Wide_Zoom, 67 * W_Hight_Zoom, 30 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _attentionLabel.text = model.gznum;
    _attentionLabel.textColor = [UIColor blackColor];
    _attentionLabel.font = [UIFont systemFontOfSize:14];
    [_topView addSubview:_attentionLabel];
    
    
    UILabel * fensi = [[UILabel alloc]initWithFrame:CGRectMake(170 * W_Wide_Zoom, 67 * W_Hight_Zoom, 50 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    fensi.text = @"粉丝:";
    fensi.textColor = [UIColor blackColor];
    fensi.font = [UIFont systemFontOfSize:14];
    [_topView addSubview:fensi];
    
    _fansLabel = [[UILabel alloc]initWithFrame:CGRectMake(210 * W_Wide_Zoom, 67 * W_Hight_Zoom, 30 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _fansLabel.text = model.fsnum;
    _fansLabel.textColor = [UIColor blackColor];
    _fansLabel.font = [UIFont systemFontOfSize:14];
    [_topView addSubview:_fansLabel];
    
    _autographLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom, 90 * W_Hight_Zoom, 200 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _autographLabel.text = model.signature;
    _autographLabel.textColor = [UIColor blackColor];
    _autographLabel.font = [UIFont systemFontOfSize:14];
    [_topView addSubview:_autographLabel];
    
    
    fanwenBtn =[[UIButton alloc]initWithFrame:CGRectMake(310 * W_Wide_Zoom, 33 * W_Hight_Zoom, 50 * W_Wide_Zoom, 50 * W_Hight_Zoom)];
    [fanwenBtn setTitle:@"互动" forState:UIControlStateNormal];
    [fanwenBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    fanwenBtn.titleLabel.font =[UIFont systemFontOfSize:15];
    [fanwenBtn addTarget:self action:@selector(fangwen:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:fanwenBtn];
    

    
    
    
}


/**
 *  是否可以访问
 */


- (void)openVideo
{
    
    NSString * str = @"clientAction.do?method=json&common=getHomePage&classes=appinterface";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    [dic setValue:self.ddddd forKey:@"friend"];
    [dic setValue:[AccountManager sharedAccountManager].loginModel.mid forKey:@"mid"];
    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
    if ([json[@"jsondata"][@"retCode"] isEqualToString:@"0000"]) {
        if ([json[@"jsondata"][@"list"][0][@"openvideo"] isEqualToString:@"1"]) {
           // 允许
           fanwenBtn.hidden = NO;
            
        }else
        {
            // 不允许
            fanwenBtn.hidden = YES;
            
            
        }
       
        
    }
        
    } failure:^(NSError *error) {
        
    }];
    
    

}


/**
 *  访问数据
 */

- (void)fangwen:(UIButton *)sender
{
    // 查询是否可以访问
    
            
            OtherEggViewController * other =[[OtherEggViewController alloc]init];
            other.otherMid = self.ddddd;
            [self.navigationController pushViewController:other animated:YES];
            
            
      

    
}

/**
 *  访问
 */

-(void)doRightButtonTouch{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要把ta拉入黑名单吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self addBlacklist];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)addBlacklist{
     [[AFHttpClient sharedAFHttpClient]addBlacklistWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:_ddddd complete:^(BaseModel *model)      {
          [[AppUtil appTopViewController] showHint:model.retDesc];
         [self.navigationController popViewControllerAnimated:YES];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxin" object:nil];
     }];
    
    
    
}


-(void)setupView{
    [super setupView];
    //这里后面要改成这用户的名字
  
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.width, 120 * W_Hight_Zoom)];
    _topView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.tableView registerClass:[PersonDataTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableHeaderView = _topView;
    [self initRefreshView];
}

-(void)setupData{
    [super setupData];
    
    [[AFHttpClient sharedAFHttpClient]querPresenWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:_ddddd complete:^(BaseModel *model) {
        [self.dataSourceImage addObjectsFromArray:model.list];
        [self initUseTopView];
        [self openVideo];
    } failure:^{
        
    }];
}

-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]querByIdSproutpetWithFriend:_ddddd pageIndex:page pageSize:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
        
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
//        if (page == START_PAGE_INDEX) {
//            [self.dataSource removeAllObjects];
//            [self.dataSource addObjectsFromArray:model.list];
//        } else {
//            [self.dataSource addObjectsFromArray:model.list];
//        }
//        
//        if (model.list.count < REQUEST_PAGE_SIZE){
//            self.tableView.mj_footer.hidden = YES;
//        }else{
//            self.tableView.mj_footer.hidden = NO;
//        }
//        
//        [self.tableView reloadData];
//        [self handleEndRefresh];
        
    } failure:^{
        [self handleEndRefresh];
    }];


    
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
    return 310*W_Hight_Zoom;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    DetailModel * model = self.dataSource[indexPath.row];
    
    if ([model.type isEqualToString:@"pv"] || [model.type isEqualToString:@"v"]) {
        cell.mvImageview.hidden = NO;
    }else{
        cell.mvImageview.hidden = YES;
    }

    
    
    if (model.cutImage) {
        cell.bigImage.image = model.cutImage;
    }else{
        [cell.bigImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnails] placeholderImage:[UIImage imageNamed:@"sego.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                cell.bigImage.image = [image imageByScalingProportionallyToSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)];
                model.cutImage = cell.bigImage.image;
            }
        }];
    }
    
    cell.dateLabel.text = model.publishtime;
    cell.attentionLabel.text = model.content;
    cell.pinglunLabel.text = model.comments;
    cell.aixinLabel.text = model.praises;
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailModel * model = self.dataSource[indexPath.row];

    //  NSString * stid = model.stid;
    DetailViewController* viewController = [[DetailViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.stid = model.stid;
    [self.navigationController pushViewController:viewController animated:YES];

}






@end