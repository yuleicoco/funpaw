//
//  personTableViewCell.m
//  petegg
//
//  Created by yulei on 16/3/24.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "personTableViewCell.h"

@implementation personTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self  =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageCell =[[UIImageView alloc]initWithFrame:CGRectMake(13*W_Wide_Zoom, 12*W_Hight_Zoom, 28*W_Wide_Zoom, 28*W_Hight_Zoom)];
        [self addSubview:self.imageCell];
        
        self.introduce =[[UILabel alloc]initWithFrame:CGRectMake(45*W_Wide_Zoom, 4 * W_Hight_Zoom, 180*W_Wide_Zoom, 45*W_Hight_Zoom)];
        
        [self addSubview:self.introduce];
        
        
        self.moneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(310*W_Wide_Zoom, 16, 20*W_Wide_Zoom, 20*W_Hight_Zoom)];
        self.moneyLabel.textColor=[UIColor whiteColor];
        self.moneyLabel.hidden = YES;
        self.moneyLabel.textAlignment = NSTextAlignmentCenter;
        self.moneyLabel.backgroundColor =[UIColor redColor];
        [self.moneyLabel.layer setMasksToBounds:YES];
        self.moneyLabel.layer.cornerRadius = self.moneyLabel.bounds.size.width/2;
        [self addSubview:self.moneyLabel];
        
        self.redpoint = [[UIButton alloc]initWithFrame:CGRectMake(310 * W_Wide_Zoom, 25 * W_Hight_Zoom, 8 * W_Wide_Zoom, 8 * W_Hight_Zoom)];
        self.redpoint.backgroundColor = [UIColor redColor];
        self.redpoint.hidden = YES;
        self.redpoint.layer.cornerRadius = self.redpoint.width/2;
        [self addSubview:self.redpoint];
        
        

    }
    return self;
        
    
}

@end
