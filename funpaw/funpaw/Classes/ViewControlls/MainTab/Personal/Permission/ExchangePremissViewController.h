//
//  ExchangePremissViewController.h
//  petegg
//
//  Created by czx on 16/4/28.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ExchangePremissViewController : BaseTableViewController
@property(nonatomic,strong)NSString * exchangeRuleName;  //修改规则时原来的规则名字
@property(nonatomic,strong)NSString * exchangeObject;
@property(nonatomic,strong)NSString * exchangePrice;
@property(nonatomic,strong)NSString * exchangeToushi;
@property(nonatomic,strong)NSString * exchangeRid;



@end
