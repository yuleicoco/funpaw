//
//  DouYIDouViewController.m
//  petegg
//
//  Created by czx on 16/4/11.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "DouYIDouViewController.h"
#import "NearTableViewCell.h"
#import "NearbyModel.h"
#import "AFHttpClient+Nearby.h"
#import "UIImageView+WebCache.h"
#import "OtherEggViewController.h"
#import "PersonDetailViewController.h"
static NSString * cellId = @"douyidouCellId";
@interface DouYIDouViewController ()

@end

@implementation DouYIDouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"逗一逗";
    self.view.backgroundColor = [UIColor redColor];
}

-(void)setupView{
    [super setupView];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height );
    //  [self.tableView registerClass:[PersonDataTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView registerClass:[NearTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initRefreshView];
}


-(void)setupData{
    [super setupData];
  
    
    
}

-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]queriCanVisitWithMid:[AccountManager sharedAccountManager].loginModel.mid pageIndex:page pageSize:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
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
    NearTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NearbyModel * model = self.dataSource[indexPath.row];
    
    cell.nameLabel.text = model.nickname;
    
    NSString * imageStr = [NSString stringWithFormat:@"%@",model.headportrait];
    NSURL * imageUrl = [NSURL URLWithString:imageStr];
    [cell.headBtn sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    cell.signLabel.text = model.signature;
    cell.zdRightBtn.hidden = YES;
    

    cell.rightBtn.backgroundColor = [UIColor whiteColor];
    [cell.rightBtn setTitle:@"互动" forState:UIControlStateNormal];
    [cell.rightBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    cell.rightBtn.tag = indexPath.row + 120;
    cell.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
  
    [cell.headTouchButton addTarget:self action:@selector(headTouch:) forControlEvents:UIControlEventTouchUpInside];
    cell.headTouchButton.tag = indexPath.row + 2013;

    
    [cell.rightBtn addTarget:self action:@selector(fangwen:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)headTouch:(UIButton *)sender{
    NSInteger i = sender.tag - 2013;
    NearbyModel * model = self.dataSource[i];
    NSString * mid = model.mid;
    PersonDetailViewController * personVc = [[PersonDetailViewController alloc]init];
    personVc.ddddd = mid;
    [self.navigationController pushViewController:personVc animated:NO];
    

}



/**
 *  互动
 */

- (void)fangwen:(UIButton *)sender
{
    NSInteger i =sender.tag - 120;
    NearbyModel * model = self.dataSource[i];
//    NSMutableDictionary * dic =[self dictionaryWithModel:model];
//    NSMutableArray * arr =[[NSMutableArray alloc]init];
//    [arr addObject:dic];
    
            OtherEggViewController * other =[[OtherEggViewController alloc]init];
            other.otherMid = model.mid;
            [self.navigationController pushViewController:other animated:YES];
    
}


- (NSMutableDictionary *)dictionaryWithModel:(id)model {
    if (model == nil) {
        return nil;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 获取类名/根据类名获取类对象
    NSString *className = NSStringFromClass([model class]);
    id classObject = objc_getClass([className UTF8String]);
    
    // 获取所有属性
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    
    // 遍历所有属性
    for (int i = 0; i < count; i++) {
        // 取得属性
        objc_property_t property = properties[i];
        // 取得属性名
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        // 取得属性值
        id propertyValue = nil;
        id valueObject = [model valueForKey:propertyName];
        
        if ([valueObject isKindOfClass:[NSDictionary class]]) {
            propertyValue = [NSDictionary dictionaryWithDictionary:valueObject];
        } else if ([valueObject isKindOfClass:[NSArray class]]) {
            propertyValue = [NSArray arrayWithArray:valueObject];
        } else {
            propertyValue = [NSString stringWithFormat:@"%@", [model valueForKey:propertyName]];
        }
        
        [dict setObject:propertyValue forKey:propertyName];
    }
    return [dict copy];
}


// 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
}


@end
