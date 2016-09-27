//
//  Date+string.m
//  iPhone4OriPhone5
//
//  Created by cqsxit on 13-11-15.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "Date+string.h"

@implementation Date_string

+ (NSString *)setYearBaseSting:(NSString *)Yearstring{
 NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"year" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSMutableDictionary * dicBase =[[NSMutableDictionary  alloc] init];
    for (NSString * key in dic.allKeys) {
        [dicBase setObject:key forKey:dic[key]];
    }
    return  dicBase[Yearstring];
}

+ (NSArray*)setYearsToPick
{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"year" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSArray *_sortedArray= [(NSArray*)[dic allValues] sortedArrayUsingSelector:@selector(compare:)];
    return  _sortedArray;
}

+ (NSString *)setMonthBaseSting:(NSString *)Monthstring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"month" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSMutableDictionary * dicBase =[[NSMutableDictionary  alloc] init];
    
    for (NSString * key in dic.allKeys) {
        [dicBase setObject:key forKey:dic[key]];
    }
    
    if([Monthstring length] == 3)
    {
        Monthstring = [NSString stringWithFormat:@"0%@",Monthstring];
    }
    
    return  dicBase[Monthstring];
}

+ (NSString *)setDayBaseSting:(NSString *)Daystring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"day" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSMutableDictionary * dicBase =[[NSMutableDictionary  alloc] init];
    for (NSString * key in dic.allKeys) {
        [dicBase setObject:key forKey:dic[key]];
    }
    return  dicBase[Daystring];
}

/******************/
+(NSString *)setYearInt:(NSString *)Yearstring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"year" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSString * year =[dic objectForKey:Yearstring];
    return year;
}

+(NSString *)setMonthInt:(NSString *)Monthstring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"month" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    
    NSString * strMonth =[[[dic objectForKey:Monthstring] componentsSeparatedByString:@"x"] firstObject];
    return strMonth;
}

+(NSString *)setDayInt:(NSString *)Daystring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"day" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSString * day =[dic objectForKey:Daystring];
    return day;
}

+(NSString *)setReservedInt:(NSString *)Monthstring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"month" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    
    NSString * strMonth =[[[dic objectForKey:Monthstring] componentsSeparatedByString:@"x"] lastObject];
    return strMonth;
}


@end
