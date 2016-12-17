//
//  BaseCollectionViewController.h
//  petegg
//
//  Created by yulei on 16/4/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MJRefresh.h"
@interface BaseCollectionViewController : BaseViewController

@property (nonatomic,strong)UICollectionView * collection;

// 资源
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic,strong)NSString * stateNum;
@property (nonatomic,assign)int  pageIndex;



- (void)initRefreshView:(NSString *)stateNum;

/**
 *  结束
 */
- (void)handleEndRefresh;

//更新数据从开始
- (void)updateData;
@end
