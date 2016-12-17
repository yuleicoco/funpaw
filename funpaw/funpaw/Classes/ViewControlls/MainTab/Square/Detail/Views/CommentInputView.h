//
//  CommentInputView.h
//  petegg
//
//  Created by ldp on 16/4/11.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentInputView : UIView

@property (nonatomic, weak) UIViewController *viewController;

@property (strong, nonatomic) UITextView *inputTextView;

-(void)showWithSendCommentBlock:(void(^)(NSString *text))sendCommentBlock;

+ (CGFloat)defaultHeight;

@end
