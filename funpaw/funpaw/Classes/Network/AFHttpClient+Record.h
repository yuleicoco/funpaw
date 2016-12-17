//
//  AFHttpClient+Record.h
//  petegg
//
//  Created by ldp on 16/6/28.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Record)

//查询记录
-(void)queryHomeWithMid:(NSString *)mid
                   page:(int)page
               complete:(void(^)(BaseModel *model))completeBlock;

@end
