//
//  NearTableViewCell.h
//  petegg
//
//  Created by czx on 16/4/11.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView * headBtn;
@property (nonatomic,strong)UIButton * headTouchButton;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * signLabel;
@property (nonatomic,strong)UIButton * rightBtn;

@property (nonatomic,strong)UILabel * lineLabel;

@property (nonatomic,strong)UIButton * zdRightBtn;

@end
