//
//  AFHttpClient.m
//  petegg
//
//  Created by ldp on 16/3/23.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@implementation AFHttpClient

singleton_implementation(AFHttpClient)
//http://180.97.80.227:8080
- (instancetype)init{
    if (self = [super initWithBaseURL:[NSURL URLWithString: [AppUtil getServerTest]]]) {
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", @"application/json", nil];
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWWAN------");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWiFi------");
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"-------AFNetworkReachabilityStatusNotReachable------");
                    
                    break;
                default:
                    break;
            }
        }];
        [self.reachabilityManager startMonitoring];
    }
    
    return self;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation * _Nonnull, id _Nonnull))success failure:(void (^)(AFHTTPRequestOperation * _Nullable, NSError * _Nonnull))failure{
    
    parameters[@"classes"] = @"appinterface";
    parameters[@"method"] = @"json";
    
    return [super POST:URLString parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(id)parameters result:(void (^)(BaseModel* model))result {
    
    parameters[@"classes"] = @"appinterface";
    parameters[@"method"] = @"json";
    
    return [super POST:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError* error = nil;
        NSLog(@"respons === %@", [self DataTOjsonString:responseObject]);
        BaseModel* model = [[BaseModel alloc] initWithDictionary:responseObject[@"jsondata"] error:&error];
        
        NSLog(@"Requese.URL === %@", operation.request.URL.absoluteString);
        
        if (error || [model.retCode integerValue] != 0) {
            [[AppUtil appTopViewController] showHint:error ? [error localizedDescription] : model.retDesc];
        
            if (result) {
                result(nil);
            }
            return ;
        }
        
        if (result) {
            result(model);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       [[AppUtil appTopViewController] showHint: NSLocalizedString(@"INFO_NetNoReachable", nil)];
        if (result) {
            result(nil);
        }
    }];
}


-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
