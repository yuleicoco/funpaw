//
//  AFHttpClient+Nearby.h
//  petegg
//
//  Created by czx on 16/4/12.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Nearby)

-(void)querNeighborhoodWithMid:(NSString *)mid
                       pageIndex:(int)pageIndex
                       pageSize:(int)pageSize
                       complete:(void(^)(BaseModel *model))completeBlock;


-(void)queriCanVisitWithMid:(NSString *)mid
                        pageIndex:(int)pageIndex
                        pageSize:(int)pageSize
                        complete:(void(^)(BaseModel *model))completeBlock;



-(void)searcheSomeWithMid:(NSString *)mid
                      condition:(NSString *)condtion
                      pageIndex:(int)pageIndex
                      pageSize:(int)pageSize
                      complete:(void(^)(BaseModel *model))completeBlock;

@end
