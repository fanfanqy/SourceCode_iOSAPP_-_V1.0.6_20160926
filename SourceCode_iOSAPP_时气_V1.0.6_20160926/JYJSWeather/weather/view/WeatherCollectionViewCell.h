//
//  WeatherCollectionViewCell.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/8/1.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *mirror; // 准提镜
@property (strong, nonatomic)  UILabel *nowtemp; // 当前温度
@property (strong, nonatomic)  UILabel *date; // 日期
@property (strong, nonatomic)  UILabel *week;

@property (strong, nonatomic)  UILabel *max_mintemp; // 最大最小温度
@property (strong, nonatomic)  UILabel *weather_txt; // 天气描述
@property (strong, nonatomic)  UIImageView *pollution; // 污染
@property (strong, nonatomic)  UIImageView *person; // 人物
@property (strong, nonatomic)  UIWebView *backgroundWebView;

@end
