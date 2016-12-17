//
//  PersonAttention.h
//  petegg
//
//  Created by czx on 16/4/19.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface PersonAttention : JSONModel
@property (nonatomic,copy)NSString <Optional> * content;
@property (nonatomic,copy)NSString <Optional> * headportrait;
@property (nonatomic,copy)NSString <Optional> * isfriend;
@property (nonatomic,copy)NSString <Optional> * mid;
@property (nonatomic,copy)NSString <Optional> * nickname;
@property (nonatomic,copy)NSString <Optional> * num;
@property (nonatomic,copy)NSString <Optional> * opttime;
@property (nonatomic,copy)NSString <Optional> * pet_age;
@property (nonatomic,copy)NSString <Optional> * pet_race;
@property (nonatomic,copy)NSString <Optional> * pet_sex;
@property (nonatomic,copy)NSString <Optional> * thumbnail;
@property (nonatomic,copy)NSString <Optional> * tid;
@property (nonatomic,copy)NSString <Optional> * type;

@end
