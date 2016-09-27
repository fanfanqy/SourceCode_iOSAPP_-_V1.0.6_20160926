//
//  CalendarMainPagesModel.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/5/30.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Datetime.h"
#import "calendarDBModel.h"
#import "ZangLiModel.h"
#import "DateSource.h"
#import "wanNianLiTool.h"
#import "WanNianLiDate.h"
#import "CalendarModel.h"

@interface CalendarMainPagesModel : NSObject
/**
 *  CalendarModel Array
 */
@property (strong, nonatomic)NSMutableArray *modelArray;


@property (nonatomic,strong) NSDictionary *jianFa;
-(instancetype)initWithReceiveData:(int)countday andYear:(int)year;
-(NSMutableArray *)readDataFromDB;
@end
