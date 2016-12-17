//
//  DetailCommentCell.h
//  petegg
//
//  Created by ldp on 16/4/8.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCommentCell : UITableViewCell

@property (nonatomic, strong) CommentModel *model;

@property (nonatomic, copy) void (^replyBlock)();

@property (nonatomic, copy) void (^commentLableClickBlock)(int index);

@end
