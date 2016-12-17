//
//  VideoModel.h
//  petegg
//
//  Created by yulei on 16/4/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@property (nonatomic,copy)NSString *filename;//文件名+缩略图+播放时长
@property (nonatomic,copy)NSString *hours;
@property (nonatomic,copy)NSString *img;
@property (nonatomic,copy)NSString *mid;
@property (nonatomic,copy)NSString *opttime;
@property (nonatomic,copy)NSString *vid;
@property (nonatomic,copy)NSString * networkaddress;
@property (nonatomic,copy)NSString * thumbnails;
@property (nonatomic,copy)NSString * type;


@end
