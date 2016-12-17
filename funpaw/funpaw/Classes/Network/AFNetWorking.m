//
//  AFNetWorking.m
//  petegg
//
//  Created by yulei on 16/4/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFNetWorking.h"
#import "VideoModel.h"

@implementation AFNetWorking

+ (void)postWithApi:(NSString *)api parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppUtil getServerTest],api];
    
    
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (error) {
            
            failure(error);
            
        }
    }];
    
    
    
}

@end
