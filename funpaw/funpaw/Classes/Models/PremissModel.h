//
//  PremissModel.h
//  petegg
//
//  Created by czx on 16/4/28.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface PremissModel : JSONModel
@property (nonatomic,copy)NSString <Optional> * deviceno;
@property (nonatomic,copy)NSString <Optional> * mid;
@property (nonatomic,copy)NSString <Optional> * tsnum;
@property (nonatomic,copy)NSString <Optional> * opttime;
@property (nonatomic,copy)NSString <Optional> * rid;
@property (nonatomic,copy)NSString <Optional> * type;
@property (nonatomic,copy)NSString <Optional> * isuse;
@property (nonatomic,copy)NSString <Optional> * object;
@property (nonatomic,copy)NSString <Optional> * over;
@property (nonatomic,copy)NSString <Optional> * price;
@property (nonatomic,copy)NSString <Optional> * friends;
@property (nonatomic,copy)NSString <Optional> * rulesname;

@end
