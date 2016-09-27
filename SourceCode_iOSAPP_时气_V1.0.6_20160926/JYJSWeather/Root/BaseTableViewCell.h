//
//  BaseTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DBModel;
@interface BaseTableViewCell : UITableViewCell
@property (nonatomic , assign) NSInteger type;


@property (nonatomic , assign) CGFloat cellHeight;

@property (nonatomic , strong) UIViewController *viewControllerDelegate;

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UICollectionView * otherCollectionView;

@property (nonatomic , strong) NSMutableArray *array;
@property (nonatomic , strong) NSMutableArray *otherArray;
@property (nonatomic , assign) int pages;
@property (nonatomic , assign) int isFirst;
@property (nonatomic , strong) DBModel * cityModel; // 仅 NarrowWeatherTableViewCell 用到
@property (nonatomic , assign) NSInteger countRows;
@property (nonatomic , strong) DBModel  * locationCityModel; // 定位城市
@property (nonatomic , assign) BOOL isRefresh;//是不是下拉刷新,刷新 tableView 的
@property (nonatomic, assign) NSInteger aqi; // 空气质量 只天气cell用到

@end
