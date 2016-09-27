//
//  WanNianLiDate.h
//  FaLv
//
//  Created by mac on 14-12-5.
//  Copyright (c) 2014年 xjkjmac01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface WanNianLiDate : NSObject
+ (FMDatabase*) getDataBase;
//+(void)updateSelectedWallpaperListDB;
+(void)updateJYJSFile;
@end
