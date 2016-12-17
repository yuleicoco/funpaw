//
//  AFHttpClient+Nearby.m
//  petegg
//
//  Created by czx on 16/4/12.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+Nearby.h"

@implementation AFHttpClient (Nearby)
-(void)querNeighborhoodWithMid:(NSString *)mid pageIndex:(int)pageIndex pageSize:(int)pageSize complete:(void (^)(BaseModel *))completeBlock
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"common"] = @"neighborhood";
    params[@"mid"] = mid;
    params[@"page"] = @(pageIndex);
    params[@"size"] = @(pageSize);
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (model){
            model.list = [NearbyModel arrayOfModelsFromDictionaries:model.list];
        }
        
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}

-(void)queriCanVisitWithMid:(NSString *)mid pageIndex:(int)pageIndex pageSize:(int)pageSize complete:(void (^)(BaseModel *))completeBlock{

    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"common"] = @"iCanVisit";
    params[@"mid"] = mid;
    params[@"page"] = @(pageIndex);
    params[@"size"] = @(pageSize);
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (model){
            model.list = [NearbyModel arrayOfModelsFromDictionaries:model.list];
        }
        
        if (completeBlock) {
            completeBlock(model);
        }
    }];



}



-(void)searcheSomeWithMid:(NSString *)mid condition:(NSString *)condtion pageIndex:(int)pageIndex pageSize:(int)pageSize complete:(void (^)(BaseModel *))completeBlock{
     NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"common"] = @"searchPeople";
    params[@"mid"] = mid;
    params[@"condition"] = condtion;
    params[@"page"] = @(pageIndex);
    params[@"size"] = @(pageSize);

    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (model){
            model.list = [NearbyModel arrayOfModelsFromDictionaries:model.list];
        }
        
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}



@end
