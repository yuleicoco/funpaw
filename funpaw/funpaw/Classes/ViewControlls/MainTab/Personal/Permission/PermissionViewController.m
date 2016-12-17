//
//  PermissionViewController.m
//  petegg
//
//  Created by czx on 16/4/27.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "PermissionViewController.h"
#import "PermissTableViewCell.h"
#import "AFHttpClient+PremissClient.h"
#import "PremissModel.h"
#import "NewPremissViewController.h"
#import "ExchangePremissViewController.h"
static NSString * cellId = @"permiss2321312321";
@interface PermissionViewController ()
@property (nonatomic,strong)UIButton * createBtn;
@end

@implementation PermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [self setNavTitle:@"访问规则"];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shuashuaxin) name:@"premissshuaxin" object:nil];
}
-(void)shuashuaxin{
    
    [self setupData];
}



-(void)setupView{
    [super setupView];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height );
    //  [self.tableView registerClass:[PersonDataTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView registerClass:[PermissTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    _createBtn = [[UIButton alloc]initWithFrame:CGRectMake(40 * W_Wide_Zoom, 500 * W_Hight_Zoom, 295 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    _createBtn.backgroundColor = GREEN_COLOR;
    _createBtn.layer.cornerRadius = 5;
    [_createBtn setTitle:@"新建访问规则" forState:UIControlStateNormal];
    _createBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_createBtn];
    [_createBtn addTarget:self action:@selector(newPermiss) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)newPermiss{
    if (self.dataSource.count >= 3) {
        [[AppUtil appTopViewController] showHint:@"您只能创建2条规则"];
    }else{
        NewPremissViewController * newVc = [[NewPremissViewController alloc]init];
        [self.navigationController pushViewController:newVc animated:YES];
    }
}
-(void)setupData{
    [super setupData];
    [[AFHttpClient sharedAFHttpClient]queryRuleWithMid:[AccountManager sharedAccountManager].loginModel.mid complete:^(BaseModel *model) {
        [self.dataSource addObjectsFromArray:model.list];
        [self.tableView reloadData];
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
    return 70*W_Hight_Zoom;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PremissModel * model = self.dataSource[indexPath.row];
    PermissTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (indexPath.row == 0) {
        cell.delectBtn.hidden = YES;
    }
    cell.nameLabel.text = model.rulesname;
    if ([model.isuse isEqualToString:@"y"]) {
        cell.quanBtn.selected = YES;
    }else{
        cell.quanBtn.selected = NO;
    }
    
    if ([model.object isEqualToString:@"self"]) {
        cell.leftLabel.text = @"仅自己";
    }else if ([model.object isEqualToString:@"all"]){
        cell.leftLabel.text = @"所有人";
    }else if ([model.object isEqualToString:@"friend"]){
        cell.leftLabel.text = @"仅朋友";
    }else if ([model.object isEqualToString:@"zd"]){
        cell.leftLabel.text = @"指定好友";
    }
    
    cell.centerLabel.text = model.price;
    cell.rightLabel.text = model.tsnum;
    [cell.delectBtn addTarget:self action:@selector(delectButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    cell.delectBtn.tag = indexPath.row + 987;
    
    cell.quanBtn.tag = indexPath.row + 6789;
    [cell.quanBtn addTarget:self action:@selector(quanButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)delectButtonTouch:(UIButton *)sender{
    NSInteger i = sender.tag - 987;
    PremissModel * model = self.dataSource[i];

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除此规则？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([model.isuse isEqualToString:@"y"]) {
            [[AppUtil appTopViewController] showHint:@"已启用的规则不能删除!"];
        }else{
        
        [[AFHttpClient sharedAFHttpClient]ruleDelWithRid:model.rid complete:^(BaseModel *model) {
            [[AppUtil appTopViewController] showHint:model.retDesc];
            [self setupData];
        }];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

-(void)quanButtonTouch:(UIButton *)sender{
    NSInteger i = sender.tag - 6789;
    PremissModel * model = self.dataSource[i];
    
    [[AFHttpClient sharedAFHttpClient]ruleModifyStatusWithMid:[AccountManager sharedAccountManager].loginModel.mid rid:model.rid complete:^(BaseModel *model) {
        [[AppUtil appTopViewController] showHint:model.retDesc];
        [self setupData];
    }];
    
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PremissModel * model = self.dataSource[indexPath.row];
    if ([model.type isEqualToString:@"2"]) {
        [[AppUtil appTopViewController] showHint:@"默认规则不可修改!"];
    
    }else{
        
     
        
        
        ExchangePremissViewController * excVc = [[ExchangePremissViewController alloc]init];
        excVc.exchangeRuleName = model.rulesname;
        excVc.exchangePrice = model.price;
        excVc.exchangeObject  = model.object;
        excVc.exchangeToushi = model.tsnum;
        excVc.exchangeRid = model.rid;
        [self.navigationController pushViewController:excVc animated:YES];
        }
        
    



}

@end
