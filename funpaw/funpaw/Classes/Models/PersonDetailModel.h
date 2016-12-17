//
//  PersonDetailModel.h
//  petegg
//
//  Created by czx on 16/4/8.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "BaseModel.h"

@interface PersonDetailModel : JSONModel
@property (nonatomic,copy)NSString <Optional> * fsnum;

@property (nonatomic,copy)NSString <Optional> * gznum;

@property (nonatomic,copy)NSString <Optional> * headportrait;

@property (nonatomic,copy)NSString <Optional> * isfriend;

@property (nonatomic,copy)NSString <Optional> * isinblacklist;

@property (nonatomic,copy)NSString <Optional> * mid;

@property (nonatomic,copy)NSString <Optional> * nickname;

@property (nonatomic,copy)NSString <Optional> * openvideo;

@property (nonatomic,copy)NSString <Optional> * pet_age;

@property (nonatomic,copy)NSString <Optional> * pet_race;

@property (nonatomic,copy)NSString <Optional> * pet_sex;

@property (nonatomic,copy)NSString <Optional> * qq;

@property (nonatomic,copy)NSString <Optional> * signature;

@end