//
//  ShareWork+Morephotovideo.m
//  funpaw
//
//  Created by czx on 2017/2/10.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "ShareWork+Morephotovideo.h"

@implementation ShareWork (Morephotovideo)
-(void)getPhotoGraphWithMid:(NSString *)mid page:(int)page complete:(void (^)(BaseModel *))completeBlock
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"mid"] = mid;
    params[@"page"] = @(page);

    [self requestWithMethod:POST WithPath:@"common=getPhotoGraph" WithParams:params WithSuccessBlock:^(BaseModel *model) {
        
        if (model) {

            model.list = [PhotoGrapgModel arrayOfModelsFromDictionaries:model.list];

        }
        
        if (completeBlock) {
            completeBlock(model);
        }
        
        
    } WithFailurBlock:^(NSError *error) {
        
    }];
    






}


@end