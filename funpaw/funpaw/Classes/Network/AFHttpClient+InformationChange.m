//
//  AFHttpClient+InformationChange.m
//  petegg
//
//  Created by czx on 16/4/26.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+InformationChange.h"

@implementation AFHttpClient (InformationChange)
-(void)queryByIdMemberWithMid:(NSString *)mid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"queryByIdMember";
    params[@"mid"] = mid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
              model.list = [InformationModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}

-(void)modifyMemberWithMid:(NSString *)mid nicname:(NSString *)nickname qq:(NSString *)qq address:(NSString *)address signature:(NSString *)signature pet_sex:(NSString *)pet_sex pet_birthday:(NSString *)pet_birthday pet_race:(NSString *)pet_race complete:(void (^)(BaseModel *))completeBlock
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"modifyMember";
    params[@"mid"] = mid;
    params[@"nickname"] = nickname;
    params[@"country"] = @"中国";
    params[@"qq"] = qq;
    params[@"address"] = address;
    params[@"signature"] = signature;
    params[@"pet_sex"] = pet_sex;
    params[@"pet_birthday"] = pet_birthday;
    params[@"pet_race"] = pet_race;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
           // model.list = [InformationModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
}
-(void)modifyHeadportraitWithMid:(NSString *)mid picture:(NSString *)picture complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"modifyHeadportrait";
    params[@"mid"] = mid;
    params[@"picture"] = picture;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            // model.list = [InformationModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    
    
}

-(void)modifyQqStatusWithMid:(NSString *)mid object:(NSString *)object complete:(void (^)(BaseModel *))completeBlock{
     NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"modifyQqStatus";
    params[@"mid"] = mid;
    params[@"object"] = object;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            // model.list = [InformationModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];




}


@end
