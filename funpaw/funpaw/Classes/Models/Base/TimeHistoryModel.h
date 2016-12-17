//
//  TimeHistoryModel.h
//  petegg
//
//  Created by yulei on 16/4/13.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeHistoryModel : NSObject
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@property (nonatomic,copy)NSString *mid;
@property (nonatomic,copy)NSString *stid;
@property (nonatomic,copy)NSString *publishtime;
@property (nonatomic,copy)NSString *resources;
@property (nonatomic,copy)NSString *thumbnails;
@property (nonatomic,copy)NSString *praises;
@property (nonatomic,copy)NSString *comments;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *type;

@end
