//
//  AFHttpClient+InformationChange.h
//  petegg
//
//  Created by czx on 16/4/26.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (InformationChange)
//个人信息接口

//查询
-(void)queryByIdMemberWithMid:(NSString * )mid
                      complete:(void(^)(BaseModel *model))completeBlock;

//修改
-(void)modifyMemberWithMid:(NSString *)mid
                       nicname:(NSString * )nickname
                       qq:(NSString *)qq
                       address:(NSString *)address
                       signature:(NSString *)signature
                       pet_sex:(NSString *)pet_sex
                       pet_birthday:(NSString *)pet_birthday
                       pet_race:(NSString *)pet_race
                       complete:(void(^)(BaseModel *model))completeBlock;

//修改头像
-(void)modifyHeadportraitWithMid:(NSString *)mid
                         picture:(NSString *)picture
                         complete:(void(^)(BaseModel *model))completeBlock;

//修改qq显示状态
-(void)modifyQqStatusWithMid:(NSString *)mid
                         object:(NSString *)object
                         complete:(void(^)(BaseModel *model))completeBlock;







@end
