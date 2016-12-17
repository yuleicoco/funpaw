//
//  MessageViewController.m
//  petegg
//
//  Created by yulei on 16/4/13.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageModel.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self setNavTitle: NSLocalizedString(@"message", nil)];
    
  
}


- (void)setupView
{
    [super setupView];
     self.tableView.frame =CGRectMake(0, 0, MainScreen.width, MainScreen.height);
     self.tableView.backgroundColor =[UIColor whiteColor];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
     self.tableView.mj_footer.hidden = YES;
     [self initRefreshView];
}

- (void)setupData
{
    
    [super setupData];
    
}


- (void)loadDataSourceWithPage:(int)page
{
    
    NSString * str =@"clientAction.do?method=json&common=trendTip&classes=appinterface";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    [dic setValue:[AccountManager sharedAccountManager].loginModel.mid forKey:@"mid"];
    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
        [self.dataSource removeAllObjects];
        json = [[json objectForKey:@"jsondata"]objectForKey:@"list"];
        NSMutableArray * arr =[[NSMutableArray alloc]init];
        [arr addObjectsFromArray:json];
        
        for (NSDictionary *dic0 in arr) {
            MessageModel *model = [[MessageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic0];
            [self.dataSource addObject:model];
        }
        
        if (arr.count>0) {
            
            [self messageClean];
            
        }
        
         NSLog(@"====%@",json);
        
        [self.tableView reloadData];
        [self handleEndRefresh];
        
         [[NSNotificationCenter defaultCenter]postNotificationName:@"message123" object:nil];
        
    } failure:^(NSError *error) {
        
        [self handleEndRefresh];
    }];

    
}


/**
 *  清楚消息
 */

- (void)messageClean
{
    
    NSString * str =@"clientAction.do?method=json&common=isread&classes=appinterface";
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    [dic setValue:[AccountManager sharedAccountManager].loginModel.mid forKey:@"mid"];
    [dic setValue:@"c" forKey:@"type"];
    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"countMessage"];
        
    } failure:^(NSError *error) {
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- tabviewDelgate

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
    return 61;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageModel *model;
    if (self.dataSource.count>0) {
        model = self.dataSource[indexPath.row];
    }
    
    static NSString * showUserInfoCellIdentifier = @"showMessage";
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageTableViewCell" owner:self options:nil]lastObject];
    }
   
    cell.nameLable.text=model.nickname;
    cell.timeLable.text = model.opttime;
    if ([model.type isEqualToString:@"p"]) {
        // 点赞
        cell.goodImage.hidden= NO;
        
    }else
    {
        cell.goodImage.hidden = YES;
        // 评论
         cell.messageLabel.text = model.content;
    }
    [cell.mainImagView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"默认头像2副本.png"]];
    [cell.handImageView sd_setImageWithURL:[NSURL URLWithString:model.headportrait] placeholderImage:[UIImage imageNamed:@"默认头像2副本.png"]];
 
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model;
    if (self.dataSource.count>0) {
        model = self.dataSource[indexPath.row];
    }
        DetailViewController * detailVC =[[DetailViewController alloc]init];
        detailVC.stid = model.tid;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    
}


@end
