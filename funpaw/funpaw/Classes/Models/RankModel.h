//
//  RankModel.h
//  petegg
//
//  Created by czx on 16/4/14.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface RankModel : JSONModel
@property (nonatomic,copy)NSString <Optional> * bid;
@property (nonatomic,copy)NSString <Optional> * headportrait;
@property (nonatomic,copy)NSString <Optional> * mid;
@property (nonatomic,copy)NSString <Optional> * nickname;
@property (nonatomic,copy)NSString <Optional> * praises;
@property (nonatomic,copy)NSString <Optional> * ranking;
@property (nonatomic,copy)NSString <Optional> * type;


@end
