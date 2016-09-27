//
//  Datetime.h
//  CalendarTest
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Datetime : NSObject
//所有年列表
+(NSArray *)GetAllYearArray;

//所有月列表
+(NSArray *)GetAllMonthArray;

//获取农历节日
+(NSString *)GetLunarFestival:(int)year andMonth:(int)month andDay:(int)day;

//获取指定年份指定月份的星期排列表
+(NSArray *)GetDayArrayByYear:(int) year
                     andMonth:(int) month;
//获取指定年份指定月份的星期排列表(农历)
+(NSArray *)GetLunarDayArrayByYear:(int) year
                          andMonth:(int) month;

//获取指定年份指定月份指定日子的一周排列,数组中只有day
+(NSMutableArray *)GetDayArrayByYear:(int) year andMonth:(int) month andDay:(int) day;

//获取指定年份指定月份指定日子的自定义天数排列一般小于28天,数组中有day,month,year
+(NSMutableArray *)GetDayDicByYear:(int) year andMonth:(int) month andDay:(int) day andCountsDay:(int)countsDay;

//根据传入某一天日期,获取这天前后共计一周的日子排列(农历)
+(NSMutableArray *)GetLunarDayArrayByYear:(int) year
                          andMonth:(int) month andDay:(int)day;

//获取某年某月某日的对应农历
+(NSString *)GetLunarDayByYear:(int) year
                      andMonth:(int) month
                        andDay:(int) day;

//获取指定年份指定月份的相邻2个月总共3个月的排列表,只有日
+(NSMutableArray *)GetThreeMonthArrayByYear:(int) year
                     andMonth:(int) month;
//获取指定年份指定月份的相邻2个月总共3个月的排列表,年月日
+(NSMutableArray *)GetThreeMonthDicByYear:(int) year
                                 andMonth:(int) month;
//具体某一天是周几
+(int)GetTheWeekOfDayByYera:(int)year andByMonth:(int)month andByDay:(int)day;
//以YYYY.MM.dd格式输出年月日
+(NSString*)getDateTime;

//以YYYY年MM月dd日格式输出年月日
+(NSString*)GetDateTime;

//以YYYY年MMdd格式输出此时的农历年月日
+(NSString*)GetLunarDateTime;

+(NSString *)GetYear;

+(NSString *)GetMonth;

+(NSString *)GetDay;

+(NSString *)GetHour;

+(NSString *)GetMinute;

+(NSString *)GetSecond;
//得到year年month月的天数
+(int)GetNumberOfDayByYera:(int)year andByMonth:(int)month;
//得到某月第一天是周几
+(int)GetTheWeekOfDayByYera:(int)year
                 andByMonth:(int)month;
//未来或者过去多少天的日期汇总(这个函数小于等于28是可以计算的,如果是大于28,需要这个月前后2个月,总共5个月,依此类推),数组中是 年-月-日,组成的日期
+(NSMutableArray<NSString *>*)GetTenDaysInFutureByYear:(int)year andByMonth:(int)month andByDay:(int)day andCount:(int)countday;
+ (NSDate *)dateFromString:(NSString *)dateString;

//是否是法定节假日
+(BOOL)isLegalHoliday:(NSInteger )monthTemp andDay:(NSInteger )dayTemp;
//是不是调休
+(BOOL)isAdjustDay:(NSInteger )monthTemp andDay:(NSInteger )dayTemp;

//获取一年有多少天
+(int)GetOneYearCountDay:(int)year;
//获取一年的时间表
+(NSMutableArray *)GetOneYear:(int)year;

//获取某一天是一年中第几天
+(int)GetOneDayIndexInOneYear:(int)year andMonth:(int)month andDay:(int)day;
@end
