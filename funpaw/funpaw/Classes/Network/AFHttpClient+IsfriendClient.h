//
//  AFHttpClient+IsfriendClient.h
//  petegg
//
//  Created by czx on 16/4/23.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (IsfriendClient)
//关注
-(void)optgzWithMid:(NSString *)mid
                friend:(NSString *)friendId
                type:(NSString *)type
                 complete:(void(^)(BaseModel *model))completeBlock;



@end