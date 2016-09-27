//
//  NSDate+BeeExtension.h
//  JYJS
//
//  Created by DEV-IOS-2 on 15/12/24.
//  Copyright © 2015年 DEV-IOS-2. All rights reserved.
//
#pragma mark -

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)
#define YEAR	(12 * MONTH)

#pragma mark -

@interface NSDate(BeeExtension)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;

+ (NSDate*)dateFromFormatterString:(NSString*)dateStr dateFormat:(NSString*)dateFormat;
+ (NSDate *)dateWithString:(NSString *)string;
+ (NSDate *)now;
- (NSString *)stringWithDateFormat:(NSString *)format;
- (NSString *)timeAgo;
- (NSString *)timeLeft;
- (NSString *)timeLeftDay;

+ (long long)timeStamp;
@end
