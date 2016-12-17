//
//  PersonNewAttentionViewController.m
//  petegg
//
//  Created by czx on 16/4/19.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "PersonNewAttentionViewController.h"
#import "PersonNewAttentionTableViewCell.h"
#import "AFHttpClient+PersonAttention.h"
#import "PersonAttention.h"
#import "PersonAttentionTableViewCell.h"
#import "PersonDetailViewController.h"
#import "AFHttpClient+IsfriendClient.h"

static NSString * cellId = @"personNewAttentionTableViewCellidddd";

@interface PersonNewAttentionViewController ()

@end

@implementation PersonNewAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"新关注"];
}
-(void)setupView{
    [super setupView];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, 667 * W_Hight_Zoom);
    [self.tableView registerClass:[PersonAttentionTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // [self initRefreshView];
    self.tableView.mj_footer.hidden = YES;
}




-(void)setupData{
    [super setupData];

    [[AFHttpClient sharedAFHttpClient]focusTipWithMid:[AccountManager sharedAccountManager].loginModel.mid complete:^(BaseModel *model) {
        [self.dataSource addObjectsFromArray:model.list];
        [self.tableView reloadData];
        [self isread];
    }];

}

-(void)isread{
    [[AFHttpClient sharedAFHttpClient]isreadWithMid:[AccountManager sharedAccountManager].loginModel.mid type:@"f" complete:^(BaseModel *model) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"isreaddd" object:nil];
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
    return 60*W_Hight_Zoom;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonAttention * model = self.dataSource[indexPath.row];
    PersonAttentionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.nameLabel.text = model.nickname;
    NSString * imageStr = [NSString stringWithFormat:@"%@",model.headportrait];
    NSURL * imageUrl = [NSURL URLWithString:imageStr];

    
    [cell.headImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    UIButton * touBtn = [[UIButton alloc]initWithFrame:cell.headImage.frame];
    touBtn.backgroundColor = [UIColor clearColor];
    touBtn.tag = indexPath.row + 110001;
    
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
    
    if ([AppUtil isBlankString:model.isfriend]) {
        [cell.rightButton setTitle:@"加关注" forState:UIControlStateNormal];
        cell.rightButton.tag = indexPath.row + 175;
    }else{
        [cell.rightButton setTitle:@"互相关注" forState:UIControlStateNormal];
          cell.rightButton.tag = indexPath.row + 176;
    }
  
    [cell.rightButton addTarget:self action:@selector(quxiaoGuanzhubtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSString * age = [NSString stringWithFormat:@"%@岁",model.pet_age];
    [cell.ageButton setTitle:age forState:UIControlStateNormal];
    
    return cell;
}

-(void)headButtonTOuch:(UIButton *)sender{
    NSInteger i =sender.tag - 110001;
    NearbyModel * model = self.dataSource[i];
    PersonDetailViewController * personVc = [[PersonDetailViewController alloc]init];
    personVc.ddddd = model.mid;
    [self.navigationController pushViewController:personVc animated:NO];
    
}

-(void)quxiaoGuanzhubtnTouch:(UIButton *)sender{
    if (sender.tag == 175) {
        NSInteger i = sender.tag - 175;
        NSLog(@"%ld",i);
        NearbyModel * model = self.dataSource[i];
        [[AFHttpClient sharedAFHttpClient]optgzWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:model.mid type:@"add" complete:^(BaseModel *model) {
            [[AppUtil appTopViewController] showHint:model.retDesc];
            [self loadDataSourceWithPage:1];
        }];
    }else{
         NSInteger i = sender.tag - 176;
              NearbyModel * model = self.dataSource[i];
              [[AFHttpClient sharedAFHttpClient]optgzWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:model.mid type:@"cancel" complete:^(BaseModel *model) {
                  //提示
                  [[AppUtil appTopViewController] showHint:model.retDesc];
                  //刷新界面
                  [self loadDataSourceWithPage:1];
                  
              }];
    }
   
    
}
@end