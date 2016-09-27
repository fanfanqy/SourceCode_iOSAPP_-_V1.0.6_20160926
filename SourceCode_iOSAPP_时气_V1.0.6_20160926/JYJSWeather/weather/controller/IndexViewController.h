//
//  IndexViewController.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SqlDataBase.h"
/**
 *  天气指数
 */
@class DBModel;
@interface IndexViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *info; // 详情描述
@property (nonatomic , strong) NSMutableArray * otherArray; // 目前用来存放适不适宜洗车的指数
@property (nonatomic , strong) NSMutableArray * array;
@property (weak, nonatomic) IBOutlet UILabel *city; // 城市
@property (weak, nonatomic) IBOutlet UIImageView *pollution; // 空气指数
@property (weak, nonatomic) IBOutlet UILabel *nowtemp;

@property (weak, nonatomic) IBOutlet UILabel *max_min_temp; // 最大最小温度
@property (weak, nonatomic) IBOutlet UILabel *weather_txt; // 天气描述
@property (weak, nonatomic) IBOutlet UILabel *wind; // 风向风力
@property (weak, nonatomic) IBOutlet UILabel *suntime; //日出日落时间

@property (nonatomic , strong) UIImage *image;
@property (nonatomic, strong) DBModel             * nowCityModel;               // 正在显示天气的城市信息
@property (nonatomic, assign) NSInteger aqi;
@property (nonatomic, assign) NSInteger indexpath;
@end
