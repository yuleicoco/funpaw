//
//  AFHttpClient+PersonDate.h
//  petegg
//
//  Created by czx on 16/4/7.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (PersonDate)
-(void)querPresenWithMid:(NSString *)mid
                  friend:(NSString *)friendId
                complete:(void(^)(BaseModel *model))completeBlock
                 failure:(void(^)())failureBlock;



-(void)querByIdSproutpetWithFriend:(NSString *)friendId
                         pageIndex:(int)pageIndex
                         pageSize:(int)pageSize
                         complete:(void(^)(BaseModel *model))completeBlock
                         failure:(void(^)())failureBlock;





@end
