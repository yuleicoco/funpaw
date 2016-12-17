//
//  SeachePeopleViewController.m
//  petegg
//
//  Created by czx on 16/4/11.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "SeachePeopleViewController.h"
#import "AFHttpClient+Nearby.h"
#import "NearTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NearbyModel.h"
#import "AFHttpClient+IsfriendClient.h"
#import "PersonDetailViewController.h"
static NSString * cellId = @"seacherCelliddddd";

@interface SeachePeopleViewController ()
@property (nonatomic,strong)UITextField * seacherTsexField;
@property (nonatomic,strong)UIButton * searchBtn;
@end

@implementation SeachePeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAY_COLOR;
    [self setNavTitle:@"找人"];
    [self initTopView];
}
-(void)initTopView{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 60 * W_Hight_Zoom, self.view.width, 40 * W_Hight_Zoom)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    UIImageView * headImage = [[UIImageView alloc]initWithFrame:CGRectMake(5 * W_Wide_Zoom, 11 * W_Hight_Zoom, 15 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
//    headImage.backgroundColor = [UIColor blackColor];
    headImage.image = [UIImage imageNamed:@"searche.png"];
    headImage.contentMode =  UIViewContentModeScaleAspectFill;
    [topView addSubview:headImage];
    
    _seacherTsexField = [[UITextField alloc]initWithFrame:CGRectMake(22 * W_Wide_Zoom, 14 * W_Wide_Zoom, 300 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
    //_seacherTsexField.backgroundColor = [UIColor redColor];
    _seacherTsexField.placeholder = @"搜索";
    _seacherTsexField.tintColor = GREEN_COLOR;
    _seacherTsexField.textAlignment = NSTextAlignmentLeft;
    [_seacherTsexField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [_seacherTsexField setValue:GRAY_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    [topView addSubview:_seacherTsexField];
    
    
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(300 * W_Wide_Zoom, 7 * W_Hight_Zoom , 100 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_searchBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [topView addSubview:_searchBtn];
    [_searchBtn addTarget:self action:@selector(searchButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = CGRectMake(0, 40 * W_Hight_Zoom, self.view.width, self.view.height);
    //  [self.tableView registerClass:[PersonDataTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView registerClass:[NearTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]searcheSomeWithMid:[AccountManager sharedAccountManager].loginModel.mid condition:_seacherTsexField.text pageIndex:page pageSize:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
        if (model.list.count == 0) {
            [self.tableView reloadData];
            [self handleEndRefresh];
            UIAlertController *  alert = [UIAlertController alertControllerWithTitle:@"没有您搜索的内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            [alert dismissViewControllerAnimated:YES  completion:nil];
            
        }else{
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
        }
    }];

}
-(void)searchButtonTouch{
    //点击的时候做的判断
    [_seacherTsexField resignFirstResponder];
    self.tableView.hidden = NO;
    [self initRefreshView];
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
    NearTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NearbyModel * model = self.dataSource[indexPath.row];
    
    cell.nameLabel.text = model.nickname;
    
    NSString * imageStr = [NSString stringWithFormat:@"%@",model.headportrait];
    NSURL * imageUrl = [NSURL URLWithString:imageStr];
    [cell.headBtn sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    cell.signLabel.text = model.signature;

    cell.zdRightBtn.hidden = YES;
    [cell.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.rightBtn.layer.cornerRadius = 5;
    
    cell.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    if ([AppUtil isBlankString:model.isfriend]) {
        cell.rightBtn.selected = YES;
        [cell.rightBtn setTitle:@"+关注" forState:UIControlStateNormal];
    }else{
        cell.rightBtn.selected = NO;
        [cell.rightBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    cell.rightBtn.tag = indexPath.row + 222;
    [cell.rightBtn addTarget:self action:@selector(headButtonTouchh:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.headTouchButton.tag = indexPath.row + 333;
    [cell.headTouchButton addTarget:self action:@selector(headButtontouchhhh:) forControlEvents:UIControlEventTouchUpInside];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)headButtonTouchh:(UIButton *)sender{
    NSInteger i = sender.tag - 222;
    if (sender.selected == YES) {
        NearbyModel * model = self.dataSource[i];
        [[AFHttpClient sharedAFHttpClient]optgzWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:model.mid type:@"add" complete:^(BaseModel *model) {
            [[AppUtil appTopViewController] showHint:model.retDesc];
            [self loadDataSourceWithPage:1];
        }];
    }else{
        NearbyModel * model = self.dataSource[i];
        [[AFHttpClient sharedAFHttpClient]optgzWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:model.mid type:@"cancel" complete:^(BaseModel *model) {
            [[AppUtil appTopViewController] showHint:model.retDesc];
            [self loadDataSourceWithPage:1];
        }];
    }
}

-(void)headButtontouchhhh:(UIButton *)sender{
    NSInteger i = sender.tag - 333;
    [_seacherTsexField resignFirstResponder];
    NearbyModel * model = self.dataSource[i];
    NSString * mid = model.mid;
    PersonDetailViewController * personVc = [[PersonDetailViewController alloc]init];
    personVc.ddddd = mid;
    [self.navigationController pushViewController:personVc animated:NO];
    
    
}



@end