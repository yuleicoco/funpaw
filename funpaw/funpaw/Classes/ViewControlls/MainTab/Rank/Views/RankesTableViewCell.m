//
//  RankesTableViewCell.m
//  petegg
//
//  Created by czx on 16/4/13.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "RankesTableViewCell.h"

@implementation RankesTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Wide_Zoom, 375 * W_Wide_Zoom, 65 * W_Wide_Zoom)];
        _backView.backgroundColor = [UIColor colorWithRed:246/255.0 green:244/255.0 blue:241/255.0 alpha:1];
       // _backView.alpha = 0.1;
        [self addSubview:_backView];
        
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom, 64.5 * W_Hight_Zoom, 355 * W_Wide_Zoom, 0.5 * W_Hight_Zoom)];
        _lineLabel.backgroundColor = GRAY_COLOR;
        _lineLabel.alpha = 0.7;
        [self addSubview:_lineLabel];
        
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(43 * W_Wide_Zoom, 10 * W_Hight_Zoom, 45 * W_Wide_Zoom, 45 * W_Hight_Zoom)];
        _headImage.backgroundColor = [UIColor yellowColor];
        [_headImage.layer setMasksToBounds:YES];
        _headImage.layer.cornerRadius = _headImage.width/2;
        [self addSubview:_headImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100 * W_Wide_Zoom, 13 * W_Hight_Zoom, 100 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.text = @"haha";
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nameLabel];
        
        
        _rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(100 * W_Wide_Zoom, 40 * W_Hight_Zoom, 12 * W_Wide_Zoom, 12 * W_Hight_Zoom)];
        _rightImage.image = [UIImage imageNamed:@"dianzanhou.png"];
        [self addSubview:_rightImage];
        
        _aixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(118 * W_Wide_Zoom, 36 * W_Hight_Zoom , 100 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _aixinLabel.textColor = [UIColor blackColor];
        _aixinLabel.text = @"111";
        _aixinLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_aixinLabel];
        
        
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(300 * W_Wide_Zoom, 20 * W_Hight_Zoom, 100 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        _rightLabel.text = @"NO.1";
        _rightLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_rightLabel];
        
        
        
        
        
    }


    return self;

}


@end
