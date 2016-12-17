//
//  TransactionRecordModel.h
//  petegg
//
//  Created by czx on 16/5/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface TransactionRecordModel : JSONModel
@property (nonatomic,copy)NSString <Optional> * mid;
@property (nonatomic,copy)NSString <Optional> * money;
@property (nonatomic,copy)NSString <Optional> * object;
@property (nonatomic,copy)NSString <Optional> * opttime;
@property (nonatomic,copy)NSString <Optional> * trid;
@property (nonatomic,copy)NSString <Optional> * type;


@end
