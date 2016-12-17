//
//  AttentionViewController.m
//  petegg
//
//  Created by ldp on 16/3/23.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AttentionViewController.h"
#import "RecommendTableViewCell.h"
#import "AFHttpClient+Square.h"
#import "UIImageView+WebCache.h"

#import "UIImage-Extensions.h"

#import "DetailViewController.h"
#import "PersonDetailViewController.h"
static NSString * cellId = @"AttentionCellId";
@interface AttentionViewController ()

@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    
}

-(void)setupView{
    [super setupView];
     self .tableView.frame =  CGRectMake(0, 0, self.view.width, self.view.height - STATUS_BAR_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT);
    [self.tableView registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.backgroundColor = LIGHT_GRAY_COLOR;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initRefreshView];
    
}

-(void)setupData{
    [super setupData];
}

-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient] querySproutpetWithMid:[AccountManager sharedAccountManager].loginModel.mid pageIndex:page pageSize:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
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

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
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
    touchButton.tag = indexPath.row + 651;
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
    photoViewBtn.tag = indexPath.row + 652;
    [photoViewBtn addTarget:self action:@selector(photoButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:photoViewBtn];
    

    
    cell.introduceLable.text = model.content;
    
    cell.timeLable.text = model.publishtime;
    cell.leftnumber.text = model.comments;
    cell.rihttnumber.text = model.praises;
    cell.aboutBtn.hidden = YES;
    
    //tabview隐藏点击效果和分割线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)iconImageVTouch:(UIButton *)sender{
    NSInteger i = sender.tag - 651;
    
    SquareModel * model = self.dataSource[i];
    NSString * mid = model.mid;
    PersonDetailViewController * personVc = [[PersonDetailViewController alloc]init];
    personVc.ddddd = mid;
    [self.navigationController pushViewController:personVc animated:NO];
    
}

-(void)photoButtonTouch:(UIButton *)sender{
    NSInteger i = sender.tag -652;
    
    SquareModel * model = self.dataSource[i];
    NSString * stid = model.stid;
    NSLog(@"%@",stid);
    
    DetailViewController* viewController = [[DetailViewController alloc] init];
    viewController.stid = model.stid;
    [self.navigationController pushViewController:viewController animated:YES];
    
}



@end
