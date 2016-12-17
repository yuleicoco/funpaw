//
//  CommentModel.m
//  petegg
//
//  Created by ldp on 16/4/10.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (instancetype)init{
    if (self = [super init]) {
        self.list = [NSMutableArray array];
    }
    return self;
}

- (NSString *)content{
    return [_content replaceUnicode];
}

@end
