//
//  DetailModel.h
//  petegg
//
//  Created by czx on 16/4/8.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "BaseModel.h"

@interface DetailModel : JSONModel
@property (nonatomic,copy)NSString <Optional> * address;

@property (nonatomic,copy)NSString <Optional> * attributive;

@property (nonatomic,copy)NSString <Optional> * comments;

@property (nonatomic,copy)NSString <Optional> * content;

@property (nonatomic,copy)NSString <Optional> * headportrait;

@property (nonatomic,copy)NSString <Optional> * isfriend;

@property (nonatomic,copy)NSString <Optional> * mid;

@property (nonatomic,copy)NSString <Optional> * nickname;

@property (nonatomic,copy)NSString <Optional> * pet_age;

@property (nonatomic,copy)NSString <Optional> * pet_race;

@property (nonatomic,copy)NSString <Optional> * pet_sex;

@property (nonatomic,copy)NSString <Optional> * praises;

@property (nonatomic,copy)NSString <Optional> * publishtime;

@property (nonatomic,copy)NSString <Optional> * publishuser;

@property (nonatomic,copy)NSString <Optional> * reports;

@property (nonatomic,copy)NSString <Optional> * resources;

@property (nonatomic,copy)NSString <Optional> * status;

@property (nonatomic,copy)NSString <Optional> * stid;

@property (nonatomic,copy)NSString <Optional> * thumbnails;

@property (nonatomic,copy)NSString <Optional> * type;

@property (nonatomic,copy)NSString <Optional> * views;

@property (nonatomic, strong) UIImage<Optional> *cutImage;

@end
