//
//  FriendTableViewCell.h
//  petegg
//
//  Created by yulei on 16/4/10.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tellLable;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIImageView *oneImagev;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodLabel;
@property (strong, nonatomic) IBOutlet UIImageView *twoOneImage;
@property (strong, nonatomic) IBOutlet UIImageView *twotwoImage;


@end
