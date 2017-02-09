//
//  ShareWork+device.m
//  funpaw
//
//  Created by yulei on 17/2/8.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "ShareWork+device.h"

@implementation ShareWork (device)

-(void)DeviceStats:(NSString *)mid   complete:(void (^)(BaseModel *))completeBlock
{
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"mid"] = mid;
   
    [self requestWithMethod:POST WithPath:@"common=queryMyDevice" WithParams:parms WithSuccessBlock:^(BaseModel *model) {
        
        if (model) {
           // NSLog(@"哈哈");
        }
        
        
    } WithFailurBlock:^(NSError *error) {
        
    }];

   
}



@end
