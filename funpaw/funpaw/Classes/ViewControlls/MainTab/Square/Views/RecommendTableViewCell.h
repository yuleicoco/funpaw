//
//  RecommendTableViewCell.h
//  petegg
//
//  Created by czx on 16/3/23.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendTableViewCell : UITableViewCell
@property (nonatomic, strong)  UIImageView *iconImageV;// 头像
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UIButton *ageBtn;

@property (nonatomic, strong)  UIButton *aboutBtn; // 关注
//@property (nonatomic,strong) UIButton * cancelAboutButton;//取消关注

@property (nonatomic, strong)  UIImageView *wangImage;
@property (nonatomic, strong)  UIImageView *sexImage;
@property (nonatomic, strong)  UIImageView *photoView;// 相片
@property (nonatomic, strong)  UILabel *timeLable;// 时间
@property (strong, nonatomic)  UILabel *numberLabel; // 张数
@property (strong, nonatomic)  UILabel *introduceLable;// 介绍
@property (nonatomic, strong)  UILabel *leftnumber;// 评论人
@property (nonatomic, strong)  UILabel *rihttnumber;// 点赞人
@property (nonatomic, strong)  UIImageView *pinglun;
@property (nonatomic, strong)  UIImageView *aixin;
@property (nonatomic,strong)UILabel * lineLable;
@property (nonatomic,strong)UIImageView * centerImage; //视频图标

@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIImageView * mvImageview;


@end
