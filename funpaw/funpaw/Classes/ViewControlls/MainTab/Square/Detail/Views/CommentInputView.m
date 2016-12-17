//
//  CommentInputView.m
//  petegg
//
//  Created by ldp on 16/4/11.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "CommentInputView.h"
#import "IQKeyboardManager.h"
#import "UIView+TapBlocks.h"

#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 200
#define kHorizontalPadding 4
#define kVerticalPadding 5

@interface CommentInputView()<UITextViewDelegate>
{
    CGFloat _previousTextViewContentHeight;
}

@property (nonatomic, strong) UIView *fadeView ;
@property (nonatomic) CGFloat maxTextInputViewHeight;
@property (nonatomic, copy) void (^sendCommentBlock)(NSString *text);

@end

@implementation CommentInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupConfigure];
        [self setupSubviews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    [super setFrame:frame];
}

- (void)setupSubviews
{
    CGFloat allButtonWidth = 0.0;
    CGFloat textViewLeftMargin = 6.0;
    
    _fadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _fadeView.backgroundColor = [UIColor clearColor];
    [_fadeView addTapGestureWithBlock:^{
        [self.inputTextView resignFirstResponder];
    }];
    
    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (textViewLeftMargin * 2));
    // 初始化输入框
    self.inputTextView = [[UITextView  alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
    self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _inputTextView.font = [UIFont systemFontOfSize:16];
    //    self.inputTextView.contentMode = UIViewContentModeCenter;
    _inputTextView.scrollEnabled = YES;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
//    _inputTextView.placeHolder = NSLocalizedString(@"message.toolBar.inputPlaceHolder", @"input a new message");
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = [UIColor whiteColor];
    _inputTextView.layer.borderColor =  RGB(223, 224, 226).CGColor;
    _inputTextView.layer.borderWidth = 0.65f;
    _inputTextView.layer.cornerRadius = 6.0f;
    _inputTextView.layer.masksToBounds = YES;
    _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
    
    [self addSubview:self.inputTextView];
    
    
    self.backgroundColor = RGB(248, 249, 250);
    self.layer.borderColor = RGB(223, 224, 226).CGColor;
    self.layer.borderWidth = 1.f;
    self.hidden = YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.hidden = NO;
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self hide];
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (self.sendCommentBlock) {
            self.sendCommentBlock( textView.text);
            [textView resignFirstResponder];
        }
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight){
        return;
    }else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        _previousTextViewContentHeight = toHeight;
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}

- (void)setupConfigure{
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
}

-(void)showWithSendCommentBlock:(void(^)(NSString *text))sendCommentBlock{
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    self.sendCommentBlock = sendCommentBlock;
    self.hidden = NO;
    [_inputTextView becomeFirstResponder];
    
    [self.superview addSubview:self.fadeView];
}

- (void)hide{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    _inputTextView.text = @"";
    self.height = [CommentInputView defaultHeight];
    _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
    self.hidden = YES;
    
    [self.fadeView removeFromSuperview];
}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

@end
