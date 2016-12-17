//
//  CALayer+XibConfiguration.m
//  NewVideoDemo
//
//  Created by yulei on 16/2/22.
//  Copyright © 2016年 yulei. All rights reserved.
//


// 颜色的cg
// xlb 颜色边框颜色

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}
-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
