//
//  ShareWork+Morephotovideo.h
//  funpaw
//
//  Created by czx on 2017/2/10.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "ShareWork.h"

@interface ShareWork (Morephotovideo)
//抓拍
-(void)getPhotoGraphWithMid:(NSString *)mid page:(int)page complete:(void (^)(BaseModel * model))completeBlock;

//删除抓拍
-(void)delPhotoGraphWith:(NSString *)mid filename:(NSString *)filename complete:(void (^)(BaseModel * model))completeBlock;



@end
