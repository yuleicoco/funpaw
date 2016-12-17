//
//  AFHttpClient+PersonDate.m
//  petegg
//
//  Created by czx on 16/4/7.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+PersonDate.h"

@implementation AFHttpClient (PersonDate)

-(void)querPresenWithMid:(NSString *)mid friend:(NSString *)friendId complete:(void (^)(BaseModel *))completeBlock failure:(void (^)())failureBlock{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    params[@"common"] = @"getHomePage";
    params[@"mid"] = mid;
    params[@"friend"] = friendId;
    
    [self POST:@"clientAction.do" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completeBlock) {
            
            BaseModel* model = [[BaseModel alloc] initWithDictionary:responseObject[@"jsondata"] error:nil];
            model.list = [PersonDetailModel arrayOfModelsFromDictionaries:model.list];
            
            completeBlock(model);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock();
        }
    }];

    
}

-(void)querByIdSproutpetWithFriend:(NSString *)friendId pageIndex:(int)pageIndex pageSize:(int)pageSize complete:(void (^)(BaseModel *))completeBlock failure:(void (^)())failureBlock{

     NSMutableDictionary* params = [NSMutableDictionary dictionary];
     params[@"common"] = @"queryByIdSproutpet";
     params[@"friend"] = friendId;
     params[@"page"] = @(pageIndex);
     params[@"size"] = @(pageSize);


    [self POST:@"clientAction.do" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completeBlock) {
            
            BaseModel* model = [[BaseModel alloc] initWithDictionary:responseObject[@"jsondata"] error:nil];
            model.list = [DetailModel arrayOfModelsFromDictionaries:model.list];
            
            completeBlock(model);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock();
        }
    }];
}

@end