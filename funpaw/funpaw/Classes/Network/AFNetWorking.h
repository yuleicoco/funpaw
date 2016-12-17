//
//  AFNetWorking.h
//  petegg
//
//  Created by yulei on 16/4/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpSuccess)(id json);

typedef void (^HttpFailure)(NSError *error);

@interface AFNetWorking : NSObject

/**
 *  请求
 *
 *  @param api        接口
 *  @param parameters 参数
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)postWithApi:(NSString *)api parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;

@end
