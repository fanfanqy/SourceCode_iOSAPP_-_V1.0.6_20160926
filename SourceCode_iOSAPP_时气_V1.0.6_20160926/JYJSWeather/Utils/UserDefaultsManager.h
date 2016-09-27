//
//  UserDefaultsManager.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/9/27.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject
//气象源
+(void)saveMeteorologicalSource:(NSInteger)meteorologicalSource;
//是否显示实时背景
+(void)savveRealtimeWeatherBackground:(NSInteger)realtimeWeatherBackground;
//
@end
