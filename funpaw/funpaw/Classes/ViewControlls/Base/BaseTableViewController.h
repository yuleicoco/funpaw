//
//  BaseTableViewController.h
//  petegg
//
//  Created by ldp on 16/3/22.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "BaseViewController.h"

#import "MJRefresh.h"

@interface BaseTableViewController : BaseViewController

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, assign) BOOL bGroupView;

//资源数组
@property (nonatomic, strong) NSMutableArray* dataSource;
//一个不够用加了一个
@property (nonatomic,strong)NSMutableArray * dataSourceImage;

@property (nonatomic, assign) int pageIndex;

//加载分页数据
- (void)loadDataSourceWithPage:(int)page;

- (void)handleEndRefresh;

- (void)initRefreshView;

//更新数据从开始
- (void)updateData;
//裁剪图片
- (UIImage *)cutImage:(UIImage*)image;
@end
