//
//  IndexTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
@class DBModel;

//内页指数cell
@interface IndexTableViewCell : UITableViewCell

@property (nonatomic , strong) IndexButton *dress; // 穿衣

@property (nonatomic , strong) IndexButton *washCar; // 洗车

@property (nonatomic , strong) IndexButton *limitNumber; // 限号

@property (nonatomic , strong) IndexButton *ultraviolet; // 紫外线

@property (nonatomic , strong) NSMutableArray *array;
@property (nonatomic , strong) UIViewController *viewControllerDelegate;
@property (nonatomic, strong) DBModel             * nowCityModel;
@property (nonatomic , assign) NSInteger aqi;
@property (nonatomic , assign) NSInteger index;
// 更改洗车指数
- (void)setWashcarWithIndex:(NSInteger)index;
@end
