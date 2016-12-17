//
//  BaseModel.h
//  petegg
//
//  Created by ldp on 16/3/23.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "JSONModel.h"

@interface BaseModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *retVal;

@property (nonatomic, copy) NSString<Optional> *content;

@property (nonatomic, copy) NSString<Optional> *retDesc;

@property (nonatomic, copy) NSString<Optional> *retCode;

@property (nonatomic, copy) NSString<Optional> *totalrecords;

@property (nonatomic, strong) NSArray<Optional> *list;

@end
