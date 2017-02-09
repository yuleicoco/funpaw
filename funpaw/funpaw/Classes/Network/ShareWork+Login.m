//
//  ShareWork+Login.m
//  funpaw
//
//  Created by czx on 2017/2/9.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "ShareWork+Login.h"

@implementation ShareWork (Login)
-(void)checkWithPhone:(NSString *)phone type:(NSString *)type complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"email"] = phone;
    params[@"type"] = type;
    [self requestWithMethod:POST WithPath:@"common=getCode" WithParams:params WithSuccessBlock:^(BaseModel *model) {
        if (model) {
            //NSLog(@"哈哈");
            completeBlock(model);
        }
        if (completeBlock) {
            completeBlock(model);
        }

        
    } WithFailurBlock:^(NSError *error) {
        
    }];

}

-(void)memberRegisterWithEmail:(NSString *)email password:(NSString *)password complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"email"] = email;
    params[@"password"] = password;
    [self requestWithMethod:POST WithPath:@"common=memberRegister" WithParams:params WithSuccessBlock:^(BaseModel *model) {
        
        if (model) {
            //NSLog(@"哈哈");
             completeBlock(model);
        }
        
        
    } WithFailurBlock:^(NSError *error) {
        
    }];
    
    
    
    


}

-(void)memberLoginWithAccountnumber:(NSString *)accountnumber password:(NSString *)password complete:(void (^)(BaseModel *))completeBlock{





}




@end
