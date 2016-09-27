//
//  dbTool.h
//  XJKJwnl
//
//  Created by xjkjmac02 on 14-11-20.
//  Copyright (c) 2014年 xjkjmac02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


@interface dbTool : NSObject

+(NSMutableArray*)selectAllWithStartYear:(int)startYear startMonth:(int)startMonth endYear:(int)endYear endMonth:(int)endMonth cate:(NSString *)cate tag:(int)tag;
+ (NSString*) getPathWithDBName:(NSString *)DBName;
@end
