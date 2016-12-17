//
//  AFHttpClient+LoginAndRegister.m
//  petegg
//
//  Created by ldp on 16/6/27.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+LoginAndRegister.h"

@implementation AFHttpClient (LoginAndRegister)

//注册
-(void)registerWithEmail:(NSString *)email
                password:(NSString *)password
                complete:(void(^)(BaseModel *model))completeBlock {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"email"] = email;
    params[@"password"] = password;
    params[@"common"] = @"memberRegister";
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (model){
            
        }
        
        if (completeBlock) {
            completeBlock(model);
        }
    }];
}


@end
