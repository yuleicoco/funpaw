//
//  ShareWork+Morephotovideo.h
//  funpaw
//
//  Created by czx on 2017/2/10.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "ShareWork.h"

@interface ShareWork (Morephotovideo)
-(void)getPhotoGraphWithMid:(NSString *)mid page:(int)page complete:(void (^)(BaseModel * model))completeBlock;



@end
