//
//  AFHttpClient+PersonAttention.m
//  petegg
//
//  Created by czx on 16/4/18.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+PersonAttention.h"

@implementation AFHttpClient (PersonAttention)
-(void)queryFriendWithMid:(NSString *)mid ftype:(NSString *)ftype pageIndex:(int)pageIndex pageSize:(int)pageSize complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"queryFriend";
    params[@"ftype"] = ftype;
    params[@"page"] = @(pageIndex);
    params[@"size"] = @(pageSize);
    params[@"mid"] = mid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            model.list = [NearbyModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    
}
    

-(void)focusTipWithMid:(NSString *)mid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"focusTip";
    params[@"mid"] = mid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            model.list = [PersonAttention arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    
}

-(void)isreadWithMid:(NSString *)mid type:(NSString *)type complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"isread";
    params[@"mid"] = mid;
    params[@"type"] = type;
    
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
      
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    


}


-(void)focusTipCountWithMid:(NSString *)mid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"focusTipCount";
    params[@"mid"] = mid;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (completeBlock) {
            completeBlock(model);
        }
    }];

    


}








@end
