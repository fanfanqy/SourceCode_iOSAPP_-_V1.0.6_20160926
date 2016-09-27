//
//  Tool_ChineseCalendar.h
//  XJAudiobooks
//
//  Created by chris on 14-5-26.
//  Copyright (c) 2014年 chris. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Tool_ChineseCalendar : NSObject


/**
 * 绘制系统时间万年历数组
 */
-(NSMutableArray*)calendar:(NSInteger)y m:(NSInteger)m tDate:(NSDate*)tDate;
/**
 Objective-C Unicode 转换成中文
 
 @param unicodeStr unicodeStr description
 
 @return value
 */
+(NSString*)replaceUnicode:(NSString *)unicodeStr;

/**
 公历y年某m+1月的天数
 
 @param y 年
 @param m 月
 
 @return 公历y年某m+1月的天数
 */
+(NSInteger)solarDays:(NSInteger)y m:(NSInteger)m;
@end
