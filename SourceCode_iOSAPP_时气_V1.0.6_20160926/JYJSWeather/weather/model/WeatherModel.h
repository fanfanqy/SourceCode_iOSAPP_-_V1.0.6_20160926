//
//  WeatherModel.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/18.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (nonatomic , copy)   NSString * nowtemp;          // 当前温度
@property (nonatomic , copy)   NSString * maxtemp;          // 最高温度
@property (nonatomic , copy)   NSString * mintemp;          // 最低温度
@property (nonatomic , assign) NSInteger year;              //年
@property (nonatomic , assign) NSInteger month;             // 月
@property (nonatomic , assign) NSInteger day;               // 日
@property (nonatomic , copy)   NSString * week;             //星期
@property (nonatomic , copy)   NSString * weather_txt;      // 天气描述
@property (nonatomic , copy)   NSString * pollution;        // 污染
@property (nonatomic , copy)   NSString * mirror;           // 准提镜
@property (nonatomic , assign) NSInteger  wind;             // 风力
@property (nonatomic , copy)   NSString * directionOfwind;  // 风向
@property (nonatomic , assign) NSInteger  humidity;         //湿度
@property (nonatomic , copy)   NSString * icon;
@property (nonatomic , copy)   NSString * feelslike_c;      //体感温度
@property (nonatomic , copy)   NSString * xray;             //紫外线
@property (nonatomic , strong) NSDate   * riseTime;         // 太阳升起的时间
@property (nonatomic , strong) NSDate   * setTime;          // 太阳降落的时间
@property (nonatomic , assign) BOOL       isSunrise;
@property (nonatomic , assign) BOOL       isSunset;
+ (NSMutableArray *)analysisDataWithArray:(NSDictionary *)dictionary;
@end
