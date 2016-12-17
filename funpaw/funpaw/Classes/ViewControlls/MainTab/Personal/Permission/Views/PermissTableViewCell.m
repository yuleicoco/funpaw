//
//  PermissTableViewCell.m
//  petegg
//
//  Created by czx on 16/4/27.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "PermissTableViewCell.h"

@implementation PermissTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 69 * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        _lineLabel.alpha = 0.6;
        [self addSubview:_lineLabel];
        
        
        _quanBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom, 12 * W_Hight_Zoom, 23 * W_Wide_Zoom, 23 * W_Hight_Zoom)];
        [_quanBtn setImage:[UIImage imageNamed:@"quan_guize.png"] forState:UIControlStateNormal];
        [_quanBtn setImage:[UIImage imageNamed:@"xuanquan_guize.png"] forState:UIControlStateSelected];
        [self addSubview:_quanBtn];
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40 * W_Wide_Zoom, 10 * W_Hight_Zoom, 200 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        _nameLabel.text = @"默认规则则";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_nameLabel];
        
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(40 * W_Wide_Zoom, 42 * W_Hight_Zoom, 100 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _leftLabel.text = @"仅自己";
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_leftLabel];
        
        _price = [[UILabel alloc]initWithFrame:CGRectMake(130 * W_Wide_Zoom, 42 * W_Hight_Zoom, 50 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _price.text = @"价格:";
        _price.textColor = [UIColor blackColor];
        _price.font = [UIFont systemFontOfSize:12];
        [self addSubview:_price];
        
        _centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(165 * W_Wide_Zoom, 42 * W_Hight_Zoom, 50 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _centerLabel.text = @"1";
        _centerLabel.textColor = [UIColor blackColor];
        _centerLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_centerLabel];
        
        
        _doubi = [[UILabel alloc]initWithFrame:CGRectMake(183 * W_Wide_Zoom, 42 * W_Hight_Zoom, 50 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _doubi.text = @"逗币";
        _doubi.textColor = [UIColor blackColor];
        _doubi.font = [UIFont systemFontOfSize:13];
        [self addSubview:_doubi];
        
        
        _toushi = [[UILabel alloc]initWithFrame:CGRectMake(245 * W_Wide_Zoom, 42 *W_Hight_Zoom, 50 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _toushi.text = @"投食:";
        _toushi.textColor = [UIColor blackColor];
        _toushi.font = [UIFont systemFontOfSize:13];
        [self addSubview:_toushi];
        
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(280 * W_Wide_Zoom, 42 * W_Hight_Zoom, 50 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _rightLabel.text = @"10";
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_rightLabel];
        
        _ge = [[UILabel alloc]initWithFrame:CGRectMake(298 * W_Wide_Zoom, 42 * W_Hight_Zoom, 50 * W_Wide_Zoom, 20 * W_Hight_Zoom)];
        _ge.text = @"次";
        _ge.textColor = [UIColor blackColor];
        _ge.font = [UIFont systemFontOfSize:13];
        [self addSubview:_ge];
        
        
        _delectBtn = [[UIButton alloc]initWithFrame:CGRectMake(325 * W_Wide_Zoom, 12 * W_Hight_Zoom, 23 * W_Wide_Zoom, 23 * W_Hight_Zoom)];
        [_delectBtn setImage:[UIImage imageNamed:@"delect_guize.png"] forState:UIControlStateNormal];
        [self addSubview:_delectBtn];
        
        
        
        
    }

    return self;
}

@end
