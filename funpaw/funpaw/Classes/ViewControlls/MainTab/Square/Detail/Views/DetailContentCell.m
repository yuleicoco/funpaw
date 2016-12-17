//
//  ContentCell.m
//  petegg
//
//  Created by ldp on 16/4/8.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "DetailContentCell.h"

#import "UIView+SDAutoLayout.h"

@interface DetailContentCell()

@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@end

@implementation DetailContentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupView{
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.numberOfLines = 0;
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.numberOfLines = 1;
    
    NSArray* views = @[_contentLabel, _timeLabel];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 8;
    
    _contentLabel.sd_layout.leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _timeLabel.sd_layout.leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 8)
    .rightEqualToView(_contentLabel)
    .autoHeightRatio(0);
}

- (void)setModel:(DetailModel *)model{
    
    _model = model;
    
    _contentLabel.text = model.content;
    _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
    
    _timeLabel.text = model.publishtime;
    
    [self setupAutoHeightWithBottomView:self.timeLabel bottomMargin:8];
}

@end
