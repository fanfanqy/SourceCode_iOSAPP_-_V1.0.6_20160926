//
//  NarrowWeatherCollectionViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
// 首页缩略天气
@interface NarrowWeatherCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel        *nowtemp;
@property (weak, nonatomic) IBOutlet UIImageView    *icon_up; // 上部天气图标
@property (weak, nonatomic) IBOutlet UILabel        *weather_txt; // 天气描述

@property (weak, nonatomic) IBOutlet UILabel        *max_mintemp; // 最高最低气温
@property (weak, nonatomic) IBOutlet UIImageView    *pollution; // 污染,空气质量
@property (weak, nonatomic) IBOutlet UILabel        *city;
@property (weak, nonatomic) IBOutlet UILabel        *windAndwet; // 风向and湿度
// 下部左侧

@property (weak, nonatomic) IBOutlet UIImageView    *icon_dwn_left;
@property (weak, nonatomic) IBOutlet UILabel        *date_left;
@property (weak, nonatomic) IBOutlet UILabel        *max_mintemp_left;
// 下部右侧

@property (weak, nonatomic) IBOutlet UIImageView    *icon_dwn_right;
@property (weak, nonatomic) IBOutlet UILabel        *date_right;
@property (weak, nonatomic) IBOutlet UILabel        *max_mintemp_right;


@end
