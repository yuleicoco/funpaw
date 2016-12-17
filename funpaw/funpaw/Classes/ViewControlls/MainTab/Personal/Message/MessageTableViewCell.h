//
//  MessageTableViewCell.h
//  petegg
//
//  Created by yulei on 16/4/14.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UIImageView *handImageView;
@property (strong, nonatomic) IBOutlet UIImageView *goodImage;
@property (strong, nonatomic) IBOutlet UIImageView *mainImagView;


@end
