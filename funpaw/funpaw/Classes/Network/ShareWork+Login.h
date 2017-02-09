//
//  ShareWork+Login.h
//  funpaw
//
//  Created by czx on 2017/2/9.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "ShareWork.h"

@interface ShareWork (Login)
//获取验证码
-(void)checkWithPhone:(NSString *)phone type:(NSString *)type complete:(void(^)(BaseModel *model))completeBlock;

//会员注册
-(void)memberRegisterWithEmail:(NSString *)email password:(NSString *)password complete:(void(^)(BaseModel *model))completeBlock;

//会员登录
-(void)memberLoginWithAccountnumber:(NSString *)accountnumber password:(NSString *)password complete:(void(^)(BaseModel *model))completeBlock;





@end