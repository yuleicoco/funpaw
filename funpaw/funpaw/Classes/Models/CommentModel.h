//
//  CommentModel.h
//  petegg
//
//  Created by ldp on 16/4/10.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@protocol CommentModel
@end
@interface CommentModel : JSONModel

@property (nonatomic, copy) NSString *memname;

@property (nonatomic, copy) NSString *bmemname;

@property (nonatomic, copy) NSString *ptype;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *bid;  //

@property (nonatomic, copy) NSString *opttime;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *bcid;

@property (nonatomic, copy) NSString *cid;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *action;

@property (nonatomic, copy) NSString *race;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *wid;

@property (nonatomic, strong) NSMutableArray<CommentModel, Optional> *list;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *content;

@end

