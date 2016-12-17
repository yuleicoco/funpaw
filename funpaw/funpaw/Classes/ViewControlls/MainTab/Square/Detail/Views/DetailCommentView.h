//
//  DetailCommentView.h
//  petegg
//
//  Created by ldp on 16/4/11.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCommentView : UIView

@property (nonatomic, copy) void (^commentLableClickBlock)(int index);

- (void)setupWithCommentItemsArray:(NSArray *)commentItemsArray;

@end
