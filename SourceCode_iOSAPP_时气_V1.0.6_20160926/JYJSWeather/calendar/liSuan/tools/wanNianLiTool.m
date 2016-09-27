//
//  wanNianLiTool.m
//  LiSuanDemo
//
//  Created by han on 14/12/16.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "wanNianLiTool.h"

@implementation wanNianLiTool

+(NSString *)getOldTime:(int)index
{
    NSArray * timeArray = @[@"子时23:00-00:59",@"丑时01:00-02:59",@"寅时03:00-04:59",@"卯时05:00-06:59",@"辰时07:00-08:59",@"巳时09:00-10:59",@"午时11:00-12:59",@"未时13:00-14:59",@"申时15:00-16:59",@"酉时17:00-18:59",@"戌时19:00-20:59",@"亥时21:00-22:59"];
    return timeArray[index];
}

+(NSArray *)getShiChenJiXiong:(NSString *)key
{
    NSDictionary * shiChenJiXiong = @{
                        @"甲子":@[@1,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                        @"甲寅":@[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                        @"甲辰":@[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                        @"甲午":@[@1,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                        @"甲申":@[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                        @"甲戌":@[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                        @"乙卯":@[@1,@0,@1,@1,@0,@0,@1,@1,@0,@1,@0,@0],
                        @"乙丑":@[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                        @"乙巳":@[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1],
                        @"乙未":@[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                        @"乙酉":@[@1,@0,@1,@1,@0,@0,@1,@1,@0,@1,@0,@0],
                        @"乙亥":@[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1],
                        @"丙子":@[@1,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                        @"丙寅":@[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                        @"丙辰":@[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                        @"丙午":@[@1,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                        @"丙申":@[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                        @"丙戌":@[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                        @"丁丑":@[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                        @"丁卯":@[@1,@0,@1,@1,@0,@0,@1,@1,@0,@1,@0,@0],
                        @"丁巳":@[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1],
                        @"丁未":@[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                        @"丁酉":@[@1,@0,@1,@1,@0,@0,@1,@1,@0,@1,@0,@0],
                        @"丁亥":@[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1],
                        @"戊子":@[@1,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                        @"戊寅":@[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                        @"戊辰":@[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                        @"戊午":@[@1,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                        @"戊申":@[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                        @"戊戌":@[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                        @"己丑":@[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                        @"己卯":@[@1,@0,@1,@1,@0,@0,@1,@1,@0,@1,@0,@0],
                        @"己巳":@[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1],
                        @"己未":@[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                        @"己酉":@[@1,@0,@1,@1,@0,@0,@1,@1,@0,@1,@0,@0],
                        @"己亥":@[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1],
                        @"庚子":@[@1,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                        @"庚寅":@[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                        @"庚辰":@[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                        @"庚午":@[@1,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                        @"庚申":@[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                        @"庚戌":@[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                        @"辛丑":@[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                        @"辛卯":@[@1,@0,@1,@1,@0,@0,@1,@1,@0,@1,@0,@0],
                        @"辛巳":@[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1],
                        @"辛未":@[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                        @"辛酉":@[@1,@0,@1,@1,@0,@0,@1,@1,@0,@1,@0,@0],
                        @"辛亥":@[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1],
                        @"壬子":@[@1,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                        @"壬寅":@[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                        @"壬辰":@[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                        @"壬午":@[@1,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                        @"壬申":@[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                        @"壬戌":@[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                        @"癸丑":@[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                        @"癸卯":@[@1,@0,@1,@1,@0,@0,@1,@1,@0,@1,@0,@0],
                        @"癸巳":@[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1],
                        @"癸未":@[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                        @"癸酉":@[@1,@0,@1,@1,@0,@0,@1,@1,@0,@1,@0,@0],
                        @"癸亥":@[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1]};
    return [shiChenJiXiong objectForKey:key];
}

+(NSString *)getTimeFromArrayIndex:(int)indexOut andIndex:(int)indexIn
{
    NSArray * tianGanDiZhi = @[
                      @[@"甲子时",@"丙子时",@"戊子时",@"庚子时",@"壬子时",@"甲子时",@"丙子时",@"戊子时",@"庚子时",@"壬子时"],
                      @[@"乙丑时",@"丁丑时",@"己丑时",@"辛丑时",@"癸丑时",@"乙丑时",@"丁丑时",@"己丑时",@"辛丑时",@"癸丑时"],
                      @[@"丙寅时",@"戊寅时",@"庚寅时",@"壬寅时",@"甲寅时",@"丙寅时",@"戊寅时",@"庚寅时",@"壬寅时",@"甲寅时"],
                      @[@"丁卯时",@"己卯时",@"辛卯时",@"癸卯时",@"乙卯时",@"丁卯时",@"己卯时",@"辛卯时",@"癸卯时",@"乙卯时"],
                      @[@"戊辰时",@"庚辰时",@"壬辰时",@"甲辰时",@"丙辰时",@"戊辰时",@"庚辰时",@"壬辰时",@"甲辰时",@"丙辰时"],
                      @[@"己巳时",@"辛巳时",@"癸巳时",@"乙巳时",@"丁巳时",@"己巳时",@"辛巳时",@"癸巳时",@"乙巳时",@"丁巳时"],
                      @[@"庚午时",@"壬午时",@"甲午时",@"丙午时",@"戊午时",@"庚午时",@"壬午时",@"甲午时",@"丙午时",@"戊午时"],
                      @[@"辛未时",@"癸未时",@"乙未时",@"丁未时",@"己未时",@"辛未时",@"癸未时",@"乙未时",@"丁未时",@"己未时"],
                      @[@"壬申时",@"甲申时",@"丙申时",@"戊申时",@"庚申时",@"壬申时",@"甲申时",@"丙申时",@"戊申时",@"庚申时"],
                      @[@"癸酉时",@"乙酉时",@"丁酉时",@"己酉时",@"辛酉时",@"癸酉时",@"乙酉时",@"丁酉时",@"己酉时",@"辛酉时"],
                      @[@"甲戌时",@"丙戌时",@"戊戌时",@"庚戌时",@"壬戌时",@"甲戌时",@"丙戌时",@"戊戌时",@"庚戌时",@"壬戌时"],
                      @[@"乙亥时",@"丁亥时",@"己亥时",@"辛亥时",@"癸亥时",@"乙亥时",@"丁亥时",@"己亥时",@"辛亥时",@"癸亥时"]];
    return tianGanDiZhi[indexOut][indexIn];
}

/*
 根据当前的时间算出古代的时辰
 */
+(NSString *)getOldHour{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * string = [formatter stringFromDate:[NSDate date]];
    NSString * time = [[string componentsSeparatedByString:@" "] objectAtIndex:1];
    int  hour = [[[time componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
    NSString * OldHour;
    if(hour == 23 || hour == 0 ){
        OldHour = @"子";
    }else if(hour == 1 || hour == 2 ){
        OldHour = @"丑";
    }else if(hour == 3 || hour == 4 ){
        OldHour = @"寅";
    }else if(hour == 5 || hour == 6 ){
        OldHour = @"卯";
    }else if(hour == 7 || hour == 8 ){
        OldHour = @"辰";
    }else if(hour == 9 || hour == 10 ){
        OldHour = @"巳";
    }else if(hour == 11 || hour == 12 ){
        OldHour = @"午";
    }else if(hour == 13 || hour == 14 ){
        OldHour = @"未";
    }else if(hour == 15 || hour == 16 ){
        OldHour = @"申";
    }else if(hour == 17 || hour == 18 ){
        OldHour = @"酉";
    }else if(hour == 19 || hour == 20 ){
        OldHour = @"戌";
    }else if(hour == 21 || hour == 22 ){
        OldHour = @"亥";
    }
    return OldHour;
}

+(NSString *)getXiTouJiXiong:(NSString *)key
{
    NSDictionary * xiTouJianZhiJia = @{@"初一":@"凶",
                                       @"初二":@"凶",
                                       @"初三":@"吉",
                                       @"初四":@"吉",
                                       @"初五":@"吉",
                                       @"初六":@"吉",
                                       @"初七":@"凶",
                                       @"初八":@"吉",
                                       @"初九":@"凶",
                                       @"初十":@"吉",
                                       @"十一":@"吉",
                                       @"十二":@"凶",
                                       @"十三":@"吉",
                                       @"十四":@"吉",
                                       @"十五":@"吉",
                                       @"十六":@"吉",
                                       @"十七":@"凶",
                                       @"十八":@"吉",
                                       @"十九":@"吉",
                                       @"二十":@"凶",
                                       @"二十一":@"凶",
                                       @"二十二":@"吉",
                                       @"二十三":@"吉",
                                       @"二十四":@"凶",
                                       @"二十五":@"凶",
                                       @"二十六":@"吉",
                                       @"二十七":@"吉",
                                       @"二十八":@"凶",
                                       @"二十九":@"凶",
                                       @"三十":@"凶"};
    return [xiTouJianZhiJia objectForKey:key];
    
}

@end
