//
//  AFHttpClient+Rank.m
//  petegg
//
//  Created by czx on 16/4/14.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+Rank.h"

@implementation AFHttpClient (Rank)

-(void)queryrankingWithMid:(NSString *)mid ranktype:(NSString *)ranktype complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"common"] = @"queryranking";
    params[@"mid"] = mid;
    params[@"ranktype"] = ranktype;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (model){
            model.list = [RankModel arrayOfModelsFromDictionaries:model.list];
        }
        
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    

}

@end
