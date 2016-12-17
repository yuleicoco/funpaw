//
//  MonthBangViewController.m
//  petegg
//
//  Created by czx on 16/4/13.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "MonthBangViewController.h"
#import "RankesTableViewCell.h"
#import "AFHttpClient+Rank.h"
#import "RankModel.h"
#import "UIImageView+WebCache.h"
#import "PersonDetailViewController.h"

static NSString * cellId = @"ranksCellIddddddd";
@interface MonthBangViewController ()
@property (nonatomic,strong)UIImageView * topHeadImage;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * aixinLabel;
@property (nonatomic,strong)UILabel * rightLabel;
@end

@implementation MonthBangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)setupView{
    [super setupView];
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, self.view.width, 250 * W_Hight_Zoom)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    self.tableView.frame = CGRectMake(0, 0 * W_Hight_Zoom, self.view.width, self.view.height - STATUS_BAR_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT);
    [self.tableView registerClass:[RankesTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableHeaderView = topView;
    
    UIImageView * huangguan = [[UIImageView alloc]initWithFrame:CGRectMake(213 * W_Wide_Zoom, 11 * W_Hight_Zoom, 45 * W_Wide_Zoom, 45 * W_Hight_Zoom)];
    huangguan.image= [ UIImage imageNamed:@"new_huangguan.png"];
    [topView addSubview:huangguan];

    
    _topHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake(122.5 * W_Wide_Zoom, 40 * W_Hight_Zoom, 130 * W_Wide_Zoom, 130 * W_Hight_Zoom)];
    [_topHeadImage.layer setMasksToBounds:YES];
    _topHeadImage.layer.cornerRadius = _topHeadImage.width/2;
    _topHeadImage.backgroundColor = [UIColor blackColor];
    [topView addSubview:_topHeadImage];
    
    UIButton * touchButton = [[UIButton alloc]initWithFrame:_topHeadImage.frame];
    touchButton.backgroundColor = [UIColor clearColor];
    [touchButton addTarget:self action:@selector(topImageTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchButton];
    
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(122.5 * W_Wide_Zoom, 175 * W_Hight_Zoom, 130 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _nameLabel.textColor = [UIColor blackColor];
    // _nameLabel.text = @"胖子";
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:_nameLabel];
    

    UIImageView * aixinImage = [[UIImageView alloc]initWithFrame:CGRectMake(160 * W_Wide_Zoom, 206 * W_Hight_Zoom, 12 * W_Wide_Zoom, 12 * W_Hight_Zoom)];
    aixinImage.image = [UIImage imageNamed:@"dianzanhou.png"];
    [topView addSubview:aixinImage];
    
    _aixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(180 * W_Wide_Zoom, 202 * W_Hight_Zoom, 100 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
    _aixinLabel.text = @"100";
    _aixinLabel.font = [UIFont systemFontOfSize:12];
    [topView addSubview:_aixinLabel];
    
    _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(300 * W_Wide_Zoom, 190 * W_Hight_Zoom, 100 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
    _rightLabel.textColor = [UIColor brownColor];
    // _rightLabel.text = @"NO.1";
    [topView addSubview:_rightLabel];
}

-(void)topImageTouch{
    RankModel * model = self.dataSource[0];
    PersonDetailViewController * personVc = [[PersonDetailViewController alloc]init];
    personVc.ddddd = model.mid;
    [self.navigationController pushViewController:personVc animated:NO];
    
}



-(void)setupData{
    [super setupData];
    [[AFHttpClient sharedAFHttpClient]queryrankingWithMid:[AccountManager sharedAccountManager].loginModel.mid ranktype:@"month" complete:^(BaseModel *model) {
        [self.dataSource addObjectsFromArray:model.list];
        [self.tableView reloadData];
        [self initDataTop];
    }];
}

-(void)initDataTop{
    RankModel * model = self.dataSource[0];
    _nameLabel.text = model.nickname;
    NSString * imageStr = [NSString stringWithFormat:@"%@",model.headportrait];
    NSURL * imageUrl = [NSURL URLWithString:imageStr];
    [_topHeadImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    _aixinLabel.text = model.praises;
    _rightLabel.text = [NSString stringWithFormat:@"NO.%@",model.ranking];
    
}



#pragma mark - TableView的代理函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count-1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65*W_Hight_Zoom;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    RankModel * model = self.dataSource[indexPath.row + 1];
    RankesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NSString * imageStr = [NSString stringWithFormat:@"%@",model.headportrait];
    NSURL * imageUrl = [NSURL URLWithString:imageStr];
    [cell.headImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    
    
    
    UIButton * touchButton = [[UIButton alloc]initWithFrame:cell.headImage.frame];
    touchButton.backgroundColor = [UIColor clearColor];
    [cell addSubview:touchButton];
    touchButton.tag = indexPath.row + 110;
    [touchButton addTarget:self action:@selector(cellTouchButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.nameLabel.text = model.nickname;
    cell.aixinLabel.text = model.praises;
    cell.rightLabel.text = [NSString stringWithFormat:@"NO.%@",model.ranking];
    if (indexPath.row < 2) {
        cell.rightLabel.textColor = [UIColor brownColor];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)cellTouchButton:(UIButton *)sender{
    NSInteger i = sender.tag - 110;
    RankModel * model = self.dataSource[i + 1];
    PersonDetailViewController * personVc = [[PersonDetailViewController alloc]init];
    personVc.ddddd = model.mid;
    [self.navigationController pushViewController:personVc animated:NO];
    
}
@end
