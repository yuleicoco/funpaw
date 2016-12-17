//
//  PersonNewAttentionTableViewCell.m
//  petegg
//
//  Created by czx on 16/4/19.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "PersonNewAttentionTableViewCell.h"

@implementation PersonNewAttentionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 60 * W_Hight_Zoom)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
        
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 59 * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        _lineLabel.backgroundColor = GRAY_COLOR;
        [self addSubview:_lineLabel];
        
        
        
    }

    return self;
}
@end
