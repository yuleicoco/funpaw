//
//  AFHttpClient+ChangepasswordAndBlacklist.h
//  petegg
//
//  Created by czx on 16/4/26.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (ChangepasswordAndBlacklist)
//修改密码和黑名单的接口写在一起的
//修改密码
-(void)modifyPasswordWithMid:(NSString *)mid
                     password:(NSString *)password
                     complete:(void(^)(BaseModel *model))completeBlock;

//加入黑名单

-(void)addBlacklistWithMid:(NSString *)mid
                    friend:(NSString *)friendId
                    complete:(void(^)(BaseModel *model))completeBlock;


//查询黑名单
-(void)queryBlacklistWithMid:(NSString *)mid
                    complete:(void(^)(BaseModel *model))completeBlock;



//取消黑名单
-(void)delBlacklistWithMid:(NSString *)mid
                   friend:(NSString *)friendId
                   complete:(void(^)(BaseModel *model))completeBlock;


//投诉建议
-(void)addFeedbackWithMid:(NSString *)mid
                      fconcent:(NSString *)fconcent
                      fphone:(NSString *)fphone
                      complete:(void(^)(BaseModel *model))completeBlock;

//交易明细(也写在这里算了)
-(void)getTransactionRecordWithMid:(NSString *)mid
                           complete:(void(^)(BaseModel *model))completeBlock;


//举报
-(void)addreportWithMid:(NSString *)mid stid:(NSString *)stid content:(NSString *)content reporttype:(NSString *)reporttype objtype:(NSString *)objtype  complete:(void(^)(BaseModel *model))completeBlock;




@end
