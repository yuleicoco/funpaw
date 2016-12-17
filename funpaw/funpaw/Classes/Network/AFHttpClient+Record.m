//
//  AFHttpClient+Record.m
//  petegg
//
//  Created by ldp on 16/6/28.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+Record.h"

@implementation AFHttpClient (Record)

//查询记录
-(void)queryHomeWithMid:(NSString *)mid
                   page:(int)page
               complete:(void(^)(BaseModel *model))completeBlock {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"mid"] = mid;
    params[@"common"] = @"queryHome";
    params[@"page"] = @(page);
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (model){
            model.list = [RecordModel arrayOfModelsFromDictionaries:model.list];
        }
        
        if (completeBlock) {
            completeBlock(model);
        }
    }];
}


@end
