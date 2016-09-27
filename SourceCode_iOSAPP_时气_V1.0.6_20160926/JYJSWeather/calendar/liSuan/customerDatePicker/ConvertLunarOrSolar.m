//
//  ConvertLunar2Solar.m
//  naviel
//
//  Created by mac on 14-6-13.
//  Copyright (c) 2014年 chris. All rights reserved.
//
#import "ConvertLunarOrSolar.h"
#import "Date+string.h"
#import "NSDate+BeeExtension.h"
@implementation ConvertLunarOrSolar

-(id) init{
    if (self=[super init]) {
    }
    return self;
}
/**
 * 通用阴历计算阳历
 * @param lunarDay
 * @param lunarMonth
 * @param lunarYear
 * @param lunarLeap
 * @return NSArray
 */
-(NSArray*)convertLunar2Solar:(NSInteger)lunarDay lunarMonth:(NSInteger)lunarMonth lunarYear:(NSInteger)lunarYear lunarLeap:(NSInteger)lunarLeap
{
    return [self convertLunar2SolarTZ:lunarDay lunarMonth:lunarMonth lunarYear:lunarYear lunarLeap:lunarLeap timeZone:7.00];
}

/**
 通用阳历计算阴历
 
 @param date 阳历日期
 
 @return lunarDayS,lunarMonthS,lunarYearS,lunarLeapS
 */
-(NSArray*)convertSolar2Lunar:(NSDate*)date
{

    return [self convertSolar2LunarTZ:[date day]  mm:[date month] yy:[date year] timeZone:7.00];
}


/**
 通用阳历计算阴历
 
 @param date 阳历日期
 
 @return 2014年十月十一日 HH:mm
 */
-(NSString*)convertSolar2LunarStr:(NSDate*)date
{
    NSArray *lunarArray = [self convertSolar2LunarTZ:[date day]  mm:[date month] yy:[date year] timeZone:7.00];
    NSString *strMonth_date =[NSString stringWithFormat:@"%dx0",[lunarArray[1] intValue]];
    NSString *strDay_date =[NSString stringWithFormat:@"%0.2d",[lunarArray[0] intValue]];
    NSString *month = [Date_string setMonthBaseSting:strMonth_date];
    NSString *day = [Date_string setDayBaseSting:strDay_date];
    NSString *reStr = [NSString stringWithFormat:@"%d年%@月%@ %0.2d:%0.2d",[date year],month,day,[[NSDate now] hour],[[NSDate now] minute]];
    return reStr;
}

/**
 Description
 通用阴历计算阳历
 @param dd 日
 @param mm 月
 @param yy 年
 
 @return 阳历日期
 */
-(NSArray*)convertSolar2Lunar:(int)dd mm:(int)mm yy:(int)yy
{
    return [self convertSolar2LunarTZ:dd mm:mm yy:yy timeZone:7.00];
}
/**
 *  通过阳历计算阴历需要时区
 * @param dd
 * @param mm
 * @param yy
 * @param timeZone
 * @return array of [lunarDay, lunarMonth, lunarYear, leapOrNot]
 */
-(NSArray*)convertSolar2LunarTZ:(int)dd mm:(int)mm yy:(int)yy timeZone:(double)timeZone
{
    int lunarDay, lunarMonth, lunarYear, lunarLeap;
    int dayNumber = [self jdFromDate:dd mm:mm yy:yy];
    int k = (int)((dayNumber - 2415021.076998695) / 29.530588853);
    int monthStart = [self getNewMoonDay:k+1 timeZone:timeZone];
    if (monthStart > dayNumber) {
        monthStart = [self getNewMoonDay:k timeZone:timeZone];
    }
    int a11 = [self getLunarMonth11:yy timeZone:timeZone];
    int b11 = a11;
    if (a11 >= monthStart) {
        lunarYear = yy;
        a11 = [self getLunarMonth11:yy-1 timeZone:timeZone];
    } else {
        lunarYear = yy + 1;
        b11 = [self getLunarMonth11:yy + 1 timeZone:timeZone];
    }
    lunarDay = dayNumber - monthStart + 1;
    int diff = (int)((monthStart - a11) / 29);
    lunarLeap = 0;
    lunarMonth = diff + 11;
    if (b11 - a11 > 365) {
        int leapMonthDiff = [self getLeapMonthOffset:a11 timeZone:timeZone];
        if (diff >= leapMonthDiff) {
            lunarMonth = diff + 10;
            if (diff == leapMonthDiff) {
                lunarLeap = 1;
            }
        }
    }
    if (lunarMonth > 12) {
        lunarMonth = lunarMonth - 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
        lunarYear -= 1;
    }
    NSString *lunarDayS = [NSString stringWithFormat:@"%d",lunarDay];
    NSString *lunarMonthS = [NSString stringWithFormat:@"%d",lunarMonth];
    NSString *lunarYearS = [NSString stringWithFormat:@"%d",lunarYear];
    NSString *lunarLeapS = [NSString stringWithFormat:@"%d",lunarLeap];
    NSArray * array = [[NSArray alloc] initWithObjects:lunarDayS,lunarMonthS,lunarYearS,lunarLeapS,nil];
    return array;
}



/**
 * 通用阴历计算阳历需要时区
 * @param lunarDay
 * @param lunarMonth
 * @param lunarYear
 * @param lunarLeap
 * @param timeZone
 * @return NSArray
 */
-(NSArray*)convertLunar2SolarTZ:(NSInteger)lunarDay lunarMonth:(NSInteger)lunarMonth lunarYear:(NSInteger)lunarYear lunarLeap:(NSInteger)lunarLeap timeZone:(double)timeZone
{
    NSInteger a11, b11;
    
    if (lunarMonth < 11) {
        a11 = [self getLunarMonth11:lunarYear-1 timeZone:timeZone];
        b11 = [self getLunarMonth11:lunarYear timeZone:timeZone];
    } else {
        a11 = [self getLunarMonth11:lunarYear timeZone:timeZone];
        b11 = [self getLunarMonth11:lunarYear+1 timeZone:timeZone];
    }
    
    int k = (int)(0.5 + (a11 - 2415021.076998695) / 29.530588853);
    int off = lunarMonth - 11;
    if (off < 0) {
        off += 12;
    }
    if (b11 - a11 > 365) {
        int leapOff = [self getLeapMonthOffset:a11 timeZone:timeZone];
        int leapMonth = leapOff - 2;
        if (leapMonth < 0) {
            leapMonth += 12;
        }
        if (lunarLeap != 0 && lunarMonth != leapMonth) {
            return @[@"0",@"0",@"0"];
        } else if (lunarLeap != 0 || off >= leapOff) {
            off += 1;
        }
    }
    int monthStart = [self getNewMoonDay:k + off timeZone:timeZone];
    
    return [self jdToDate:monthStart + lunarDay - 1];
}


/**
 * 获取闰月
 * @param a11
 * @param timeZone
 * @return
 */
-(int)getLeapMonthOffset:(int)a11 timeZone:(double)timeZone
{
    int k = (int)(0.5 + (a11 - 2415021.076998695) / 29.530588853);
    int last; // Month 11 contains point of sun longutide 3*PI/2 (December
    // solstice)
    int i = 1; // We start with the month following lunar month 11
    
    int arc = (int)([self getSunLongitude:[self getNewMoonDay:k+i timeZone:timeZone] timeZone:timeZone] /30);
    do {
        last = arc;
        i++;
        arc = (int)([self getSunLongitude:[self getNewMoonDay:k+i timeZone:timeZone] timeZone:timeZone] /30);
    } while (arc != last && i < 14);
    return i - 1;
}


/**
 * 获取阴历新月的天数
 * @param yy
 * @param timeZone
 * @return
 */
-(NSInteger)getLunarMonth11:(NSInteger)yy timeZone:(double)timeZone
{
    double off = [self jdFromDate:31 mm:12 yy:yy] - 2415021.076998695;
    int k = (int)(off / 29.530588853);
    int nm = [self getNewMoonDay:k timeZone:timeZone];
    int sunLong = (int)([self getSunLongitude:nm timeZone:timeZone] /30);
    if (sunLong >= 9) {
        nm = [self getNewMoonDay:k-1 timeZone:timeZone];
    }
    return nm;
}

/**
 *通过日期计算太阳经度
 * @param dd
 * @param mm
 * @param yy
 * @return the number of days since 1 January 4713 BC (Julian calendar)
 */
-(NSInteger) jdFromDate:(NSInteger)dd mm:(NSInteger)mm yy:(NSInteger)yy
{
    int a = (14 - mm) / 12;
    int y = yy + 4800 - a;
    int m = mm + 12 * a - 3;
    int jd = dd + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045;
    if (jd < 2299161) {
        jd = dd + (153 * m + 2) / 5 + 365 * y + y / 4 - 32083;
    }
    // jd = jd - 1721425;
    return jd;
}

/**
 * 获取太阳经度
 * @param dayNumber
 * @param timeZone
 * @return
 */
-(double)getSunLongitude:(int)dayNumber timeZone:(double)timeZone
{
    return [self sunLongitude:dayNumber - 0.5 - timeZone / 24];
}


/**
 * 获取太阳经度
 *
 * Solar longitude in degrees Algorithm from: Astronomical Algorithms, by
 * Jean Meeus, 1998
 *
 * @param jdn - number of days since noon UTC on 1 January 4713 BC
 * @return
 */
-(double)sunLongitude:(double)jdn
{
    return [self sunLongitudeAA98:jdn];
}

/**
 * 计算太阳经度AA98
 * @param jdn
 * @return
 */
-(double)sunLongitudeAA98:(double)jdn
{
    double T = (jdn - 2451545.0) / 36525; // 从2000-01-01 12:00:00 GMT  起算的儒略世纪数T
    double T2 = T * T;
    double dr = M_PI / 180; // degree to radian
    double M = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048
    * T * T2; // mean anomaly, degree
    double L0 = 280.46645 + 36000.76983 * T + 0.0003032 * T2; // mean
    // longitude,
    // degree
    double DL = (1.914600 - 0.004817 * T - 0.000014 * T2)
    * sin(dr * M);
    DL = DL + (0.019993 - 0.000101 * T) * sin(dr * 2 * M) + 0.000290
    * sin(dr * 3 * M);
    double L = L0 + DL; // true longitude, degree
    L = L - 360 * ((int)(L / 360)); // Normalize to (0, 360)
    return L;
}


/**
 * 获取新月
 * @param k
 * @param timeZone
 * @return
 */
-(int) getNewMoonDay:(int)k timeZone:(double)timeZone
{
    double jd = [self NewMoon:k];
    return (int)(jd + 0.5 + timeZone / 24);
}

/**
 * 新月
 * @param k
 * @return
 */
-(double)NewMoon:(int)k
{
    return [self NewMoonAA98:k];
}

/**
 * 获取新月 AA98
 *
 * Julian day number of the kth new moon after (or before) the New Moon of
 * 1900-01-01 13:51 GMT. Accuracy: 2 minutes Algorithm from: Astronomical
 * Algorithms, by Jean Meeus, 1998
 *
 * @param k
 * @return the Julian date number (number of days since noon UTC on 1
 * January 4713 BC) of the New Moon
 */
-(double)NewMoonAA98:(int)k
{
    double T = k / 1236.85; // Time in Julian centuries from 1900 January
    // 0.5
    double T2 = T * T;
    double T3 = T2 * T;
    double dr = M_PI / 180;
    double Jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * T2
    - 0.000000155 * T3;
    Jd1 = Jd1 + 0.00033
    * sin((166.56 + 132.87 * T - 0.009173 * T2) * dr); // Mean
    // new
    // moon
    double M = 359.2242 + 29.10535608 * k - 0.0000333 * T2 - 0.00000347
    * T3; // Sun's mean anomaly
    double Mpr = 306.0253 + 385.81691806 * k + 0.0107306 * T2 + 0.00001236
    * T3; // Moon's mean anomaly
    double F = 21.2964 + 390.67050646 * k - 0.0016528 * T2 - 0.00000239
    * T3; // Moon's argument of latitude
    double C1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021
    * sin(2 * dr * M);
    C1 = C1 - 0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr);
    C1 = C1 - 0.0004 * sin(dr * 3 * Mpr);
    C1 = C1 + 0.0104 * sin(dr * 2 * F) - 0.0051
    * sin(dr * (M + Mpr));
    C1 = C1 - 0.0074 * sin(dr * (M - Mpr)) + 0.0004
    * sin(dr * (2 * F + M));
    C1 = C1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006
    * sin(dr * (2 * F + Mpr));
    C1 = C1 + 0.0010 * sin(dr * (2 * F - Mpr)) + 0.0005
    * sin(dr * (2 * Mpr + M));
    double deltat;
    if (T < -11) {
        deltat = 0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3
        - 0.000000081 * T * T3;
    } else {
        deltat = -0.000278 + 0.000265 * T + 0.000262 * T2;
    }
    ;
    double JdNew = Jd1 + C1 - deltat;
    return JdNew;
    
}


/**
 *太阳经度计算日期
 * @param jd - the number of days since 1 January 4713 BC (Julian calendar)
 * @return
 */

-(NSArray*) jdToDate:(NSInteger)jd
{
    int a, b, c;
    if (jd > 2299160) { // After 5/10/1582, Gregorian calendar
        a = jd + 32044;
        b = (4 * a + 3) / 146097;
        c = a - (b * 146097) / 4;
    } else {
        b = 0;
        c = jd + 32082;
    }
    int d = (4 * c + 3) / 1461;
    int e = c - (1461 * d) / 4;
    int m = (5 * e + 2) / 153;
    int day = e - (153 * m + 2) / 5 + 1;
    int month = m + 3 - 12 * (m / 10);
    int year = b * 100 + d - 4800 + m / 10;
    NSArray *array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",day],[NSString stringWithFormat:@"%d",month],[NSString stringWithFormat:@"%d",year], nil];
    return array;
}


@end
