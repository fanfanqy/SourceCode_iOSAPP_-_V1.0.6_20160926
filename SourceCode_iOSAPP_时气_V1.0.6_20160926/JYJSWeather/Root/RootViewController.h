//
//  RootViewController.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma wq 1
#import "ToolVC.h"
@class DBModel;
@interface RootViewController : UIViewController
@property (nonatomic, strong) DBModel             * locationCityModel;
@property (strong, nonatomic) NSMutableArray      * cityArray; // 城市名称
@property (strong, nonatomic) NSMutableArray      * userCityArray;
@property (nonatomic,assign)BOOL isRefreshing;
@property (nonatomic, strong) DBModel             * nowCityModel;               // 正在显示天气的城市信息
@property (nonatomic , assign) NSInteger          type;
#pragma wq 1
@property (nonatomic, strong) ToolVC                    * leftViewController;
- (void)handleData;
-(void)handleWeatherAndCityData;
- (void) fromWeatherInsidetoHomeWithCityModel:(DBModel *)city WeatherArray:(NSMutableArray *)weatherArray AndType:(NSInteger)type andIsCalendarInsidePagesBack:(BOOL)isBackOrPush;
//- (void)reloadWeatherCell;
- (void)requestWallpaperList;
@end
