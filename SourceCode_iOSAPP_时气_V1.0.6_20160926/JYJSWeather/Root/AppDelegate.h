//
//  AppDelegate.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/2/25.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NetWorkMonitor.h"
#import "Reachability.h"
@class DBModel;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Reachability *hostReach;
/*
 * 1 国外气象源
 * 2 国内气象源
 */
@property (nonatomic, readonly) NSInteger reachableCount;
@property (nonatomic , assign) NSInteger meteorologicalSource; // 记录气象源
@property (nonatomic , assign) NSInteger realtimeWeatherBackground; // 记录是否使用实时天气背景
@property (nonatomic , strong) UIActivityIndicatorView *loadView; //正在加载
@property (nonatomic , strong) UILabel * requestErrorView; // 请求异常处理视图

//语言地区编码
@property (nonatomic , strong) NSString * languageCode;
@property (nonatomic , strong) DBModel * nowCity;

// 添加请求失败视图
- (void)addRequestErrorView;
// 添加正在加载视图
- (void)addLoadView;
- (void)removeLoadView;
- (NSInteger)readUserDefaults;
- (void)saveUserDefaults;
//- (void)savveRealtimeWeatherBackground;

@end

