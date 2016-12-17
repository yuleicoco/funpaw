//
//  AFHttpClient+PersonAttention.h
//  petegg
//
//  Created by czx on 16/4/18.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (PersonAttention)

-(void)queryFriendWithMid:(NSString * )mid
                      ftype:(NSString *)ftype
                      pageIndex:(int)pageIndex
                      pageSize:(int)pageSize
                      complete:(void(^)(BaseModel *model))completeBlock;



-(void)focusTipWithMid:(NSString *)mid
                   complete:(void(^)(BaseModel *model))completeBlock;


-(void)isreadWithMid:(NSString *)mid
                  type:(NSString *)type
                 complete:(void(^)(BaseModel *model))completeBlock;


-(void)focusTipCountWithMid:(NSString *)mid
                    complete:(void(^)(BaseModel *model))completeBlock;


@end
