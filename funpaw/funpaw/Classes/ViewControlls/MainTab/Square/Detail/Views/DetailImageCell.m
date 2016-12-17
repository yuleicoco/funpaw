//
//  DetailImageCell.m
//  petegg
//
//  Created by ldp on 16/4/11.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "DetailImageCell.h"

#import "UIImageView+WebCache.h"
#import "UIImage-Extensions.h"

#import "UIView+TapBlocks.h"

@interface DetailImageCell()

@property (nonatomic, strong) UIImageView *iconIV;

@end

@implementation DetailImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupView{
    
    _iconIV = [UIImageView new];
    _iconIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView sd_addSubviews:@[_iconIV]];
    
    _iconIV.sd_layout.topSpaceToView(self.contentView,8).leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(0);
}

- (void)setModel:(NSString *)model{
    
    _model = model;
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && self.iconIV.width > 0) {
            
            UIImage* resultImage = [image imageByScalingProportionallyToSize:CGSizeMake(self.iconIV.width, CGFLOAT_MAX)];
            
            CGSize size = resultImage.size;
            
            self.iconIV.sd_layout.heightIs(size.height);
            
//            if (size.width >= self.width) {
//                
//                if (size.width < size.height) {
//                    
//                    self.iconIV.sd_layout.heightIs(size.height / (size.width / (self.width - 16)));
//                }else{
//                    self.iconIV.sd_layout.heightIs((self.width - 16) * size.height / size.width);
//                }
//                
//            }else{
//                self.iconIV.sd_layout.heightIs(size.height);
//            }
        }
    }];
    
    [self setupAutoHeightWithBottomView:self.iconIV bottomMargin:8];
}

@end
