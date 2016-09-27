//
//  CalendarModel.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/6/6.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarModel : NSObject

/**
 *  吉凶平
 */
@property (nonatomic , strong)NSString *luckyImageType;
//阳历日子
@property (nonatomic , strong) NSString * solarStr;
/**
 *  农历日子
 */
@property (nonatomic , strong) NSString * lunarStr;
/**
 *  星期四
 */
@property (nonatomic , strong) NSString * weekStr;
/**
 *  节气或节日
 */
@property (nonatomic , strong) NSString * FestivalStr;
/**
 *  纪年
 */
@property (nonatomic , strong) NSString * JiNianStr;
/**
 *  洗发
 */
@property (nonatomic , strong) NSMutableArray * hairWashArray;
/**
 *  理发
 */
@property (nonatomic , strong) NSMutableArray * HaircutStrArray;
/**
 *  宜
 */
@property (nonatomic , strong) NSMutableArray * YiStrArray;
/**
 *  忌
 */
@property (nonatomic , strong) NSMutableArray * JiStrArray;
/**
 *  宗教节日,更改为农历节日+公历节日
 */
@property (nonatomic , strong) NSMutableArray * ReligionFestivalStrArray;

/**
 *  冲的动物
 */
@property (nonatomic , strong) NSString * ChongAnimalStr;

/**
 *  宗教节日,更改为农历节日+公历节日
 */
@property (nonatomic , strong) NSString * religionFestivalStr;

//节气,农历公历节日
@property (nonatomic , strong) NSString *jieqiStr;

/**
 *  吉时
 */
@property (nonatomic , strong) NSString * LuckyhourStr;

/**
 *  凶时
 */
@property (nonatomic , strong) NSString * badhouStr;
@end
