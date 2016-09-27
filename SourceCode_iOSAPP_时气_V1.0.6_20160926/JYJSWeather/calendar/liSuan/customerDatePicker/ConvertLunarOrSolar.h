//
//  ConvertLunar2Solar.h
//  naviel
//
//  Created by mac on 14-6-13.
//  Copyright (c) 2014年 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertLunarOrSolar : NSObject
/**
 * 通用阴历计算阳历
 * @param lunarDay
 * @param lunarMonth
 * @param lunarYear
 * @param lunarLeap
 * @return NSArray
 */
-(NSArray*)convertLunar2Solar:(NSInteger)lunarDay lunarMonth:(NSInteger)lunarMonth lunarYear:(NSInteger)lunarYear lunarLeap:(NSInteger)lunarLeap;
/**
 * 通用阴历计算阳历需要时区
 * @param lunarDay
 * @param lunarMonth
 * @param lunarYear
 * @param lunarLeap
 * @return NSArray
 */
-(NSArray*)convertLunar2SolarTZ:(NSInteger)lunarDay lunarMonth:(NSInteger)lunarMonth lunarYear:(NSInteger)lunarYear lunarLeap:(NSInteger)lunarLeap timeZone:(double)timeZone;
/**
 * 通用阳历计算阴历
 * @param lunarDay
 * @param lunarMonth
 * @param lunarYear
 * @param lunarLeap
 * @return NSArray
 */
-(NSArray*)convertSolar2Lunar:(int)dd mm:(int)mm yy:(int)yy;
/**
 * 通用阳历计算阴历需要时区
 * @param lunarDay
 * @param lunarMonth
 * @param lunarYear
 * @param lunarLeap
 * @return NSArray
 */
-(NSArray*)convertSolar2LunarTZ:(int)dd mm:(int)mm yy:(int)yy timeZone:(double)timeZone;

/**
 通用阳历计算阴历
 
 @param date 阳历日期
 
 @return lunarDayS,lunarMonthS,lunarYearS,lunarLeapS
 */
-(NSArray*)convertSolar2Lunar:(NSDate*)date;

-(NSString*)convertSolar2LunarStr:(NSDate*)date;

@end
