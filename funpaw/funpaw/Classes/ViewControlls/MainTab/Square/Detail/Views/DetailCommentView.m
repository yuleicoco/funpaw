//
//  DetailCommentView.m
//  petegg
//
//  Created by ldp on 16/4/11.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "DetailCommentView.h"
#import "UIView+TapBlocks.h"

@interface DetailCommentView()

@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) NSMutableArray *commentLabelsArray;

@property (nonatomic, strong) UILabel *likeLabel;

@end

@implementation DetailCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}


- (void)setupViews
{
    _likeLabel = [UILabel new];
    [self addSubview:_likeLabel];

}

- (NSMutableArray *)commentLabelsArray{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray array];
    }
    return _commentLabelsArray;
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray{
    
    _commentItemsArray = commentItemsArray;
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.userInteractionEnabled = YES;
        label.tag = i;
        [self addSubview:label];
        
        [label addTapGestureWithBlock:^{
            if (self.commentLableClickBlock) {
                self.commentLableClickBlock(i);
            }
        }];
        
        [self.commentLabelsArray addObject:label];
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        CommentModel *model = commentItemsArray[i];
        UILabel *label = self.commentLabelsArray[i];
        label.attributedText = [self generateAttributedStringWithCommentItemModel:model];
    }
}

- (void)setupWithCommentItemsArray:(NSArray *)commentItemsArray{
    
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.frame = CGRectZero;
        }];
    }
    
    UIView *lastTopView = self.likeLabel;
    
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        CGFloat topMargin = i == 0 ? 0 : 4;
        label.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(lastTopView, topMargin)
        .autoHeightRatio(0);
        
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    
    if (lastTopView) {
        [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
    }
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(CommentModel *)model{
    NSString *text = model.memname;
    NSString *replyStr = @"回复";
    if (model.bmemname.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@%@", replyStr, model.bmemname]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.content]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = GREEN_COLOR;
    
    [attString addAttribute:NSForegroundColorAttributeName value:highLightColor range:[text rangeOfString:model.memname]];
    if (model.bmemname) {
        [attString addAttribute:NSForegroundColorAttributeName value:highLightColor range:NSMakeRange(model.memname.length + replyStr.length, model.bmemname.length)];
    }
    
    return attString;
}

@end
