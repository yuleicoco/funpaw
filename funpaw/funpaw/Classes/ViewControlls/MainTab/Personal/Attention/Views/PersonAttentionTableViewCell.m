//
//  PersonAttentionTableViewCell.m
//  petegg
//
//  Created by czx on 16/4/15.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "PersonAttentionTableViewCell.h"

@implementation PersonAttentionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 59.5 * W_Hight_Zoom, 375 * W_Wide_Zoom, 0.5 * W_Hight_Zoom)];
        _lineLabel.backgroundColor = GRAY_COLOR;
        _lineLabel.alpha = 0.7;
        [self addSubview:_lineLabel];
        
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom, 10 * W_Hight_Zoom, 40 * W_Wide_Zoom, 40 * W_Wide_Zoom)];
        [_headImage.layer setMasksToBounds:YES];
        _headImage.layer.cornerRadius = _headImage.width/2;
        _headImage.backgroundColor = [UIColor redColor];
        [self addSubview:_headImage];
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * W_Wide_Zoom,  12 * W_Hight_Zoom, 50 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.text = @"呵呵da";
        _nameLabel.numberOfLines = 0;
        [self addSubview:_nameLabel];
        
        
        _kindImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), 12 * W_Hight_Zoom, 20 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        [_kindImage.layer setMasksToBounds:YES];
        _kindImage.image = [UIImage imageNamed:@"miaomiao.png"];
        _kindImage.layer.cornerRadius = _kindImage.width/2;
        [self addSubview:_kindImage];
        
        _sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_kindImage.frame) + 5, 12 * W_Hight_Zoom, 20 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        [_sexImage.layer setMasksToBounds:YES];
        _sexImage.layer.cornerRadius = _sexImage.width/2;
        _sexImage.image = [UIImage imageNamed:@"womanquanquan.png"];
        [self addSubview:_sexImage];
        
        _ageButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_sexImage.frame) + 5, 13 * W_Hight_Zoom, 35 * W_Wide_Zoom, 18 * W_Hight_Zoom)];
        _ageButton.layer.cornerRadius = 10;
        _ageButton.layer.borderWidth = 1;
        _ageButton.layer.borderColor = GREEN_COLOR.CGColor;
        [_ageButton setTitle:@"1岁" forState:UIControlStateNormal];
        [_ageButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        _ageButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_ageButton];
        
        _sinaglLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * W_Wide_Zoom, 30 * W_Hight_Zoom, 200 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _sinaglLabel.font = [UIFont systemFontOfSize:12];
        _sinaglLabel.textColor = [UIColor blackColor];
        [self addSubview:_sinaglLabel];
        
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(280 * W_Wide_Zoom, 15 * W_Hight_Zoom, 70 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        _rightButton.backgroundColor = GREEN_COLOR;
        [_rightButton setTitle:@"互相关注" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _rightButton.layer.cornerRadius = 5;
        [self addSubview:_rightButton];
        
        
        
        
        
        
        
    }

    return self;
}
@end
