//
//  PersonalFansViewController.m
//  petegg
//
//  Created by czx on 16/4/15.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "PersonalFansViewController.h"
#import "PersonAttentionTableViewCell.h"
#import "AFHttpClient+PersonAttention.h"
#import "NearbyModel.h"
#import "PersonDetailViewController.h"
#import "AFHttpClient+IsfriendClient.h"

static NSString * cellId = @"personAttentionCeliddd";
@interface PersonalFansViewController ()

@end

@implementation PersonalFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setupView{
    [super setupView];
    self.tableView.frame = CGRectMake(0, 40, self.view.width, 563 * W_Hight_Zoom);
    //  [self.tableView registerClass:[PersonDataTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView registerClass:[PersonAttentionTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      [self initRefreshView];

}

-(void)setupData{
    [super setupData];

}

-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]queryFriendWithMid:[AccountManager sharedAccountManager].loginModel.mid ftype:@"fs" pageIndex:page pageSize:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
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
    return 60 * W_Hight_Zoom;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyModel * model = self.dataSource[indexPath.row];
    PersonAttentionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.nameLabel.text = model.nickname;
    
    NSString * imageStr = [NSString stringWithFormat:@"%@",model.headportrait];
    NSURL * imageUrl = [NSURL URLWithString:imageStr];
    [cell.headImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    cell.sinaglLabel.text = model.signature;
    
    UIButton * touBtn = [[UIButton alloc]initWithFrame:cell.headImage.frame];
    touBtn.backgroundColor = [UIColor clearColor];
    touBtn.tag = indexPath.row + 199;
    
    [cell addSubview:touBtn];
    [touBtn addTarget:self action:@selector(headButtonTOuch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if ([model.pet_race isEqualToString:@"汪"]) {
        cell.kindImage.image = [UIImage imageNamed:@"wangwang.png"];
    }else{
        cell.kindImage.image = [UIImage imageNamed:@"miaomiao.png"];
    }
    if ([model.pet_sex isEqualToString:@"公"]) {
        cell.sexImage.image = [UIImage imageNamed:@"manquanquan.png"];
    }else{
        cell.sexImage.image = [UIImage imageNamed:@"womanquanquan.png"];
    }
    
    [cell.rightButton setTitle:@"加关注" forState:UIControlStateNormal];
    cell.rightButton.tag = indexPath.row + 179;
    [cell.rightButton addTarget:self action:@selector(addGuanzhubtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString * age = [NSString stringWithFormat:@"%@岁",model.pet_age];
    [cell.ageButton setTitle:age forState:UIControlStateNormal];
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)headButtonTOuch:(UIButton *)sender{
    NSInteger i =sender.tag - 199;
    NearbyModel * model = self.dataSource[i];
    PersonDetailViewController * personVc = [[PersonDetailViewController alloc]init];
    personVc.ddddd = model.mid;
    [self.navigationController pushViewController:personVc animated:NO];

}

-(void)addGuanzhubtnTouch:(UIButton *)sender{
    NSInteger i = sender.tag - 179;
     NearbyModel * model = self.dataSource[i];
    [[AFHttpClient sharedAFHttpClient]optgzWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:model.mid type:@"add" complete:^(BaseModel *model) {
        [[AppUtil appTopViewController] showHint:model.retDesc];
        [self loadDataSourceWithPage:1];
    }];



}



@end