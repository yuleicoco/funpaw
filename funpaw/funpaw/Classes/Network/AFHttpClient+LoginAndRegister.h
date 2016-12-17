//
//  AFHttpClient+LoginAndRegister.h
//  petegg
//
//  Created by ldp on 16/6/27.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (LoginAndRegister)

//注册
-(void)registerWithEmail:(NSString *)email
                password:(NSString *)password
                complete:(void(^)(BaseModel *model))completeBlock;




@end
