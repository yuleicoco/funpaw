//
//  GetPhotoGraphModel.h
//  petegg
//
//  Created by yulei on 16/5/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface GetPhotoGraphModel : JSONModel
@property (nonatomic,copy)NSString <Optional> * imagename;
@property (nonatomic,copy)NSString <Optional> * mid;
@property (nonatomic,copy)NSString <Optional> * networkaddress;
@property (nonatomic,copy)NSString <Optional> * pgid;
@property (nonatomic,copy)NSString <Optional> * pgtime;

@end
