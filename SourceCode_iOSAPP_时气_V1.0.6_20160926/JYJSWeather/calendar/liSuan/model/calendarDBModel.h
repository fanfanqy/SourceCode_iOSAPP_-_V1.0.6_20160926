//
//  calendarDBModel.h
//  历算
//
//  Created by han on 14/12/6.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  日历数据库model,数据意义参加falvcalendar.db,下面数据2016年4月16号
 */
@interface calendarDBModel : NSObject
@property (nonatomic,copy) NSString * ID;//20160416.阳历日期
@property (nonatomic,copy) NSString * lid;//20160308.农历日期
@property (nonatomic,copy) NSString * week;//4.星期4
@property (nonatomic,copy) NSString * weekName;//eg.星期四
@property (nonatomic,copy) NSString * lYear;//2016.农历年份
@property (nonatomic,copy) NSString * lMonth;//3.农历月份
@property (nonatomic,copy) NSString * lDay;//8.农历天份
@property (nonatomic,copy) NSString * lYearName;//猴.农历年名
@property (nonatomic,copy) NSString * lMonthName;//季春.农历月名
@property (nonatomic,copy) NSString * lDayName;//初八.农历天名
@property (nonatomic,copy) NSString * yearZhu;//丙申.纪年
@property (nonatomic,copy) NSString * monthZhu;//壬辰.纪月
@property (nonatomic,copy) NSString * dayZhu;//丙寅.纪日
@property (nonatomic,copy) NSString * wxYear;//火.阴阳五行
@property (nonatomic,copy) NSString * wxMonth;//水.阴阳五行
@property (nonatomic,copy) NSString * wxDay;//火.阴阳五行
@property (nonatomic,copy) NSString * jieQi;//节气.2016-4-19,谷雨
@property (nonatomic,copy) NSString * jieQiTime;//节气时间.23:29:31
@property (nonatomic,copy) NSString * dayShierJianXing;//老皇历十二日建
@property (nonatomic,copy) NSString * dayErShiBaXingSu;//角.28宿
@property (nonatomic,copy) NSString * dayAnimal;//宜的属相
@property (nonatomic,copy) NSString * chongAnimal;//冲的属相
@property (nonatomic,copy) NSString * gongLiJieRi;//公历节日
@property (nonatomic,copy) NSString * nongLIjieRi;//农历节日
@property (nonatomic,copy) NSString * gd;//宜
@property (nonatomic,copy) NSString * bd;//忌
@property (nonatomic,copy) NSString * pssd;
@property (nonatomic,copy) NSString * jixiong;//吉凶平
//@property (nonatomic,strong) NSMutableArray * dataArray;//
//@property (nonatomic,strong) NSMutableArray * birArr;


@end
