//
//  AFHttpClient+Rank.h
//  petegg
//
//  Created by czx on 16/4/14.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Rank)
-(void)queryrankingWithMid:(NSString *)mid
                       ranktype:(NSString * )ranktype
                       complete:(void(^)(BaseModel *model))completeBlock;

@end
