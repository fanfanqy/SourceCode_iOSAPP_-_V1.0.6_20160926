//
//  CityNameTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/27.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityNameTableViewCell : UITableViewCell
@property (nonatomic , strong) UILabel * cityName;
@property (nonatomic , strong) UILabel * comment; // 注释
@property (nonatomic , strong) UIButton * addButton; // 添加
@end
