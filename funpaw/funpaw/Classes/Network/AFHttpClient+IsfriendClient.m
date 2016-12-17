//
//  AFHttpClient+IsfriendClient.m
//  petegg
//
//  Created by czx on 16/4/23.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+IsfriendClient.h"

@implementation AFHttpClient (IsfriendClient)
-(void)optgzWithMid:(NSString *)mid friend:(NSString *)friendId type:(NSString *)type complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"optgz";
    params[@"mid"] = mid;
    params[@"friend"] = friendId;
    params[@"type"] = type;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            //  model.list = [PersonAttention arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    
    
    
    
    

}



@end
