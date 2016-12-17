//
//  ImageModel.h
//  petegg
//
//  Created by yulei on 16/4/18.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@property (nonatomic,copy)NSString *imagename;
@property (nonatomic,copy)NSString * networkaddress;
@end
