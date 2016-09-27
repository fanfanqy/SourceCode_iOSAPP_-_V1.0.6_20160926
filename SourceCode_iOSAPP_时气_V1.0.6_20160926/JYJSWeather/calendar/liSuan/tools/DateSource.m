//
//  DateSource.m
//  历算
//
//  Created by han on 14/12/4.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "DateSource.h"

@implementation DateSource


//返回距离现在多少天
+(NSString *)getUTCFormateDate:(NSString *)newsDate
{
    //    newsDate = @"2013-08-09 17:01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    NSString *dateContent;
    if(days!=0){
        if (days > 0) {
            dateContent = [NSString stringWithFormat:@"%d天前",days];
        }else {
            dateContent = [NSString stringWithFormat:@"%d天后",(1 - days)];
        }
    }else if(hours!=0){
        if (hours > 0) {
            dateContent = @"今天";
        }else {
            dateContent = @"1天后";
        }
    }
    return dateContent;
}

+(int)getShiChen:(int)hour
{
    if(hour< 1 || hour >=23 ){
        return 0;
    }else if(hour >=1 && hour <3){
        return 1;
    }else if(hour >=3 && hour <5){
        return 2;
    }else if(hour >=5 && hour <7){
        return 3;
    }else if(hour >=7 && hour <9){
        return 4;
    }else if(hour >=9 && hour <11){
        return 5;
    }else if(hour >=11 && hour <13){
        return 6;
    }else if(hour >=13 && hour <15){
        return 7;
    }else if(hour >=15 && hour <17){
        return 8;
    }else if(hour >=17 && hour <19){
        return 9;
    }else if(hour >=19 && hour <21){
        return 10;
    }else if(hour >=21 && hour <23){
        return 11;
    }else{
        return -1;
    }
}

+(int)getDayIndex:(NSString *)dayZhu
{
    NSString * day = [dayZhu substringToIndex:1];
    if ([day isEqualToString:@"甲"]) {
        return 0;
    }else if ([day isEqualToString:@"乙"]){
        return 1;
    }else if ([day isEqualToString:@"丙"]){
        return 2;
    }else if ([day isEqualToString:@"丁"]){
        return 3;
    }else if ([day isEqualToString:@"戊"]){
        return 4;
    }else if([day isEqualToString:@"己"]){
        return 5;
    }else if([day isEqualToString:@"庚"]){
        return 6;
    }else if([day isEqualToString:@"辛"]){
        return 7;
    }else if([day isEqualToString:@"壬"]){
        return 8;
    }else if([day isEqualToString:@"癸"]){
        return 9;
    }else{
        return -1;
    }

}

@end
