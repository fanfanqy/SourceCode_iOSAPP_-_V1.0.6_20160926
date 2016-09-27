//
//  dbTool.m
//  XJKJwnl
//
//  Created by xjkjmac02 on 14-11-20.
//  Copyright (c) 2014年 xjkjmac02. All rights reserved.
//

#import "dbTool.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "Calendary.h"
#import <UIKit/UIKit.h>
#import "WanNianLiDate.h"
#import "Datetime.h"
#define DBNAME @"falvcalendar.db"

@implementation dbTool

+ (NSString*) getPathWithDBName:(NSString *)DBName
{
    NSArray* arr = [DBName componentsSeparatedByString:@"."];
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:[arr objectAtIndex:0] ofType:[arr objectAtIndex:1]];
    return databasePath;
}

#pragma mark - 从数据库中读取数据存入模型中

+(NSMutableArray*)selectAllWithStartYear:(int)startYear startMonth:(int)startMonth endYear:(int)endYear endMonth:(int)endMonth cate:(NSString *)cate tag:(int)tag
{
    NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
    NSMutableArray * dateArray = [[NSMutableArray alloc] init];//存有一个字典一个数组
    NSMutableArray * keyArray = [[NSMutableArray alloc] init];//存有字典的key值的数组
    NSDictionary * liFa = @{@"初一":@"生命短",@"初二":@"病多,麻烦多",@"初三":@"变成富裕人家",@"初四":@"怀业增广,气色好",@"初五":@"增长财物",@"初六":@"气色转衰",@"初七":@"易招闲言，麻烦多",@"初八":@"长寿",@"初九":@"易遇年轻女子",@"初十":@"增长快乐",@"十一":@"增长出世间的智慧与世间的聪明",@"十二":@"招病,生命危险",@"十三":@"精进于佛法，最好",@"十四":@"东西增多",@"十五":@"增上福报",@"十六":@"得病",@"十七":@"容易失明,皮肤变绿",@"十八":@"丢失财物",@"十九":@"佛法增长",@"二十":@"容易挨饿，不好",@"二十一":@"易招传染病",@"二十二":@"病情加重",@"二十三":@"家族富裕",@"二十四":@"遇传染病",@"二十五":@"得沙眼，出迎风泪",@"二十六":@"得安乐",@"二十七":@"吉祥",@"二十八":@"易发生打架",@"二十九":@"掉魂,声音变哑",@"三十":@"预见被争讼及死人",@"十月初八":@"忏净罪孽",@"十一月初八":@"忏净罪孽",@"十二月二十五":@"增长智慧"};
    FMDatabase* database= [WanNianLiDate getDataBase];

    if (![database open]) {
        return NULL;
//        NSLog(@"数据库没有打开！！！");
    }
    int month;
    if (startYear == endYear) {
        month = endMonth- startMonth + 1;
    }else {
        month = (endYear - startYear - 1) * 12 + (13 - startMonth) + endMonth;
    }
    for (int i = 0;i < month;i++) {
        if (startMonth == 13) {
            startMonth = 1;
            startYear +=1;
        }
        int day = [Datetime GetNumberOfDayByYera:startYear andByMonth:startMonth];
        NSString * sql;
        if (startMonth < 10) {
            sql = [NSString stringWithFormat:@"select * from calendar where id between  '%d0%d01' and '%d0%d%d'",startYear,startMonth,startYear,startMonth,day];
        }else {
            sql = [NSString stringWithFormat:@"select * from calendar where id between '%d%d01' and '%d%d%d'",startYear,startMonth,startYear,startMonth,day];
        }
        FMResultSet* resultSet=[database executeQuery:sql];
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        int i = 1;//作为每月的日期  从1号到月底
        while ([resultSet next]) {
            Calendary *date = [[Calendary alloc] init];
            date._id = [resultSet stringForColumn:@"id"];
            date.lDayName = [resultSet stringForColumn:@"lDayName"];
            date.lMonth = [resultSet stringForColumn:@"lMonth"];
            date.jieQi = [resultSet stringForColumn:@"jieQi"];
            date.jieQiTime = [resultSet stringForColumn:@"jieQiTime"];
            date.nongLiJieRi = [resultSet stringForColumn:@"nongLiJieRi"];
            date.gongLiJieRi = [resultSet stringForColumn:@"gongLiJieRi"];
            date.lDay = [resultSet stringForColumn:@"lDay"];
            NSString * gid = [resultSet stringForColumn:@"gd"];
            if (tag >= 13 || tag <= 17) {
                FMResultSet * setGd = [database executeQuery:[NSString stringWithFormat:@"select * from gdb where gid=%@",gid]];
                while ([setGd next]) {
                    date.gd  = [setGd stringForColumn:@"val"];
                }
                NSRange range = [date.gd rangeOfString:cate];
                if (range.length>0) {
                    [arr addObject:date];
                }
                date.height = [self getHeightWithText:date.gd];
            }
            if (tag == 11) {
                //假日数据
                if (date.gongLiJieRi.length != 0 || date.nongLiJieRi.length != 0) {
                    [arr addObject:date];
                    date.height = [self getHeightWithText:[NSString stringWithFormat:@"%@ %@",date.gongLiJieRi,date.nongLiJieRi]];
                }
            }
            if (tag == 12) {
                //节气数据
                if (date.jieQi.length != 0) {
                    [arr addObject:date];
                    date.height = [self getHeightWithText:date.jieQi];
                }
            }

        i++;
        }
        if (arr.count > 0) {
            NSString * key = [NSString stringWithFormat:@"%d年%d月%@",startYear,startMonth,cate];
            [dateDic setObject:arr forKey:key];
            [keyArray addObject:key];
        }
        startMonth++;
    }
    [dateArray addObject:keyArray];
    [dateArray addObject:dateDic];
    [database close];

    return dateArray;
}
#pragma mark - 根据内容确定label的高度
+(CGFloat)getHeightWithText:(NSString *)text
{
    CGSize maxSize = CGSizeMake(ScreenWidth - 40, MAXFLOAT);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maxSize];
    return size.height;
}
@end
