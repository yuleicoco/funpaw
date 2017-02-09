//
//  ShareWork+device.h
//  funpaw
//
//  Created by yulei on 17/2/8.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "ShareWork.h"

@interface ShareWork (device)

/**
 查询设备状态

 @param mid           mid
 @param completeBlock su
 */
-(void)DeviceStats:(NSString *)mid   complete:(void (^)(BaseModel *))completeBlock;

@end
