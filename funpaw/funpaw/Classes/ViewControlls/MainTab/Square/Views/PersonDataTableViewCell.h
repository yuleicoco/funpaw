//
//  PersonDataTableViewCell.h
//  petegg
//
//  Created by czx on 16/4/7.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonDataTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView * bigImage;
@property (nonatomic,strong)UILabel * attentionLabel;
@property (nonatomic,strong)UILabel * dateLabel;
@property (nonatomic,strong)UIImageView * pinglun;
@property (nonatomic,strong)UIImageView * aixin;
@property (nonatomic,strong)UILabel* pinglunLabel;
@property (nonatomic,strong)UILabel * aixinLabel;
@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIImageView * centerImage; //视频图标
@property (nonatomic,strong)UIImageView * mvImageview;
@end
