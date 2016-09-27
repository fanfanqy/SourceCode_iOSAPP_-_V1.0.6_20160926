//
//  wanNianLiTool.h
//  LiSuanDemo
//
//  Created by han on 14/12/16.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wanNianLiTool : NSObject

/**
 *  时辰,财神,喜神,吉凶
 *
 *  @param index 数组中位置
 *
 *  @return 字符串
 */
+(NSString *)getOldTime:(int)index;

+(NSArray *)getShiChenJiXiong:(NSString *)key;

+(NSString *)getTimeFromArrayIndex:(int)indexOut andIndex:(int)indexIn;

+(NSString *)getOldHour;

+(NSString *)getXiTouJiXiong:(NSString *)key;
@end
