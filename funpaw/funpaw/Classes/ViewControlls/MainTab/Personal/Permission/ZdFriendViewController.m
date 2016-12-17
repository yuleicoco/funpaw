//
//  ZdFriendViewController.m
//  petegg
//
//  Created by czx on 16/4/28.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "ZdFriendViewController.h"
#import "NearTableViewCell.h"
#import "AFHttpClient+PremissClient.h"
#import "ZdFriendModel.h"
static NSString * cellId = @"zdfrienddsadsadsadsa";
@interface ZdFriendViewController ()
@property (nonatomic,strong)NSMutableArray * array;
@end

@implementation ZdFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"指定好友"];
}
-(void)setupView{
    [super setupView];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 80);
    [self.tableView registerClass:[NearTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self initRefreshView];
    
    UIButton * sureButton = [[UIButton alloc]initWithFrame:CGRectMake(30 * W_Wide_Zoom, 600 * W_Hight_Zoom, 315 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
    sureButton.backgroundColor = GREEN_COLOR;
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 5;
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:sureButton];
    [sureButton addTarget:self action:@selector(sureButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)sureButtonTouch{
    if (_array.count < 1 ) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有选择任何好友，确定返回吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                 [self.navigationController popViewControllerAnimated:YES];
        
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)doLeftButtonTouch{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有选择任何好友，确定返回吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)setupData{
    [super setupData];
}
-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]ruleSetQueryFriendWithMid:[AccountManager sharedAccountManager].loginModel.mid rid:@"" pageIndex:page pageSize:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
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
    return 60*W_Hight_Zoom;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZdFriendModel * model = self.dataSource[indexPath.row];
    NearTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.nameLabel.text = model.nickname;
    NSString * imageStr = [NSString stringWithFormat:@"%@",model.headportrait];
    NSURL * imageUrl = [NSURL URLWithString:imageStr];
    [cell.headBtn sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    cell.signLabel.text = model.signature;
    cell.rightBtn.hidden = YES;
    cell.zdRightBtn.tag = indexPath.row +6666;
    [cell.zdRightBtn addTarget:self action:@selector(zdButtontouch:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)zdButtontouch:(UIButton *)sender{
    NSInteger i = sender.tag - 6666;
    ZdFriendModel * model = self.dataSource[i];
    
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_array addObject:model.isfriend];
    }else{
        [_array removeObject:model.isfriend];
    }
    NSUserDefaults * FriendUserDefaults = [NSUserDefaults standardUserDefaults];
    [FriendUserDefaults setObject:_array forKey:@"friendesId"];
}




@end
