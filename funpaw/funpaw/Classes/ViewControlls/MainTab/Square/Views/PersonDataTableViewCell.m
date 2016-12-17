//
//  PersonDataTableViewCell.m
//  petegg
//
//  Created by czx on 16/4/7.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "PersonDataTableViewCell.h"

@implementation PersonDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 10 * W_Hight_Zoom)];
        _topView.backgroundColor = [UIColor lightGrayColor];
        _topView.alpha = 0.1;
        [self addSubview:_topView];
        
        _bigImage = [[UIImageView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 10 * W_Hight_Zoom, 375 * W_Wide_Zoom, 250 * W_Hight_Zoom)];
        _bigImage.backgroundColor = [UIColor clearColor];
        _bigImage.contentMode = UIViewContentModeCenter;
        _bigImage.layer.masksToBounds = YES;
        [self addSubview:_bigImage];
        
        
        _attentionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom, 260 * W_Hight_Zoom, 200 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
        _attentionLabel.textColor = [UIColor blackColor];
        _attentionLabel.text = @"啦啦啦啊啦啦啦啦";
        _attentionLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_attentionLabel];
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom, 280 * W_Hight_Zoom, 200 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
        _dateLabel.text = @"2015-09-23 15:31";
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_dateLabel];
        
        _pinglun = [[UIImageView alloc]initWithFrame:CGRectMake(290 * W_Wide_Zoom, 290 * W_Hight_Zoom, 13 * W_Wide_Zoom, 13 * W_Hight_Zoom)];
        _pinglun.image = [UIImage imageNamed:@"评论.png"];
        [self addSubview:_pinglun];
        
        
        _pinglunLabel = [[UILabel alloc]initWithFrame:CGRectMake(310 * W_Wide_Zoom, 282 * W_Hight_Zoom, 30 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        _pinglunLabel.textColor = [UIColor lightGrayColor];
        _pinglunLabel.text = @"12";
        _pinglunLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_pinglunLabel];
        
        _aixin = [[UIImageView alloc]initWithFrame:CGRectMake(330 * W_Wide_Zoom, 290 * W_Hight_Zoom, 13 * W_Wide_Zoom, 13 * W_Hight_Zoom)];
        _aixin.image = [UIImage imageNamed:@"点赞5.png"];
        [self addSubview:_aixin];
        
        _aixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(350 * W_Wide_Zoom, 282 * W_Hight_Zoom, 30 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        _aixinLabel.textColor = [UIColor lightGrayColor];
        _aixinLabel.font = [UIFont systemFontOfSize:11];
        _aixinLabel.text = @"33";
        [self addSubview:_aixinLabel];
        
        self.mvImageview = [[UIImageView alloc]initWithFrame:CGRectMake(167.5 * W_Wide_Zoom, 125 * W_Hight_Zoom, 40 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
        [self.mvImageview setImage:[UIImage imageNamed:@"MV.png"]];
        self.mvImageview.hidden = YES;
        [self addSubview:self.mvImageview];
        
    }


    return self;
}

@end
