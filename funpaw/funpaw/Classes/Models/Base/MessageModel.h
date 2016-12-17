//
//  MessageModel.h
//  petegg
//
//  Created by yulei on 16/4/14.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@property (nonatomic,copy)NSString * headportrait;
@property (nonatomic,copy)NSString * opttime;
@property (nonatomic,copy)NSString * thumbnail;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * nickname;
@property (nonatomic,copy)NSString * tid;
@property (nonatomic,copy)NSString * mid;

@end
