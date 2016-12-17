//
//  AFHttpClient+PremissClient.m
//  petegg
//
//  Created by czx on 16/4/28.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+PremissClient.h"

@implementation AFHttpClient (PremissClient)
-(void)queryRuleWithMid:(NSString *)mid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"queryRule";
    params[@"mid"] = mid;

    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
             model.list = [PremissModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    
    
    
}

-(void)ruleSetWithMid:(NSString *)mid rulesname:(NSString *)rulesname object:(NSString *)object friends:(NSString *)friends  price:(NSString *)price
                tsnum:(NSString *)tsnum complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleSet";
    params[@"mid"] = mid;
    params[@"rulesname"] = rulesname;
    params[@"object"] = object;
    params[@"friends"] = friends;
    params[@"price"] = price;
    params[@"tsnum"] = tsnum;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
          //  model.list = [PremissModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
}

-(void)ruleModifyInfoWithrid:(NSString *)rid rulesname:(NSString *)rulesname object:(NSString *)object friends:(NSString *)friends price:(NSString *)price tsnum:(NSString *)tsnum complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleModifyInfo";
    params[@"rid"] = rid;
    params[@"rulesname"] = rulesname;
    params[@"object"] = object;
    params[@"friends"] = friends;
    params[@"price"] = price;
    params[@"tsnum"] = tsnum;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            //  model.list = [PremissModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];


}

-(void)ruleModifyStatusWithMid:(NSString *)mid rid:(NSString *)rid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleModifyStatus";
    params[@"mid"] = mid;
    params[@"rid"] = rid;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            //  model.list = [PremissModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
}


-(void)ruleDelWithRid:(NSString *)rid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleDel";
    params[@"rid"] = rid;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            //  model.list = [PremissModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}


-(void)ruleSetQueryFriendWithMid:(NSString *)mid rid:(NSString *)rid pageIndex:(int)pageIndex pageSize:(int)pageSize complete:(void (^)(BaseModel *))completeBlock{
     NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleSetQueryFriend";
    params[@"mid"] = mid;
    params[@"rid"] = rid;
    params[@"page"] = @(pageIndex);
    params[@"size"] = @(pageSize);
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
              model.list = [ZdFriendModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
}
@end