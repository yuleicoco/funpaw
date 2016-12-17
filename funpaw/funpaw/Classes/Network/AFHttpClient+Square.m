//
//  AFHttpClient+Square.m
//  petegg
//
//  Created by ldp on 16/3/23.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+Square.h"

@implementation AFHttpClient (Square)

-(void)querySquareListWithMid:(NSString *)mid
                    pageIndex:(int)pageIndex
                     pageSize:(int)pageSize
                     complete:(void(^)(BaseModel *model))completeBlock
                      failure:(void(^)())failureBlock{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    params[@"common"] = @"querySproutpet";
    
    params[@"mid"] = mid;
    params[@"page"] = @(pageIndex);
    params[@"size"] = @(pageSize);
    //params[@"ftype"] = ftype;
    //    params[@"type"] = type;
    
    [self POST:@"clientAction.do" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completeBlock) {
            BaseModel* model = [[BaseModel alloc] initWithDictionary:responseObject[@"jsondata"] error:nil];
            model.list = [SquareModel arrayOfModelsFromDictionaries:model.list];
            completeBlock(model);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock();
        }
    }];
}

-(void)queryFollowSproutpetWithMid:(NSString *)mid
                         pageIndex:(int)pageIndex
                          pageSize:(int)pageSize
                          complete:(void(^)(BaseModel *model))completeBlock
                           failure:(void(^)())failureBlock{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];

    params[@"common"] = @"querySproutpet";
    
    params[@"mid"] = mid;
    params[@"page"] = @(pageIndex);
    params[@"size"] = @(pageSize);
    //params[@"ftype"] = ftype;
//    params[@"type"] = type;
   
    [self POST:@"clientAction.do" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completeBlock) {
            BaseModel* model = [[BaseModel alloc] initWithDictionary:responseObject[@"jsondata"] error:nil];
            model.list = [SquareModel arrayOfModelsFromDictionaries:model.list];
            completeBlock(model);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock();
        }
    }];
}

-(void)querySproutpetWithMid:(NSString *)mid pageIndex:(int)pageIndex pageSize:(int)pageSize complete:(void (^)(BaseModel *))completeBlock failure:(void (^)())failureBlock{

    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"common"] = @"queryFollowSproutpet";
    
    params[@"mid"] = mid;
    params[@"page"] = @(pageIndex);
    params[@"size"] = @(pageSize);
    //params[@"ftype"] = ftype;
    //    params[@"type"] = type;
    
    [self POST:@"clientAction.do" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completeBlock) {
            BaseModel* model = [[BaseModel alloc] initWithDictionary:responseObject[@"jsondata"] error:nil];
            model.list = [SquareModel arrayOfModelsFromDictionaries:model.list];
            completeBlock(model);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock();
        }
    }];
}

-(void)queryRecommendWithcomplete:(void (^)(BaseModel *))completeBlock failure:(void (^)())failureBlock{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"common"] = @"queryRecommend";

    [self POST:@"clientAction.do" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completeBlock) {
            BaseModel* model = [[BaseModel alloc] initWithDictionary:responseObject[@"jsondata"] error:nil];
            model.list = [SquareModel arrayOfModelsFromDictionaries:model.list];
            completeBlock(model);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock();
        }
    }];

}

@end
