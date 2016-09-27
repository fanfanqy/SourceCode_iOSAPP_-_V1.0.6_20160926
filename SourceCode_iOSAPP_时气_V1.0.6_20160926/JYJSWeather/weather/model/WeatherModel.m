//
//  WeatherModel.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/18.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WeatherModel.h"
#import "AppDelegate.h"
@implementation WeatherModel
+ (NSMutableArray *)analysisDataWithArray:(NSDictionary *)dictionary
{
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray * resultArray = [NSMutableArray array];
//    if (delegate.meteorologicalSource == 1) {

        NSArray *array = [[[dictionary objectForKey:@"forecast"] objectForKey:@"simpleforecast"]objectForKey:@"forecastday"];
        for (NSDictionary * dictionary in array) {
            WeatherModel * model = [[WeatherModel alloc]init];
            model.nowtemp = nil;
            model.maxtemp = [[dictionary objectForKey:@"high"] objectForKey:@"celsius"];
            model.mintemp = [[dictionary objectForKey:@"low"] objectForKey:@"celsius"];
            model.year = [[[dictionary objectForKey:@"date"]objectForKey:@"year"] integerValue];
            model.month = [[[dictionary objectForKey:@"date"]objectForKey:@"month"] integerValue];
            model.day = [[[dictionary objectForKey:@"date"]objectForKey:@"day"] integerValue];
            NSString * weekEN = [[dictionary objectForKey:@"date"]objectForKey:@"weekday"];
            NSString * weekPath =[[NSBundle mainBundle] pathForResource:@"week" ofType:@"plist"];
            NSDictionary *dicWeek =[NSDictionary dictionaryWithContentsOfFile:weekPath];
            model.week = [dicWeek objectForKey:weekEN];
            model.weather_txt = [dictionary objectForKey:@"conditions"];
            model.mirror = [dictionary objectForKey:@"icon"]; // 准提镜
            model.icon = [dictionary objectForKey:@"icon"];
            model.pollution = @"未找到"; // 污染
            
            // 判断风力等级
            CGFloat win = [[[dictionary objectForKey:@"avewind"] objectForKey:@"kph"]floatValue];
            CGFloat v = win * 1000.0 / 3600.0;
            
            if (v<0.2) {
                model.wind = 0;
            }else if (v>= 0.3 && v <=1.5){
                model.wind = 1;
            }else if (v >=1.6 && v <= 3.3){
                model.wind = 2;
            }else if (v >= 3.4 && v <= 5.4){
                model.wind = 3;
            }else if (v>= 5.5 && v <=7.9){
                model.wind = 4;
            }else if (v >=8.0 && v <= 10.7){
                model.wind = 5;
            }else if (v >= 10.8 && v <= 13.8){
                model.wind = 6;
            }else if (v>= 13.9 && v <=17.1){
                model.wind = 7;
            }else if (v >=17.2 && v <= 20.7){
                model.wind = 8;
            }else if (v >= 20.8 && v <= 24.4){
                model.wind = 9;
            }else if (v>= 24.5 && v <=28.4){ 
                model.wind = 10;
            }else if (v >=28.5 && v <= 32.6){
                model.wind = 11;
            }else if (v >= 32.7 && v <= 36.9){
                model.wind = 12;
            }else{
                model.wind = 13;
            }
            model.directionOfwind = [[dictionary objectForKey:@"avewind"] objectForKey:@"dir"];
            if ((NSNull *)model.directionOfwind == [NSNull null]) {
                model.directionOfwind = @"";
            }
            model.humidity = [[dictionary objectForKey:@"avehumidity"] integerValue];
            [resultArray addObject:model];
        }
        if (resultArray.count > 0) {
            WeatherModel * model = [resultArray objectAtIndex:0];
            model.nowtemp = [NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"current_observation"] objectForKey:@"temp_c"]];
            NSString * icon_url = [NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"current_observation"] objectForKey:@"icon_url"]];
            NSString * icon = [[icon_url componentsSeparatedByString:@"/"]lastObject];
            model.mirror = [[icon componentsSeparatedByString:@"."]firstObject];
            if ([[dictionary objectForKey:@"current_observation"] objectForKey:@"feelslike_c"]) {
                model.feelslike_c = [[dictionary objectForKey:@"current_observation"] objectForKey:@"feelslike_c"];
            }else{

                model.feelslike_c = @"-1";
            }
            if ([[dictionary objectForKey:@"current_observation"] objectForKey:@"UV"]) {
                model.xray = [[dictionary objectForKey:@"current_observation"] objectForKey:@"UV"];
            }else{
                model.xray = @"-1";
            }
            
        }
//    }
//    else {
//        // 国内气象数据解析
//    }

    return resultArray;
}

@end
