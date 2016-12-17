//
//  PhotoModel.h
//  petegg
//
//  Created by yulei on 16/4/18.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@property (nonatomic,copy)NSString *imagename;
@property (nonatomic,copy)NSString *mid;
@property (nonatomic,copy)NSString *networkaddress;
@property (nonatomic,copy)NSString *pgid;
@property (nonatomic,copy)NSString *pgtime;


@end
