//
//  AFHttpClient+Issue.h
//  petegg
//
//  Created by czx on 16/4/20.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Issue)

//点击发布的接口
-(void)addSproutpetWithMid:(NSString *)mid
                       content:(NSString *)content
                       type:(NSString *)type
                       resources:(NSMutableString *)resources
                       complete:(void(^)(BaseModel *model))completeBlock;

//资源库的接口
//已上传的视频
-(void)getVideoWithMid:(NSString *)mid
                pageIndex:(int)pageIndex
                   complete:(void(^)(BaseModel *model))completeBlock;


-(void)getPhotoGraphWithMid:(NSString *)mid
                  pageIndex:(int)pageIndex
                    complete:(void(^)(BaseModel *model))completeBlock;


@end
