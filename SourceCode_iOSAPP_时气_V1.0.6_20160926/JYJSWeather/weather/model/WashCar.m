//
//  WashCar.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/6/14.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WashCar.h"
#import "WeatherModel.h"

#define nosuit @"不适宜"
#define suit @"适宜"
#define notverySuit @"较不适宜"


@interface WashCar ()
@property (nonatomic , strong) NSArray * suitArray; // 适宜洗车的天气
@property (nonatomic , strong) NSArray * noSuitArray; // 不适宜洗车的天气
@end
@implementation WashCar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.suitArray = @[@"cloudy",@"clear",@"mostlycloudy",@"mostlysunny",@"partlycloudy",@"partlysunny",@"sunny"];
        self.noSuitArray = @[@"rain",@"chanceflurries",@"chancerain",@"chancesleet",@"chancesnow",@"chancetstorms",@"fog",@"hazy",@"sleet",@"snow",@"tstorms"];
    }
    return self;
}
+ (NSMutableArray *)suitableForCarWashDayWithArray:(NSMutableArray *)array
{
    NSMutableArray * resultArray = [NSMutableArray array];
    WashCar * washcar = [[WashCar alloc]init];
    for (int i = 0; i < array.count; i++) {
        WeatherModel * model = [array objectAtIndex:i];
        NSString * icon = model.icon;
        
        if ([washcar.noSuitArray containsObject:icon]) {
            [resultArray addObject:nosuit];
        } else {
            if (i+1 == array.count) {
                [resultArray addObject:suit];
            } else {
                WeatherModel * model = [array objectAtIndex:i+1];
                NSString * icon = model.icon;
                if ([washcar.noSuitArray containsObject:icon]) {
                    [resultArray addObject:notverySuit];
                } else {
                    [resultArray addObject:suit];
                }
            }
            
        };
        
    }
    NSLog(@"%@", resultArray.lastObject);
    return resultArray;
}
@end
