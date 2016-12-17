//
//  AFHttpClient+Detailed.h
//  petegg
//
//  Created by czx on 16/4/8.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Detailed)
//萌宠秀详情的接口
-(void)querDetailWithStid:(NSString *)stid
                 complete:(void(^)(BaseModel *model))completeBlock
                  failure:(void(^)())failureBlock;

//萌宠秀详情的接口
-(void)querDetailWithStid:(NSString *)stid
                 complete:(void(^)(BaseModel *model))completeBlock;

//评论列表接口
-(void)queryCommentWithWid:(NSString *)wid
                 pageIndex:(int)pageIndex
                  pageSize:(int)pageSize
                  complete:(void(^)(BaseModel *model))completeBlock;

//添加/回复评论接口
-(void)addCommentWithPid:(NSString *)pid
                     bid:(NSString *)bid
                     wid:(NSString *)wid
                    bcid:(NSString *)bcid
                   ptype:(NSString *)ptype
                  action:(NSString *)action
                 content:(NSString *)content
                complete:(void(^)(BaseModel *model))completeBlock;

//查询是否点赞
-(void)queryBehaviorWithMid:(NSString *)mid
                        objid:(NSString *)objid
                        complete:(void(^)(BaseModel *model))completeBlock;
//添加点赞接口
-(void)addBehaviorWithMid:(NSString *)mid
                     objid:(NSString *)objid
                     objcon:(NSString *)objcon
                     complete:(void(^)(BaseModel *model))completeBlock;





@end
