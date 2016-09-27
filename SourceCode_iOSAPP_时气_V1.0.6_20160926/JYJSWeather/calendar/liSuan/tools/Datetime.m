//
//  Datetime.m
//  CalendarTest
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 caobo. All rights reserved.
//

#import "Datetime.h"
#import "LunarCalendar.h"
#import "JBCalendar.h"
#import "calendarDBModel.h"
#import "WanNianLiDate.h"
@implementation Datetime
//所有年列表
+(NSArray *)GetAllYearArray{
    NSMutableArray * monthArray = [[NSMutableArray alloc]init];
    for (int i = 1901; i<2050; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [monthArray addObject:days];
    }
    return monthArray;
}
//获取农历节日
+(NSString *)GetLunarFestival:(int)year andMonth:(int)month andDay:(int)day{

    NSString *festivalStr = @" ";
    switch (month) {
            //                    正月初一日 弥勒菩萨圣诞、春节
            //                    正月初五 接财神日、五路财神日
            //                    正月初六日 定光佛圣诞
            //                    正月初九日 昊天皇帝诞
            //                    正月十五 元宵节
            //                    正月十六 门神诞
            //                    正月十九 丘处机诞
        case 1:
        {
            switch (day) {
                case 1:
                    festivalStr  = @"春节\n弥勒菩萨圣诞";
                    break;
                case 5:
                    festivalStr  = @"接财神日\n五路财神日";
                    break;
                case 6:
                    festivalStr  = @"定光佛圣诞";
                    break;
                case 9:
                    festivalStr  = @"昊天皇帝诞";
                    break;
                case 15:
                    festivalStr  = @"元宵节";
                    break;
                case 16:
                    festivalStr  = @"门神诞";
                    break;
                case 19:
                    festivalStr  = @"丘处机诞";
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
            //                    二月初二 龙抬头、伏羲祭
            //                    二月初三 文昌诞
            //                    二月初八日 释迦牟尼佛出家
            //                    二月初九 惠能大师圣诞
            //                    二月十五日 释迦牟尼佛涅槃日、九天玄女诞、老子诞
            //                    二月十九日 观世音菩萨圣诞
            //                    二月廿一日 普贤菩萨圣诞
        {
            switch (day) {
                case 2:
                    festivalStr  = @"龙抬头\n伏羲祭";
                    break;
                case 3:
                    festivalStr  = @"文昌诞";
                    break;
                case 8:
                    festivalStr  = @"释迦牟尼佛出家日";
                    break;
                case 9:
                    festivalStr  = @"惠能大师圣诞";
                    break;
                case 15:
                    festivalStr  = @"老子诞\n释迦牟尼佛涅槃日\n九天玄女诞";
                    break;
                case 19:
                    festivalStr  = @"观世音菩萨圣诞";
                    break;
                case 21:
                    festivalStr  = @"普贤菩萨圣诞";
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            //                    三月初五日 大禹诞
            //                    三月十六日 准提菩萨圣诞、蒙括诞
            //                    三月二十 鲁班诞
            //                    三月二十八 仓颉诞

            switch (day) {
                case 5:
                    festivalStr  = @"大禹诞";
                    break;
                case 16:
                    festivalStr  = @"蒙括诞\n准提菩萨圣诞";
                    break;
                case 20:
                    festivalStr  = @"鲁班诞";
                    break;
                case 28:
                    festivalStr  = @"仓颉诞";
                    break;
                default:
                    break;
            }

        }
            break;
        case 4:
        {
            //                    四月初四日 文殊菩萨圣诞
            //                    四月初八日 释迦牟尼佛圣诞、浴佛放生节
            //                    四月初十 葛洪诞
            //                    四月十一 孔子祭
            //                    四月十四 吕洞宾诞
            //                    四月十五日 钟离权诞
            //                    四月二十六 神农诞
            //                    四月廿八日 药王菩萨圣诞
            switch (day) {
                case 4:
                    festivalStr  = @"文殊菩萨圣诞";
                    break;
                case 8:
                    festivalStr  = @"浴佛放生节\n释迦牟尼佛圣诞";
                    break;
                case 10:
                    festivalStr  = @"葛洪诞";
                    break;
                case 11:
                    festivalStr  = @"孔子祭";
                    break;
                case 14:
                    festivalStr  = @"吕洞宾诞";
                    break;
                case 15:
                    festivalStr  = @"钟离权诞";
                    break;
                case 26:
                    festivalStr  = @"神农诞";
                    break;
                case 28:
                    festivalStr  = @"药王菩萨圣诞";
                    break;
                default:
                    break;
            }

        }
            break;
        case 5:
        {
            //                    五月初五 端午节
            //                    五月十一 范蠡祭
            //                    五月十三日 伽蓝菩萨圣诞
            switch (day) {
                case 5:
                    festivalStr  = @"端午节";
                    break;
                case 11:
                    festivalStr  = @"范蠡祭";
                    break;
                case 13:
                    festivalStr  = @"伽蓝菩萨圣诞";
                    break;
                default:
                    break;
            }

        }
            break;
        case 6:
        {
            //                    六月初三日 韦驮菩萨圣诞
            //                    六月十九日 观世音菩萨成道
            //                    六月二十三日 火神诞
            switch (day) {
                case 3:
                    festivalStr  = @"韦驮菩萨圣诞";
                    break;
                case 19:
                    festivalStr  = @"观世音菩萨成道日";
                    break;
                case 23:
                    festivalStr  = @"火神诞";
                    break;
                default:
                    break;
            }

        }
            break;
        case 7:
        {
            JBCalendar* date = [[JBCalendar alloc]init];
            date.year = year,date.month = month,date.day = 1;

            LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
            int lmonthCountDay = [lunarCalendar MonthDays:year :month];
            if (lmonthCountDay == 29 && day==29) {
                day = 30;
            }
            //                    七月初七 七夕情人节
            //                    七月十三日 大势至菩萨圣诞、轩辕诞
            //                    七月十五日 佛欢喜日、盂兰盆会、中元节
            //                    七月廿一日 普庵祖师圣诞
            //                    七月廿四日 龙树菩萨圣诞
            //                    七月三十日 地藏王菩萨圣诞（农历七月缺三十日就默认为二十九日）
            switch (day) {
                case 7:
                    festivalStr  = @"七夕情人节";
                    break;
                case 13:
                    festivalStr  = @"轩辕诞\n大势至菩萨圣诞";
                    break;
                case 15:
                    festivalStr  = @"中元节\n佛欢喜日\n盂兰盆会";
                    break;
                case 21:
                    festivalStr  = @"普庵祖师圣诞";
                    break;
                case 24:
                    festivalStr  = @"龙树菩萨圣诞";
                    break;
                case 30:
                    festivalStr  = @"地藏王菩萨圣诞";
                    break;
                default:
                    break;
            }

        }
            break;
        case 8:
        {
//            八月初三 华佗诞
//            八月初四 财宝天王圣诞
//            八月十五日 月光菩萨圣诞、中秋节
//            八月廿二日 燃灯古佛圣诞
//            八月二十四日 孔子诞
            switch (day) {
                case 3:
                    festivalStr  = @"华佗诞";
                    break;
                case 4:
                    festivalStr  = @"财宝天王圣诞";
                    break;
                case 15:
                    festivalStr  = @"中秋节\n月光菩萨圣诞";
                    break;
                case 22:
                    festivalStr  = @"燃灯古佛圣诞";
                    break;
                case 24:
                    festivalStr  = @"孔子诞";
                    break;
                default:
                    break;
            }

        }
            break;
        case 9:
        {
//            九月初九 摩利支天菩萨圣诞 、重阳节
//            九月十九日 观世音菩萨出家
//            九月三十日 药师琉璃光佛圣诞
            JBCalendar* date = [[JBCalendar alloc]init];
            date.year = year,date.month = month,date.day = 1;
            LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
            int lmonthCountDay = [lunarCalendar MonthDays:year :month];
            if (lmonthCountDay == 29 && day == 29) {
                day = 30;
            }

            switch (day) {
                case 9:
                    festivalStr  = @"重阳节\n摩利支天菩萨圣诞";
                    break;
                case 19:
                    festivalStr  = @"观世音菩萨出家日";
                    break;
                case 30:
                    festivalStr  = @"药师琉璃光佛圣诞";
                    break;
                default:
                    break;
            }

        }
            break;
        case 10:
        {
//            十月初一日 祭祖节、送寒衣节
//            十月初五日 达摩祖师圣诞
            switch (day) {
                case 1:
                    festivalStr  = @"祭祖节\n送寒衣节";
                    break;
                case 5:
                    festivalStr  = @"达摩祖师圣诞";
                    break;
                default:
                    break;
            }

        }
            break;
        case 11:
        {
//            十一月十七日 阿弥陀佛圣诞
//            十一月十九日 日光菩萨圣诞
            switch (day) {
                case 17:
                    festivalStr  = @"阿弥陀佛圣诞";
                    break;
                case 19:
                    festivalStr  = @"日光菩萨圣诞";
                    break;
                default:
                    break;
            }

        }
            break;
        case 12:
        {
//            十二月初八日 释迦牟尼佛成道、腊八节
//            十二月二十四日 谢太岁、小年、洗灶日
//            十二月二十八日 化太岁
//            十二月廿九日 华严菩萨圣诞
//            十二月三十日 除夕（没有三十的，默认为二十九）
            JBCalendar* date = [[JBCalendar alloc]init];
            date.year = year,date.month = month,date.day = 1;
            LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
            int lmonthCountDay = [lunarCalendar MonthDays:year :month];
            if (lmonthCountDay == 29 && day == 29) {
                festivalStr  = @"除夕\n华严菩萨圣诞";
                return festivalStr;
            }
            switch (day) {
                case 8:
                    festivalStr  = @"腊八节\n释迦牟尼佛成道日";
                    break;
                case 24:
                    festivalStr  = @"谢太岁\n小年\n洗灶日";
                    break;
                case 28:
                    festivalStr  = @"化太岁";
                    break;
                case 29:
                    festivalStr  = @"华严菩萨圣诞";
                    break;
                case 30:
                    festivalStr  = @"除夕";
                    break;
                default:
                    break;
            }


        }
            break;
        default:
            break;
    }
    return festivalStr;
}
//所有月列表
+(NSArray *)GetAllMonthArray{
    NSMutableArray * monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<13; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [monthArray addObject:days];
    }
    return monthArray;
}

//以YYYY.MM.dd格式输出年月日
+(NSString*)getDateTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

//以YYYY年MM月dd日格式输出年月日
+(NSString*)GetDateTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
     NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

//以YYYY年MMdd格式输出此时的农历年月日
+(NSString*)GetLunarDateTime{
    JBCalendar* date = [[JBCalendar alloc]init];
    date.year = [[self GetYear] intValue],date.month =[[self GetMonth] intValue],date.day = [[self GetDay] intValue];
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    NSString * lunar = [[NSString alloc]initWithFormat:
                           @"%@%@年%@%@",lunarCalendar.YearHeavenlyStem,lunarCalendar.YearEarthlyBranch,lunarCalendar.MonthLunar,lunarCalendar.DayLunar];
    return lunar;
}

//获取指定年份指定月份的星期排列表
+(NSMutableArray *)GetDayArrayByYear:(int) year andMonth:(int) month{
    NSMutableArray * dayArray1 = [[NSMutableArray alloc]init];
    for (int i = 0; i< 42; i++) {
        NSString * days;
        int yearTemp = 0;
        int monthTemp = 0;

        if (i <= [self GetTheWeekOfDayByYera:year andByMonth:month]-1) {
            yearTemp = year;
//            monthTemp = month;
            if (month==1) {
                yearTemp--;
                monthTemp=12;
                //跨年
                days = [NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]-([self GetTheWeekOfDayByYera:year andByMonth:month]-i)+1];
            }else{
                yearTemp = year;
                monthTemp = month-1;
             days = [NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]-([self GetTheWeekOfDayByYera:year andByMonth:month]-i)+1];
            }
            [dayArray1 addObject:days];
        }else if ((i>[self GetTheWeekOfDayByYera:year andByMonth:month]-1)&&(i<[self GetTheWeekOfDayByYera:year andByMonth:month]+[self GetNumberOfDayByYera:year andByMonth:month])){
            yearTemp = year;
            monthTemp = month;
                days = [NSString stringWithFormat:@"%d",i-[self GetTheWeekOfDayByYera:yearTemp andByMonth:monthTemp]+1];
                [dayArray1 addObject:days];
        }else {
            //这里是根据 i 和"上个月"算的
            yearTemp = year;
            monthTemp = month;
            days = [NSString stringWithFormat:@"%d",i-[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]-[self GetTheWeekOfDayByYera:yearTemp andByMonth:monthTemp]+1];
            [dayArray1 addObject:days];
        }
    }
    return dayArray1;
}

//获取指定年份指定月份指定日子的一周排列,数组中只有day 
+(NSMutableArray *)GetDayArrayByYear:(int) year andMonth:(int) month andDay:(int) day{
    NSMutableArray * dayArray2 = [[NSMutableArray alloc]init];
    //某一天是周几
    int index1 = [self GetTheWeekOfDayByYera:year andByMonth:month andByDay:day];//6
    //月首日是周几
    int index = [self GetTheWeekOfDayByYera:year andByMonth:month];//0
    int yearTemp = 0;
    int monthTemp = 0;
    int  dayTemp = 0;
    for (int i = 0; i< 7; i++) {
        yearTemp = year;
        monthTemp = month;
        dayTemp = day;
        if (i<index1) {
            if ((dayTemp - index1+i)>0) {//大于1号
                [dayArray2 addObject:[NSString stringWithFormat:@"%d",dayTemp-index1+i]];
            }else{
                if (monthTemp==1) {
                    yearTemp--;
                    monthTemp=12;
                    [dayArray2 addObject:[NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]-(index-i)+1]];
                }else{
                [dayArray2 addObject:[NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp-1]-(index-i)+1]];
                }
            }
        }else {
            if (dayTemp+(i-index1)<=[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]) {
                [dayArray2 addObject:[NSString stringWithFormat:@"%d",dayTemp+i-index1]];
            }else{
                int index2 = 0;
                if (monthTemp==12) {
                    yearTemp++;
                    index2 = [self GetTheWeekOfDayByYera: yearTemp andByMonth:1];
                }else{
                    index2 = [self GetTheWeekOfDayByYera:yearTemp andByMonth:(monthTemp+1)];
                }
                [dayArray2 addObject:[NSString stringWithFormat:@"%d",i-index2+1]];
            }
        }
    }
    return dayArray2;
}

+(NSMutableArray *)GetDayDicByYear:(int) year andMonth:(int) month andDay:(int) day andCountsDay:(int)countsDay;
{
     NSMutableArray * dayArrayDay = [[NSMutableArray alloc]init];
     NSMutableArray * dayArrayMonth = [[NSMutableArray alloc]init];
     NSMutableArray * dayArrayYear = [[NSMutableArray alloc]init];
     NSMutableArray * dayArray4 = [[NSMutableArray alloc]init];
    int  monthTemp = 0 ;
    int  yearTemp = 0;
    int  dayTemp = 0;
    //某一天是周几
    int index1 = [self GetTheWeekOfDayByYera:year andByMonth:month andByDay:day];
    //月首日是周几
    int index = [self GetTheWeekOfDayByYera:year andByMonth:month];
    for (int i = 0; i< countsDay; i++) {
        monthTemp = month;
        yearTemp = year;
        dayTemp = day;
        if (i<index1) {
            if ((dayTemp - index1+i)>0) {//大于1号
                [dayArrayDay addObject:[NSString stringWithFormat:@"%d",dayTemp-index1+i]];
                [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp]];
                [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
            }else{
                if (monthTemp==1) {
                    yearTemp--;
                    monthTemp=12;
                    [dayArrayDay addObject:[NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]-(index-i)+1]];
                    [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp]];
                    [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
                }else{
                    [dayArrayDay addObject:[NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:year andByMonth:(monthTemp-1)]-(index-i)+1]];
                    [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp-1]];
                    [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
                }
            }
        }else {

            if (dayTemp+(i-index1)<=[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]) {
                [dayArrayDay addObject:[NSString stringWithFormat:@"%d",dayTemp+i-index1]];
                [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp]];
                [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
            }else{
                int index2 = 0;
                if (monthTemp==12) {
                    yearTemp++;
                    index2 = [self GetTheWeekOfDayByYera:yearTemp andByMonth:1];
                    [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",1]];
                }else{
                    index2 = [self GetTheWeekOfDayByYera:yearTemp andByMonth:(monthTemp+1)];
                    [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp+1]];
                }
                [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i-index2+1]];
                [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
            }
        }
    }

    [dayArray4 addObject:dayArrayYear];
    [dayArray4 addObject:dayArrayMonth];
    [dayArray4 addObject:dayArrayDay];
    return dayArray4;
}


//获取指定年份指定月份的星期排列表(农历)
+(NSMutableArray *)GetLunarDayArrayByYear:(int) year andMonth:(int) month{
    NSMutableArray * dayArray5 = [[NSMutableArray alloc]init];
    int  monthTemp = 0 ;
    int  yearTemp = 0;
//    int  dayTemp = 0;

    for (int i = 0; i< 42; i++) {
        NSString * days;
        monthTemp = month;
        yearTemp = year;
        if (i <= [self GetTheWeekOfDayByYera:year andByMonth:month]-1) {
            if (monthTemp==1) {
                yearTemp--;
                monthTemp=12;
                days = [self GetLunarDayByYear:yearTemp andMonth:monthTemp andDay:([self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]-([self GetTheWeekOfDayByYera:yearTemp andByMonth:monthTemp]-i)+1)];
            }else{
                days = [self GetLunarDayByYear:yearTemp andMonth:(monthTemp-1) andDay:([self GetNumberOfDayByYera:yearTemp andByMonth:(monthTemp-1)]-([self GetTheWeekOfDayByYera:yearTemp andByMonth:monthTemp]-i)+1)];
            }
            [dayArray5 addObject:days];
        }else if ((i>[self GetTheWeekOfDayByYera:yearTemp andByMonth:monthTemp]-1)&&(i<[self GetTheWeekOfDayByYera:yearTemp andByMonth:monthTemp]+[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp])){
            days = [self GetLunarDayByYear:yearTemp andMonth:monthTemp andDay:(i-[self GetTheWeekOfDayByYera:yearTemp andByMonth:monthTemp]+1)];
            [dayArray5 addObject:days];
        }else {
            if (monthTemp==12) {
                yearTemp++;
                monthTemp=1;
                days = [self GetLunarDayByYear:yearTemp andMonth:monthTemp andDay:(i-[self GetNumberOfDayByYera:year andByMonth:month]-[self GetTheWeekOfDayByYera:year andByMonth:month]+1)];
            }else{
                days = [self GetLunarDayByYear:yearTemp andMonth:(monthTemp+1) andDay:(i-[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]-[self GetTheWeekOfDayByYera:yearTemp andByMonth:monthTemp]+1)];
            }
            [dayArray5 addObject:days];
        }
    }
    return dayArray5;
}


//根据传入某一天日期,获取这天前后共计一周的日子排列(农历)
+(NSMutableArray *)GetLunarDayArrayByYear:(int) year
                          andMonth:(int) month andDay:(int)day{
    NSMutableArray * dayArray4 = [NSMutableArray array];
    //某一天是周几
    int index1 = [self GetTheWeekOfDayByYera:year andByMonth:month andByDay:day];
    //月首日是周几
    int index = [self GetTheWeekOfDayByYera:year andByMonth:month];
    int  monthTemp = 0 ;
    int  yearTemp = 0;
    int  dayTemp = 0;

    for (int i = 0; i< 7; i++) {
        monthTemp = month;
        yearTemp = year;
        dayTemp = day;
        if (i<index1) {
            if ((dayTemp - index1+i)>0) {//大于1号
                [dayArray4 addObject:[self GetLunarDayByYear:yearTemp andMonth:monthTemp andDay:dayTemp-index1+i]];
            }else{
                if (monthTemp==1) {
                    yearTemp--;
                    monthTemp=12;
                [dayArray4 addObject:[self GetLunarDayByYear:yearTemp andMonth:monthTemp andDay:([self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]-(index-i)+1)]];
                }else{

                    int day1 = [self GetNumberOfDayByYera:yearTemp andByMonth:(monthTemp-1)]-(index-i)+1;
                     [dayArray4 addObject:[self GetLunarDayByYear:yearTemp andMonth:(monthTemp-1) andDay:day1]];

                }
            }
        }else {
            if (dayTemp-(i-index1)<=[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]) {
                 [dayArray4 addObject:[self GetLunarDayByYear:yearTemp andMonth:monthTemp andDay:dayTemp+i-index1]];
            }else{

                int index2 = 0;
                if (monthTemp==12) {
                    yearTemp++;
                    index2 = [self GetTheWeekOfDayByYera:yearTemp andByMonth:1];
                }else{
                    index2 = [self GetTheWeekOfDayByYera:yearTemp andByMonth:(monthTemp+1)];
                }
                [dayArray4 addObject:[self GetLunarDayByYear:yearTemp andMonth:monthTemp andDay:i-index2+1]];

            }
        }
    }
//     NSLog(@"dayArray4:%@",dayArray4);
    return dayArray4;
}
//获取指定年份指定月份的相邻2个月总共3个月的排列表
+(NSMutableArray *)GetThreeMonthArrayByYear:(int) year
                                   andMonth:(int) month{
    NSMutableArray * dayArray3 = [[NSMutableArray alloc]init];
    int yearTemp = year;
    int monthTemp = month;
    int yearTemp1 = year;
    int monthTemp1 = month;
    if (monthTemp==1) {
        yearTemp--;monthTemp=12;
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]; i++) {
            [dayArray3 addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }else {
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp  andByMonth:(monthTemp-1)]; i++) {
            [dayArray3 addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }

    for (int i=0; i<[self GetNumberOfDayByYera:year andByMonth:month]; i++) {
        [dayArray3 addObject:[NSString stringWithFormat:@"%d",i+1]];
    }

    if (monthTemp1==12) {
        yearTemp1++;monthTemp1=1;
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp1 andByMonth:monthTemp1]; i++) {
            [dayArray3 addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }else{
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp1 andByMonth:monthTemp1+1]; i++) {
            [dayArray3 addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    return dayArray3;
    
}

+(NSMutableArray *)GetThreeMonthDicByYear:(int) year
                                   andMonth:(int) month{
    NSMutableArray * dayArray3 = [[NSMutableArray alloc]init];
    NSMutableArray * dayArrayYear = [[NSMutableArray alloc]init];
    NSMutableArray * dayArrayMonth = [[NSMutableArray alloc]init];
    NSMutableArray * dayArrayDay = [[NSMutableArray alloc]init];
    int yearTemp = year;
    int monthTemp = month;
    int yearTemp1 = year;
    int monthTemp1 = month;
    if (monthTemp==1) {
        yearTemp--;monthTemp=12;
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]; i++) {
            [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
             [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp]];
            [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i+1]];

        }
    }else {
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp  andByMonth:(monthTemp-1)]; i++) {
            [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
            [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp-1]];
            [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }

    for (int i=0; i<[self GetNumberOfDayByYera:year andByMonth:month]; i++) {
        [dayArrayYear addObject:[NSString stringWithFormat:@"%d",year]];
        [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",month]];
        [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i+1]];
    }

    if (monthTemp1==12) {
        yearTemp1++;monthTemp1=1;
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp1 andByMonth:monthTemp1]; i++) {
            [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
            [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp]];
            [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }else{
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp1 andByMonth:monthTemp1+1]; i++) {
            [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
            [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp+1]];
            [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    [dayArray3 addObject:dayArrayYear];
    [dayArray3 addObject:dayArrayMonth];
    [dayArray3 addObject:dayArrayDay];
    return dayArray3;
    
}

//获取某年某月某日的对应农历日
+(NSString *)GetLunarDayByYear:(int) year
                      andMonth:(int) month
                        andDay:(int) day{
    JBCalendar* date = [[JBCalendar alloc]init];
    date.year = year,date.month = month,date.day = day;
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    NSString * lunarday = [[NSString alloc]initWithString:lunarCalendar.DayLunar];
//    NSLog(@"lunarday:%@",lunarday);
    return lunarday;
}

//具体某一天是周几
+(int)GetTheWeekOfDayByYera:(int)year andByMonth:(int)month andByDay:(int)day{
    int dayTemp = (day-1)%7+[self GetTheWeekOfDayByYera:year andByMonth:month];
    while (dayTemp>=7) {
        dayTemp = dayTemp%7;
    }
    return dayTemp;
}

//计算year年month月第一天是星期几，周日则为0
+(int)GetTheWeekOfDayByYera:(int)year
                 andByMonth:(int)month{
    int numWeek = ((year-1)+ (year-1)/4-(year-1)/100+(year-1)/400+1)%7;//numWeek为years年的第一天是星期几,周6为6,周日为0

    int numdays;
    
    if ((year%4==0&&year%100!=0)||(year%400==0)) {
        
        int br[12] = {0,31,60,91,121,152,182,213,244,274,305,335};
        
        numdays = (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))?(br[month-1]+1):(br[month-1]);//numdays为month月years年的第一天是这一年的第几天
        
    }else{
        
        int ar[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
        
        numdays = (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))?(ar[month-1]+1):(ar[month-1]);//numdays为month月years年的第一天是这一年的第几天
    }
    int dayweek = (numdays%7 + numWeek)%7;//month月第一天是星期几，周日则为0
    return dayweek;
}

//判断year年month月有多少天
+(int)GetNumberOfDayByYera:(int)year
                andByMonth:(int)month{
    int nummonth = 0;
    //判断month月有多少天
    if ((month == 1)|| (month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12)){
        
        nummonth = 31;
        
    }else if ((month == 4)|| (month == 6)||(month == 9)||(month == 11)){
        
        nummonth = 30;
        
    }else if ((year%4==0&&year%100!=0)||(year%400==0)){
        
        nummonth = 29;
        
    }else{
        
        nummonth = 28;
    }
    return nummonth;
}

//未来或者过去多少天的日期汇总(这个函数小于等于28是可以计算的,如果是大于28,需要这个月前后2个月,总共5个月,依此类推),数组中是 年-月-日,组成的日期
+(NSMutableArray<NSString *>*)GetTenDaysInFutureByYear:(int)year andByMonth:(int)month andByDay:(int)day andCount:(int)countday{
     NSMutableArray *array = [Datetime GetThreeMonthDicByYear:year andMonth:month];
     NSMutableArray *arrayTemp  = [NSMutableArray array];

    int count = 0;
    for (int i=(int)[array[2] count]-1; i>=0; i--) {
        if ([array[2][i] intValue]== day) {
            count++;
        }
    }

    if (count == 1) {
        for (int i=(int)[array[2] count]-1; i>=0; i--) {
            if ([array[2][i] intValue]== day) {
                if (countday>0) {
                    for (int j=i; j<i+countday; j++) {
                        int year1 = [array[0][j] intValue];
                        int month1 = [array[1][j] intValue];
                        int day1 = [array[2][j] intValue];
                        NSString *monthStr = nil;
                        NSString *dayStr = nil;
                        NSString *dateStr = nil;
                        if (month1 < 10) {
                            monthStr = [NSString stringWithFormat:@"0%d",month1];
                        }else{
                            monthStr = [NSString stringWithFormat:@"%d",month1];
                        }
                        if (day1<10) {
                            dayStr = [NSString stringWithFormat:@"0%d",day1];
                        }else{
                            dayStr = [NSString stringWithFormat:@"%d",day1];
                        }
                        dateStr = [NSString stringWithFormat:@"%d%@%@",year1,monthStr,dayStr];
                        [arrayTemp addObject:dateStr];
                    }
                }
                else{
                    for (int j=i; j>i+countday; j--) {
                        int year1 = [array[0][j] intValue];
                        int month1 = [array[1][j] intValue];
                        int day1 = [array[2][j] intValue];
                        NSString *monthStr = nil;
                        NSString *dayStr = nil;
                        NSString *dateStr = nil;
                        if (month1 < 10) {
                            monthStr = [NSString stringWithFormat:@"0%d",month1];
                        }else{
                            monthStr = [NSString stringWithFormat:@"%d",month1];
                        }
                        if (day1<10) {
                            dayStr = [NSString stringWithFormat:@"0%d",day1];
                        }else{
                            dayStr = [NSString stringWithFormat:@"%d",day1];
                        }
                        dateStr = [NSString stringWithFormat:@"%d%@%@",year1,monthStr,dayStr];
                        [arrayTemp addObject:dateStr];
                    }

                }

            }
        }

    }else if (count == 2 || count == 3) {
    int countTemp = 0;
     for (int i=(int)[array[2] count]-1; i>=0; i--) {
        if ([array[2][i] intValue]== day) {
            if (countTemp == 1) {
                if (countday>0) {
                    for (int j=i; j<i+countday; j++) {
                        int year1 = [array[0][j] intValue];
                        int month1 = [array[1][j] intValue];
                        int day1 = [array[2][j] intValue];
                        NSString *monthStr = nil;
                        NSString *dayStr = nil;
                        NSString *dateStr = nil;
                        if (month1 < 10) {
                            monthStr = [NSString stringWithFormat:@"0%d",month1];
                        }else{
                            monthStr = [NSString stringWithFormat:@"%d",month1];
                        }
                        if (day1<10) {
                            dayStr = [NSString stringWithFormat:@"0%d",day1];
                        }else{
                            dayStr = [NSString stringWithFormat:@"%d",day1];
                        }
                        dateStr = [NSString stringWithFormat:@"%d%@%@",year1,monthStr,dayStr];
                        [arrayTemp addObject:dateStr];
                    }

                }else{
                    for (int j=i; j>i+countday; j--) {
                        int year1 = [array[0][j] intValue];
                        int month1 = [array[1][j] intValue];
                        int day1 = [array[2][j] intValue];
                        NSString *monthStr = nil;
                        NSString *dayStr = nil;
                        NSString *dateStr = nil;
                        if (month1 < 10) {
                            monthStr = [NSString stringWithFormat:@"0%d",month1];
                        }else{
                            monthStr = [NSString stringWithFormat:@"%d",month1];
                        }
                        if (day1<10) {
                            dayStr = [NSString stringWithFormat:@"0%d",day1];
                        }else{
                            dayStr = [NSString stringWithFormat:@"%d",day1];
                        }
                        dateStr = [NSString stringWithFormat:@"%d%@%@",year1,monthStr,dayStr];
                        [arrayTemp addObject:dateStr];
                    }

                }
                break;
            }
            countTemp++;
        }
    }
    }
    NSLog(@"arrayTemp:%@",arrayTemp);
    return arrayTemp;
}
//是否是法定节假日
+(BOOL)isLegalHoliday:(NSInteger )monthTemp andDay:(NSInteger )dayTemp{
      //想做一个放假调休的函数太复杂,暂时算出一年的吧
    switch (monthTemp) {
        case 1:
            if (dayTemp>=1 && dayTemp<=3) {
                return YES;
            }
            break;
        case 2:
            if (dayTemp>=7 && dayTemp<=13) {
                return YES;
            }
            break;
        case 4:
            if (dayTemp==4) {
                return YES;
            }
            break;
        case 5:
            if (dayTemp>=1 && dayTemp<=2) {
                return YES;
            }
            break;
        case 6:
            if (dayTemp>=9 && dayTemp<=11) {
                return YES;
            }
            break;
        case 9:
            if (dayTemp>=15 && dayTemp<=17) {
                return YES;
            }
            break;
        case 10:
            if (dayTemp>=1 && dayTemp<=7) {
                return YES;
            }
            break;

        default:
            break;
    }
    return NO;
}

//是不是调休
+(BOOL)isAdjustDay:(NSInteger )monthTemp andDay:(NSInteger )dayTemp{

    switch (monthTemp) {
        case 2:
            if (dayTemp==6 || dayTemp==14) {
                return YES;
            }
            break;
        case 6:
            if (dayTemp==12) {
                return YES;
            }
            break;
        case 9:
            if (dayTemp==18) {
                return YES;
            }
            break;
            break;
        case 10:
            if (dayTemp==8 || dayTemp==9 ) {
                return YES;
            }
            break;
        default:
            break;
    }
    return NO;
}

+(NSString *)GetYear{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetMonth{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];

    return date;
}

+(NSString *)GetDay{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetHour{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetMinute{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetSecond{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"ss"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}
+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

/**
 公历y年某m+1月的天数

 @param y 年
 @param m 月

 @return 公历y年某m+1月的天数
 */
+(NSInteger)solarDays:(NSInteger)y m:(NSInteger)m
{
    NSArray *solarMonth = @[@31,@28,@31,@30,@31,@30,@31,@31,@30,@31,@30,@31];
    if(m == 2){
        return (((y % 4 == 0) && ( y % 100 != 0 )) ||
                (y % 400 == 0)) ? 29 : 28;
    } else {
        return [solarMonth[m-1] intValue];
    }
}

//获取一年有多少天
+(int)GetOneYearCountDay:(int)year{
    int countDay = 0;
    for (int i=1; i<=12; i++) {
        int countDay1 =(int)[self solarDays:year m:i];
        countDay = countDay + countDay1;
    }
    return countDay+2;
}

//获取某一个月的时间表
+(NSMutableArray *)GetOneMonthByYear:(int)year andMonth:(int)month{
    NSMutableArray *array = [NSMutableArray array];
    int countDay =(int)[self solarDays:year m:month];

    NSString *monthStr = nil;
    NSString *dayStr = nil;
    NSString *dateStr = nil;
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%d",month];
    }else{
        monthStr = [NSString stringWithFormat:@"%d",month];
    }

    for (int i=1; i<=countDay; i++) {
        if (i<10) {
            dayStr = [NSString stringWithFormat:@"0%d",i];
        }else{
            dayStr = [NSString stringWithFormat:@"%d",i];
        }
        dateStr = [NSString stringWithFormat:@"%d%@%@",year,monthStr,dayStr];
        [array addObject:dateStr];
    }
    return array;
}

//获取一年的时间表,只有一个数组
+(NSMutableArray *)GetOneYear:(int)year {
    NSMutableArray *array = [NSMutableArray array];
    for (int i=1; i<=12; i++) {

        int countDay =(int)[self solarDays:year m:i];
        for (int j=1; j<=countDay; j++) {
            NSString *monthStr = nil;
            NSString *dayStr = nil;
            NSString *dateStr = nil;
            if (i < 10) {
                monthStr = [NSString stringWithFormat:@"0%d",i];
            }else{
                monthStr = [NSString stringWithFormat:@"%d",i];
            }
            if (j<10) {
                dayStr = [NSString stringWithFormat:@"0%d",j];
            }else{
                dayStr = [NSString stringWithFormat:@"%d",j];
            }
            dateStr = [NSString stringWithFormat:@"%d%@%@",year,monthStr,dayStr];
            [array addObject:dateStr];
        }

    }
    int countDay1 = (int)[self solarDays:year-1 m:12];
    NSString  *dateStrFirst = [NSString stringWithFormat:@"%d%d%d",year-1,12,countDay1];
    [array insertObject:dateStrFirst atIndex:0];

    NSString  *dateStrLast = [NSString stringWithFormat:@"%d0101",year+1];
    [array addObject:dateStrLast];

    return array;
}

//获取某一天是一年中第几天
+(int)GetOneDayIndexInOneYear:(int)year andMonth:(int)month andDay:(int)day{
    int countDay = 0;
    for (int i=1; i<=month-1; i++) {
         int countDay1 =(int)[self solarDays:year m:i];
         countDay = countDay + countDay1;
    }
    countDay = countDay+day;
    return countDay+1;
}





@end
