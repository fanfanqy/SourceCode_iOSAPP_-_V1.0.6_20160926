//
//  NSDate+BeeExtension.mm
//  JYJS
//
//  Created by DEV-IOS-2 on 15/12/24.
//  Copyright © 2015年 DEV-IOS-2. All rights reserved.
//

#import "NSDate+BeeExtension.h"


// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSDate(BeeExtension)

@dynamic year;
@dynamic month;
@dynamic day;
@dynamic hour;
@dynamic minute;
@dynamic second;
@dynamic weekday;

- (NSInteger)year
{
	return [[NSCalendar currentCalendar] components:NSYearCalendarUnit
										   fromDate:self].year;
}

- (NSInteger)month
{
	return [[NSCalendar currentCalendar] components:NSMonthCalendarUnit
										   fromDate:self].month;
}

- (NSInteger)day
{
	return [[NSCalendar currentCalendar] components:NSDayCalendarUnit
										   fromDate:self].day;
}

- (NSInteger)hour
{
	return [[NSCalendar currentCalendar] components:NSHourCalendarUnit
										   fromDate:self].hour;
}

- (NSInteger)minute
{
	return [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit
										   fromDate:self].minute;
}

- (NSInteger)second
{
	return [[NSCalendar currentCalendar] components:NSSecondCalendarUnit
										   fromDate:self].second;
}

- (NSInteger)weekday
{
	return [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit
										   fromDate:self].weekday;
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
#if 0
	
	NSTimeInterval time = [self timeIntervalSince1970];
	NSUInteger timeUint = (NSUInteger)time;
	return [[NSNumber numberWithUnsignedInteger:timeUint] stringWithDateFormat:format];
	
#else
	
	// thansk @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
	
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
	return [dateFormatter stringFromDate:self];
	
#endif
}

- (NSString *)timeAgo
{
	NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
	
	if (delta < 1 * MINUTE)
	{
		return @"刚刚";
	}
	else if (delta < 2 * MINUTE)
	{
		return @"1分钟前";
	}
	else if (delta < 45 * MINUTE)
	{
		int minutes = floor((double)delta/MINUTE);
		return [NSString stringWithFormat:@"%d分钟前", minutes];
	}
	else if (delta < 90 * MINUTE)
	{
		return @"1小时前";
	}
	else if (delta < 24 * HOUR)
	{
		int hours = floor((double)delta/HOUR);
		return [NSString stringWithFormat:@"%d小时前", hours];
	}
	else if (delta < 48 * HOUR)
	{
		return @"昨天";
	}
	else if (delta < 30 * DAY)
	{
		int days = floor((double)delta/DAY);
		return [NSString stringWithFormat:@"%d天前", days];
	}
	else if (delta < 12 * MONTH)
	{
		int months = floor((double)delta/MONTH);
		return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
	}

	int years = floor((double)delta/MONTH/12.0);
	return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}

- (NSString *)timeLeft
{
	long int delta = lround( [self timeIntervalSinceDate:[NSDate date]] );

    NSMutableString * result = [NSMutableString string];
    
    if ( delta >= YEAR )
    {
		NSInteger years = ( delta / YEAR );
        [result appendFormat:@"%d年", years];
        delta -= years * YEAR ;
    }
    
	if ( delta >= MONTH )
	{
        NSInteger months = ( delta / MONTH );
        [result appendFormat:@"%d月", months];
        delta -= months * MONTH ;
	}
    
    if ( delta >= DAY )
    {
        NSInteger days = ( delta / DAY );
        [result appendFormat:@"%d天", days];
        delta -= days * DAY ;
    }
    
    if ( delta >= HOUR )
    {
        NSInteger hours = ( delta / HOUR );
        [result appendFormat:@"%d小时", hours];
        delta -= hours * HOUR ;
    }
    
    if ( delta >= MINUTE )
    {
        NSInteger minutes = ( delta / MINUTE );
        [result appendFormat:@"%d分钟", minutes];
        delta -= minutes * MINUTE ;
    }

	NSInteger seconds = ( delta / SECOND );
	[result appendFormat:@"%d秒", seconds];

	return result;
}


- (NSString *)timeLeftDay
{
	long int delta = lround( [self timeIntervalSinceDate:[NSDate date]] );
    
    NSMutableString * result = [NSMutableString string];
    
    if ( delta >= YEAR )
    {
		NSInteger years = ( delta / YEAR );
        [result appendFormat:@"%d年", years];
        delta -= years * YEAR ;
    }
    
	if ( delta >= MONTH )
	{
        NSInteger months = ( delta / MONTH );
        [result appendFormat:@"%d月", months];
        delta -= months * MONTH ;
	}
    
    if ( delta >= DAY )
    {
        NSInteger days = ( delta / DAY );
        [result appendFormat:@"%d天", days];
        delta -= days * DAY ;
        [result insertString:@"还有" atIndex:0];
    }else
    {
        [result appendFormat:@"今天"];
    }
    
	return result;
}

+ (long long)timeStamp
{
	return (long long)[[NSDate date] timeIntervalSince1970];
}

+ (NSDate *)dateWithString:(NSString *)string
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd zzz"];
    NSDate* date = [formatter dateFromString:string];
    return date;
}

+(NSDate*)dateFromFormatterString:(NSString*)dateStr dateFormat:(NSString*)dateFormat
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSDate* date = [formatter dateFromString:dateStr];
    return date;
}

+ (NSDate *)now
{
	return [NSDate date];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSDate_BeeExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
