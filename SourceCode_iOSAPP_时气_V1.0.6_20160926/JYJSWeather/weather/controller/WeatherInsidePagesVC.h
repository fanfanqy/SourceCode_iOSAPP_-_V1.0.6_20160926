//
//  WeatherInsidePagesVC.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DBModel;
/**
 *  天气内页
 */


@interface WeatherInsidePagesVC : UIViewController
@property (nonatomic , strong) NSMutableArray   *array;
@property (nonatomic , strong) NSMutableArray   * cityArray; // 城市名称
@property (nonatomic , strong) DBModel          * nowCityModel;               // 正在显示天气的城市信息
@property (nonatomic , strong) DBModel          * locationCityModel; // 定位城市
@property (nonatomic , strong) UITableView      * table;
@property (nonatomic , assign) NSInteger          aqi;
@property (nonatomic , assign) BOOL               isRefreshing;
@property (nonatomic , assign) NSInteger          type;


@end
