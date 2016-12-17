//
//  IssueZiYuankuModel.h
//  petegg
//
//  Created by czx on 16/4/23.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface IssueZiYuankuModel : JSONModel
@property (nonatomic,copy)NSString <Optional> * deviceno;
@property (nonatomic,copy)NSString <Optional> * filename;
@property (nonatomic,copy)NSString <Optional> * mid;
@property (nonatomic,copy)NSString <Optional> * networkaddress;
@property (nonatomic,copy)NSString <Optional> * nickname;
@property (nonatomic,copy)NSString <Optional> * opttime;
@property (nonatomic,copy)NSString <Optional> * producepeople;
@property (nonatomic,copy)NSString <Optional> * sipno;
@property (nonatomic,copy)NSString <Optional> * status;
@property (nonatomic,copy)NSString <Optional> * thumbnails;
@property (nonatomic,copy)NSString <Optional> * type;
@property (nonatomic,copy)NSString <Optional> * vid;
@property (nonatomic,copy)NSString <Optional> * vnum;
@end