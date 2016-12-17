//
//  BlackListModel.h
//  petegg
//
//  Created by czx on 16/4/27.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface BlackListModel : JSONModel
@property (nonatomic,copy)NSString <Optional> * blid;
@property (nonatomic,copy)NSString <Optional> * friend;
@property (nonatomic,copy)NSString <Optional> * headportrait;
@property (nonatomic,copy)NSString <Optional> * mid;
@property (nonatomic,copy)NSString <Optional> * nickname;
@property (nonatomic,copy)NSString <Optional> * opttime;


@end
