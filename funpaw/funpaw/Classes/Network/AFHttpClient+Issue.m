//
//  AFHttpClient+Issue.m
//  petegg
//
//  Created by czx on 16/4/20.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+Issue.h"

@implementation AFHttpClient (Issue)
-(void)addSproutpetWithMid:(NSString *)mid content:(NSString *)content type:(NSString *)type resources:(NSMutableString *)resources complete:(void(^)(BaseModel *model))completeBlock
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"addSproutpet";
    params[@"content"] = content;
    params[@"type"] = type;
    //params[@"suffix"] = suffix;
    params[@"resources"] = resources;
    params[@"mid"] = mid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            //  model.list = [PersonAttention arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
}


-(void)getVideoWithMid:(NSString *)mid
                pageIndex:(int)pageIndex
                 complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"getVideo";
    params[@"status"] = @"1";
    params[@"mid"] = mid;
    params[@"page"] = @(pageIndex);
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
              model.list = [IssueZiYuankuModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}
-(void)getPhotoGraphWithMid:(NSString *)mid pageIndex:(int)pageIndex complete:(void (^)(BaseModel *))completeBlock{
     NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"getPhotoGraph";
    params[@"mid"] = mid;
    params[@"page"] = @(pageIndex);

    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            model.list = [GetPhotoGraphModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
}


@end