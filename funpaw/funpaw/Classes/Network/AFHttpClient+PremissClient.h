//
//  AFHttpClient+PremissClient.h
//  petegg
//
//  Created by czx on 16/4/28.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (PremissClient)
//查询规则
-(void)queryRuleWithMid:(NSString *)mid
                    complete:(void(^)(BaseModel *model))completeBlock;

//设置规则
-(void)ruleSetWithMid:(NSString *)mid
                  rulesname:(NSString *)rulesname
                  object:(NSString *)object
                  friends:(NSString *)friends
                  price:(NSString *)price
                  tsnum:(NSString *)tsnum
                  complete:(void(^)(BaseModel *model))completeBlock;

//修改规则
-(void)ruleModifyInfoWithrid:(NSString *)rid
                         rulesname:(NSString *)rulesname
                         object:(NSString *)object
                         friends:(NSString *)friends
                         price:(NSString *)price
                         tsnum:(NSString *)tsnum
                         complete:(void(^)(BaseModel *model))completeBlock;
//启用规则
-(void)ruleModifyStatusWithMid:(NSString *)mid rid:(NSString *)rid complete:(void(^)(BaseModel *model))completeBlock;

//删除规则
-(void)ruleDelWithRid:(NSString *)rid
                  complete:(void(^)(BaseModel *model))completeBlock;


-(void)ruleSetQueryFriendWithMid:(NSString *)mid
                             rid:(NSString *)rid
                             pageIndex:(int)pageIndex
                             pageSize:(int)pageSize
                             complete:(void(^)(BaseModel *model))completeBlock;





@end
